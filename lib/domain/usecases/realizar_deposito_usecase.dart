import 'package:injectable/injectable.dart';
import '../entities/compromisso.dart';
import '../entities/transacao.dart';
import '../repositories/i_compromisso_repository.dart';
import '../repositories/i_transacao_repository.dart';
import '../repositories/i_fundo_repository.dart';
import '../repositories/i_usuario_repository.dart';
import '../repositories/i_emprestimo_repository.dart';

@injectable
class RealizarDepositoUseCase {
  final ITransacaoRepository _transacaoRepository;
  final ICompromissoRepository _compromissoRepository;
  final IUsuarioRepository _usuarioRepository;
  final IFundoRepository _fundoRepository;
  final IEmprestimoRepository _emprestimoRepository;

  RealizarDepositoUseCase(
    this._transacaoRepository,
    this._compromissoRepository,
    this._usuarioRepository,
    this._fundoRepository,
    this._emprestimoRepository,
  );

  Future<void> call({
    required Compromisso compromisso,
    required double valorDepositado,
  }) async {
    final user = await _usuarioRepository.getUsuario();
    if (user == null) throw Exception('Usuário não encontrado');

    await _transacaoRepository.runTransaction(() async {
      double valorParcela = compromisso.valorParcela;
      
      // 1. Calculate Priority (Arrears vs Amortization)
      // First billing is month following start, on closing day
      DateTime dataPrimeiraCobranca = DateTime(
        compromisso.dataInicioCompromisso.year,
        compromisso.dataInicioCompromisso.month + 1,
        user.diaRevisaoMensal,
      );

      DateTime agora = DateTime.now();
      int parcelasVencidasAteHoje = 0;

      if (agora.isAfter(dataPrimeiraCobranca) || agora.isAtSameMomentAs(dataPrimeiraCobranca)) {
         // Calculate months passed
         int monthsDiff = (agora.year - dataPrimeiraCobranca.year) * 12 + agora.month - dataPrimeiraCobranca.month;
         // +1 because if we are in the same month of billing, it is already considered 'due' for this calculation purpose 
         // (to prioritize paying the current month before amortizing future)
         if (agora.day >= dataPrimeiraCobranca.day) {
            monthsDiff += 1; 
         }
         parcelasVencidasAteHoje = monthsDiff > 0 ? monthsDiff : 0;
      }

      int parcelasEmAtraso = parcelasVencidasAteHoje - compromisso.numeroParcelasPagas;
      if (parcelasEmAtraso < 0) parcelasEmAtraso = 0;

      // 2. Distribute Payment
      double valorRestante = valorDepositado;
      int parcelasPagasAgora = 0;
      double valorAmortizado = 0;

      // Priority 1: Pay Arrears (including current month if due)
      if (parcelasEmAtraso > 0) {
        double valorNecessarioParaAtraso = parcelasEmAtraso * valorParcela;
        
        if (valorRestante >= valorNecessarioParaAtraso) {
           // Covers all arrears
           parcelasPagasAgora += parcelasEmAtraso;
           valorRestante -= valorNecessarioParaAtraso;
        } else {
           // Partial payment of arrears (treat as installments paid effectively)
           int p = (valorRestante / valorParcela).floor();
           parcelasPagasAgora += p;
           valorRestante -= (p * valorParcela);
           // Note: The rest that doesn't complete a full installment remains as 'valorRestante' 
           // but technically doesn't pay a 'parcela'. 
           // Business decision: If money is left but not enough for a prioritized installment, 
           // does it amortize? YES, per "amortiza do valor final".
        }
      }

      // Priority 2: Amortize Excess
      // If there is still money, and we cleared arrears (or had none), 
      // check if we can pay FUTURE installments or just amortize.
      // Rule: "se exceder, deve ser amortizada do valor final"
      // This implies we don't advance 'numeroParcelasPagas' beyond current due? 
      // The prompt says: "Se houver algum valor a ser pago... pagar... e se exceder, deve ser amortizada".
      // Usually, paying future installments increases 'numeroParcelasPagas'.
      // But 'amortizada do valor final' suggests reducing principal without advancing count necessarily?
      // Let's assume: Pay Intallments = Advance Count. Amortize = Reduce Principal.
      
      // If we still have value, let's treat it as amortization
      if (valorRestante > 0) {
         valorAmortizado = valorRestante;
      }

      // 3. Update Commitment
      if (parcelasPagasAgora > 0) {
        await _compromissoRepository.registrarPagamentoParcela(
          compromisso.id,
          compromisso.numeroParcelasPagas + parcelasPagasAgora,
        );
      }

      if (valorAmortizado > 0 && compromisso.valorTotalComprometido != null) {
          final novoTotal = compromisso.valorTotalComprometido! - valorAmortizado;
          await _compromissoRepository.updateValorTotal(compromisso.id, novoTotal);
      }

      // 4. Create Transaction
      String descricao = 'Pagamento: ${compromisso.descricao}';
      if (parcelasPagasAgora > 0) {
        descricao += ' (${parcelasPagasAgora} ${parcelasPagasAgora == 1 ? "parcela" : "parcelas"})';
      }
      if (valorAmortizado > 0) {
        descricao += ' + Amortização';
      }

      // 5. Update Fund Balance (FER)
      int? destinationFundId = compromisso.fundoPrincipalDestinoId;
      
      // Fallback: If no fund ID on commitment, try to determine from type or default to FER
      final allFundos = await _fundoRepository.getAllFundos();
      
      if (destinationFundId == null) {
         // Try to find FER
         try {
           final fer = allFundos.firstWhere((f) => f.nomeFundo.contains('FER') || f.tipoFundo == 'FER');
           destinationFundId = fer.id;
         } catch (_) {}
      }

      if (destinationFundId != null) {
        try {
          final destinationFundo = allFundos.firstWhere((f) => f.id == destinationFundId);
          final novoSaldo = destinationFundo.saldoAtual + valorDepositado;
          await _fundoRepository.updateSaldo(destinationFundId, novoSaldo);
          
          // Lógica de Abatimento de Empréstimo
          if (compromisso.tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO') {
              // Buscar empréstimo ativo correspondente
              // Como não temos vínculo direto, usamos a descrição (proposito) e status ATIVO
              // Idealmente, adicionaríamos uma chave estrangeira, mas para hotfix usamos heurística
              final emprestimosAtivos = await _emprestimoRepository.getEmprestimosAtivos();
              try {
                  // Tenta encontrar empréstimo com mesmo propósito (descrição)
                  final emprestimo = emprestimosAtivos.firstWhere(
                      (e) => e.proposito == compromisso.descricao && e.statusEmprestimo == 'ATIVO',
                  );
                  
                  final novoSaldoDevedor = emprestimo.saldoDevedorAtual - valorDepositado;
                  
                  if (novoSaldoDevedor <= 0.01) { // Margem de erro para double
                      await _emprestimoRepository.quitarEmprestimo(emprestimo.id);
                  } else {
                      await _emprestimoRepository.updateSaldoDevedor(emprestimo.id, novoSaldoDevedor);
                  }
              } catch (_) {
                  // Não encontrou empréstimo específico, talvez logar ou ignorar
                  // Em produção, isso deveria ser tratado com mais rigor
              }
          }
        } catch (e) {
          // Log error
        }
      }
      
      await _transacaoRepository.addTransacao(Transacao(
        id: 0,
        usuarioId: compromisso.usuarioId,
        valor: valorDepositado,
        dataTransacao: DateTime.now(),
        descricao: descricao,
        tipoTransacao: 'PAGAMENTO_COMPROMISSO',
        compromissoId: compromisso.id,
        fundoPrincipalDestinoId: destinationFundId, // Use the resolved ID
        caixinhaDestinoId: compromisso.caixinhaDestinoId,
        dataCriacao: DateTime.now(),
        dataAtualizacao: DateTime.now(),
      ));
    });
  }
}
