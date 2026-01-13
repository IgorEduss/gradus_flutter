import 'package:injectable/injectable.dart';
import '../../infrastructure/services/inflation_service.dart';
import '../entities/emprestimo.dart';
import '../repositories/i_emprestimo_repository.dart';
import '../repositories/i_compromisso_repository.dart';
import '../repositories/i_transacao_repository.dart';
import '../entities/transacao.dart';

@injectable
class CalcularInflacaoUseCase {
  final IEmprestimoRepository _emprestimoRepository;
  final ICompromissoRepository _compromissoRepository;
  final ITransacaoRepository _transacaoRepository;
  final IInflationService _inflationService;

  CalcularInflacaoUseCase(
    this._emprestimoRepository,
    this._compromissoRepository,
    this._transacaoRepository,
    this._inflationService,
  );

  Future<void> call(int usuarioId, {double? manualRate}) async {
    double? taxaInflacaoMensal;

    if (manualRate != null) {
      taxaInflacaoMensal = manualRate;
    } else {
      // 1. Fetch Inflation Rate
      taxaInflacaoMensal = await _inflationService.getLatestMonthlyInflation();
    }
    
    // Safety check: Needs valid user setting or default
    // For now, if API fails (returns null), we abort to be safe (or user manually inputs later)
    if (taxaInflacaoMensal == null) {
      // Return quietly, allowing UI to handle re-trigger execution or manual input
      return; 
    }

    if (taxaInflacaoMensal <= 0) return;

    final now = DateTime.now();

    // 2. Adjust Loans (Emprestimos)
    final emprestimos = await _emprestimoRepository.getEmprestimosAtivos();
    
    for (var emprestimo in emprestimos) {
      // Check if already adjusted this month
      if (emprestimo.dataUltimoAjusteInflacao != null &&
          emprestimo.dataUltimoAjusteInflacao!.month == now.month &&
          emprestimo.dataUltimoAjusteInflacao!.year == now.year) {
        continue;
      }
      
      // EXCEPTION: Only apply inflation starting from the NEXT month after creation.
      // If created in Current Month (or Future), skip.
      if (emprestimo.dataCriacao.month == now.month && emprestimo.dataCriacao.year == now.year) {
          continue;
      }

      final valorAjuste = emprestimo.saldoDevedorAtual * taxaInflacaoMensal;
      final novoSaldo = emprestimo.saldoDevedorAtual + valorAjuste;

      // Update Entity locally
      final updatedEmprestimo = Emprestimo(
        id: emprestimo.id,
        usuarioId: emprestimo.usuarioId,
        fundoOrigemId: emprestimo.fundoOrigemId,
        valorConcedido: emprestimo.valorConcedido,
        saldoDevedorAtual: novoSaldo,
        proposito: emprestimo.proposito,
        statusEmprestimo: emprestimo.statusEmprestimo,
        dataConcessao: emprestimo.dataConcessao,
        dataQuitacao: emprestimo.dataQuitacao,
        dataUltimoAjusteInflacao: now,
        dataCriacao: emprestimo.dataCriacao,
        dataAtualizacao: now,
      );

      await _emprestimoRepository.updateEmprestimo(updatedEmprestimo);
      
      // Record Transaction
      await _transacaoRepository.addTransacao(Transacao(
        id: 0, // Auto-increment
        usuarioId: usuarioId,
        valor: valorAjuste,
        dataTransacao: now,
        descricao: 'Ajuste de Inflação (Empréstimo) - ${(taxaInflacaoMensal * 100).toStringAsFixed(2)}%',
        tipoTransacao: 'AJUSTE_INFLACAO_EMPRESTIMO',
        emprestimoId: emprestimo.id,
        fundoPrincipalOrigemId: emprestimo.fundoOrigemId, 
        dataCriacao: now,
        dataAtualizacao: now,
      ));
    }

    // 3. Adjust Commitments (Compromissos)
    final compromissos = await _compromissoRepository.watchCompromissosAtivos().first;
    
    for (var compromisso in compromissos) {
      if (compromisso.ajusteInflacaoAplicavel && compromisso.valorTotalComprometido != null) {
        // Safety Check
        if (compromisso.dataUltimoAjusteInflacao != null &&
            compromisso.dataUltimoAjusteInflacao!.month == now.month &&
            compromisso.dataUltimoAjusteInflacao!.year == now.year) {
          continue;
        }

        // EXCEPTION: Only apply inflation starting from the NEXT month after creation.
        if (compromisso.dataCriacao.month == now.month && compromisso.dataCriacao.year == now.year) {
            continue;
        }

        final saldoRemanescente = compromisso.valorTotalComprometido! - 
            (compromisso.numeroParcelasPagas * compromisso.valorParcela);
        
        if (saldoRemanescente > 0) {
          final valorAjuste = saldoRemanescente * taxaInflacaoMensal;
          final novoValorTotal = compromisso.valorTotalComprometido! + valorAjuste;

          // Update Entity locally
          final updatedCompromisso = compromisso.copyWith(
            valorTotalComprometido: novoValorTotal,
            dataUltimoAjusteInflacao: now,
            dataAtualizacao: now,
          );

          // Update in DB
          await _compromissoRepository.updateCompromisso(updatedCompromisso);

           // Record Transaction
          await _transacaoRepository.addTransacao(Transacao(
            id: 0,
            usuarioId: usuarioId,
            valor: valorAjuste,
            dataTransacao: now,
            descricao: 'Ajuste de Inflação (Compromisso) - ${(taxaInflacaoMensal * 100).toStringAsFixed(2)}%',
            tipoTransacao: 'AJUSTE_INFLACAO_COMPROMISSO',
            compromissoId: compromisso.id,
            dataCriacao: now,
            dataAtualizacao: now,
          ));
        }
      }
    }
  }
}
