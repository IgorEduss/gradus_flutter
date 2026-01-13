import 'package:injectable/injectable.dart';
import '../entities/compromisso.dart';
import '../entities/emprestimo.dart';
import '../entities/transacao.dart';
import '../repositories/i_compromisso_repository.dart';
import '../repositories/i_emprestimo_repository.dart';
import '../repositories/i_fundo_repository.dart';
import '../repositories/i_transacao_repository.dart';

@injectable
class ProcessarCicloMensalUseCase {
  final ITransacaoRepository _transacaoRepository;
  final ICompromissoRepository _compromissoRepository;
  final IEmprestimoRepository _emprestimoRepository;
  final IFundoRepository _fundoRepository;

  ProcessarCicloMensalUseCase(
    this._transacaoRepository,
    this._compromissoRepository,
    this._emprestimoRepository,
    this._fundoRepository,
  );

  Future<void> call({
    required int usuarioId,
    required double valorPago,
    required List<Compromisso> compromissos,
    required double unidadePagamento,
  }) async {
    await _transacaoRepository.runTransaction(() async {
      // 1. Calculate Totals
      double totalDevidoFer = 0;
      double totalDevidoMsp = 0;

      for (var c in compromissos) {
        if (c.tipoCompromisso == 'FACILITADOR_FER') {
          totalDevidoFer += c.valorParcela;
        } else {
          totalDevidoMsp += c.valorParcela;
        }
      }

      final totalDevido = totalDevidoFer + totalDevidoMsp;

      // 2. Determine Allocation
      double valorParaFer = 0;
      double valorParaMsp = 0;

      if (valorPago >= totalDevido) {
        // Scenario C: Full or Surplus Payment
        valorParaFer = totalDevidoFer;
        valorParaMsp = valorPago - totalDevidoFer;
      } else {
        // Scenario B: Deficit
        // Priority: Pay FER
        if (valorPago >= totalDevidoFer) {
          valorParaFer = totalDevidoFer;
          valorParaMsp = valorPago - totalDevidoFer;
        } else {
          valorParaFer = valorPago;
          valorParaMsp = 0;
        }
      }

      // 3. Process Commitments (Write-off)
      for (var c in compromissos) {
        await _compromissoRepository.registrarPagamentoParcela(
          c.id,
          c.numeroParcelasPagas + 1,
        );

        await _transacaoRepository.addTransacao(Transacao(
          id: 0,
          usuarioId: usuarioId,
          valor: c.valorParcela,
          dataTransacao: DateTime.now(),
          descricao: 'Pagamento: ${c.descricao}',
          tipoTransacao: 'PAGAMENTO_COMPROMISSO',
          compromissoId: c.id,
          fundoPrincipalDestinoId: c.fundoPrincipalDestinoId,
          caixinhaDestinoId: c.caixinhaDestinoId,
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        ));
      }

      // 4. Handle FER Deficit (Automatic Loan)
      if (valorParaFer < totalDevidoFer) {
        final deficit = totalDevidoFer - valorParaFer;

        final fer = await _fundoRepository.getFundo('FER');
        if (fer == null) throw Exception('Fundo FER não encontrado');

        // Create Loan
        // Note: We need to create the loan entity first. 
        // Ideally the repo returns the ID, but our interface returns void for createEmprestimo?
        // Let's check IEmprestimoRepository. It returns Future<void>.
        // This is a problem if we need the ID for the transaction.
        // I'll assume for now we can't link it easily without refactoring repo to return ID.
        // Or we create the object with a temp ID and the repo handles it? No, repo inserts.
        // I will assume I need to refactor createEmprestimo to return int (ID).
        // For now, I'll proceed and note this limitation or fix it.
        // Actually, let's fix it. It's better.
        // But for this step, I'll use a placeholder logic or fetch the last inserted loan (risky).
        // Let's check `EmprestimoRepositoryImpl`. It uses `into(...).insert(...)` which returns ID.
        // So I should update the interface to return Future<int>.
        
        // Wait, I can't update the interface in the middle of writing this file.
        // I'll write the code assuming it returns int, and then go fix the interface.
        
        final emprestimoId = await _emprestimoRepository.createEmprestimo(Emprestimo(
          id: 0,
          usuarioId: usuarioId,
          fundoOrigemId: fer.id,
          valorConcedido: deficit,
          saldoDevedorAtual: deficit,
          proposito: 'Cobertura de Déficit Mensal',
          statusEmprestimo: 'ATIVO',
          dataConcessao: DateTime.now(),
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        )); // This assumes it returns int

        // Transaction for Loan Concession
        await _transacaoRepository.addTransacao(Transacao(
          id: 0,
          usuarioId: usuarioId,
          valor: deficit,
          dataTransacao: DateTime.now(),
          descricao: 'Empréstimo Automático (Déficit)',
          tipoTransacao: 'CONCESSAO_EMPRESTIMO',
          emprestimoId: emprestimoId, // Need ID here
          fundoPrincipalOrigemId: fer.id,
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        ));

        // Update FER Balance
        // Logic: Saldo FER += ValorPagoUsuario (Net Effect)
        // See previous detailed comment in repo.
        await _fundoRepository.updateSaldo(fer.id, fer.saldoAtual + valorParaFer);

        // Create Repayment Commitment (Ressarcimento)
        // Calculate installments based on unit payment
        // We need unidadePagamento. For now, assuming a default or passed param.
        // Ideally passed in call().
        // Let's assume passed in call() for now.
        
        final valorParcela = unidadePagamento; 
        final numeroParcelas = (deficit / valorParcela).ceil();

        await _compromissoRepository.createCompromisso(Compromisso(
          id: 0,
          usuarioId: usuarioId,
          descricao: 'Ressarcimento',
          tipoCompromisso: 'FACILITADOR_FER',
          valorTotalComprometido: deficit,
          valorParcela: valorParcela,
          numeroTotalParcelas: numeroParcelas,
          numeroParcelasPagas: 0,
          fundoPrincipalDestinoId: fer.id,
          caixinhaDestinoId: null,
          dataInicioCompromisso: DateTime.now(), // Starts now? Or next cycle? Usually next cycle.
          // Let's assume next cycle for repayment start.
          // But for simplicity, let's say it starts now (active).
          statusCompromisso: 'ATIVO',
          ajusteInflacaoAplicavel: true, // Loans usually have inflation adjustment
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        ));

      } else {
        // No Deficit
        final fer = await _fundoRepository.getFundo('FER');
        if (fer != null) {
          await _fundoRepository.updateSaldo(fer.id, fer.saldoAtual + valorParaFer);
        }
      }

      // 5. Update MSP
      if (valorParaMsp > 0) {
        final msp = await _fundoRepository.getFundo('MSP');
        if (msp != null) {
          await _fundoRepository.updateSaldo(msp.id, msp.saldoAtual + valorParaMsp);
        }
      }
    });
  }
}
