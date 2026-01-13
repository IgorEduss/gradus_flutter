import 'package:injectable/injectable.dart';
import '../entities/transacao.dart';
import '../entities/emprestimo.dart';
import '../repositories/i_transacao_repository.dart';
import '../repositories/i_fundo_repository.dart';
import '../repositories/i_caixinha_repository.dart';
import '../repositories/i_emprestimo_repository.dart';

@injectable
class ConciliarSaldosUseCase {
  final ITransacaoRepository _transacaoRepository;
  final IFundoRepository _fundoRepository;
  final ICaixinhaRepository _caixinhaRepository;
  final IEmprestimoRepository _emprestimoRepository;

  ConciliarSaldosUseCase(
    this._transacaoRepository,
    this._fundoRepository,
    this._caixinhaRepository,
    this._emprestimoRepository,
  );

  Future<void> call({
    required int usuarioId,
    required double saldoRealTotal,
    required double valorJustificadoMsp, // 0 se não justificado
  }) async {
    await _transacaoRepository.runTransaction(() async {
      // 1. Obter saldos atuais virtuais
      final fer = await _fundoRepository.getFundo('FER');
      final msp = await _fundoRepository.getFundo('MSP');
      
      if (fer == null || msp == null) {
        throw Exception('Fundos principais não encontrados.');
      }

      final caixinhas = await _caixinhaRepository.getCaixinhasAtivas();
      double saldoCaixinhas = caixinhas.fold(0, (sum, c) => sum + c.saldoAtual);

      final saldoVirtualTotal = fer.saldoAtual + msp.saldoAtual + saldoCaixinhas;
      final diferenca = saldoRealTotal - saldoVirtualTotal;

      // Se a diferença for insignificante (ponto flutuante), ignora
      if (diferenca.abs() < 0.01) return;

      if (diferenca > 0) {
        // --- CENÁRIO A: Diferença Positiva (Rendimento) ---
        // Distribuição Proporcional
        // Evitar divisão por zero se saldoVirtualTotal for 0 (embora raro)
        final proporcaoFer = saldoVirtualTotal > 0 ? fer.saldoAtual / saldoVirtualTotal : 0.5;
        // O restante vai para o MSP para garantir que a soma seja 100% da diferença
        final ganhoFer = diferenca * proporcaoFer;
        final ganhoMsp = diferenca - ganhoFer;

        // Atualizar FER
        await _fundoRepository.updateSaldo(fer.id, fer.saldoAtual + ganhoFer);
        await _transacaoRepository.addTransacao(Transacao(
          id: 0,
          usuarioId: usuarioId,
          valor: ganhoFer,
          dataTransacao: DateTime.now(),
          descricao: 'Rendimento de Conciliação',
          tipoTransacao: 'REGISTRO_RENDIMENTO_FER',
          fundoPrincipalDestinoId: fer.id,
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        ));

        // Atualizar MSP
        await _fundoRepository.updateSaldo(msp.id, msp.saldoAtual + ganhoMsp);
        await _transacaoRepository.addTransacao(Transacao(
          id: 0,
          usuarioId: usuarioId,
          valor: ganhoMsp,
          dataTransacao: DateTime.now(),
          descricao: 'Rendimento de Conciliação',
          tipoTransacao: 'REGISTRO_RENDIMENTO_MSP',
          fundoPrincipalDestinoId: msp.id,
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        ));

      } else {
        // --- CENÁRIO B: Diferença Negativa (Déficit) ---
        final deficitTotal = diferenca.abs();
        
        // 1. Aplicar Justificativa (Uso MSP)
        // O valor justificado não pode ser maior que o déficit total
        double usoMsp = valorJustificadoMsp > deficitTotal ? deficitTotal : valorJustificadoMsp;
        // Também não pode ser maior que o saldo disponível no MSP (opcional, mas seguro)
        // Neste caso, se o usuário justificou, assumimos que ele gastou, então o saldo deve cair,
        // mesmo que fique negativo? O sistema permite MSP negativo?
        // Vamos limitar ao déficit total por enquanto.
        
        if (usoMsp > 0) {
          await _fundoRepository.updateSaldo(msp.id, msp.saldoAtual - usoMsp);
          await _transacaoRepository.addTransacao(Transacao(
            id: 0,
            usuarioId: usuarioId,
            valor: usoMsp,
            dataTransacao: DateTime.now(),
            descricao: 'Ajuste Manual (Justificado)',
            tipoTransacao: 'USO_MSP_CONCILIACAO',
            fundoPrincipalOrigemId: msp.id,
            dataCriacao: DateTime.now(),
            dataAtualizacao: DateTime.now(),
          ));
        }

        // 2. Cobrir o restante com Empréstimo Automático do FER
        double restanteNaoJustificado = deficitTotal - usoMsp;

        if (restanteNaoJustificado > 0.01) {
          // Criar Empréstimo
          final emprestimoId = await _emprestimoRepository.createEmprestimo(Emprestimo(
            id: 0,
            usuarioId: usuarioId,
            fundoOrigemId: fer.id,
            valorConcedido: restanteNaoJustificado,
            saldoDevedorAtual: restanteNaoJustificado,
            proposito: 'Conciliação Automática (Déficit)',
            statusEmprestimo: 'ATIVO',
            dataConcessao: DateTime.now(),
            dataCriacao: DateTime.now(),
            dataAtualizacao: DateTime.now(),
          ));

          // Transação de Concessão (Sai do FER)
          await _fundoRepository.updateSaldo(fer.id, fer.saldoAtual - restanteNaoJustificado);
          await _transacaoRepository.addTransacao(Transacao(
            id: 0,
            usuarioId: usuarioId,
            valor: restanteNaoJustificado,
            dataTransacao: DateTime.now(),
            descricao: 'Empréstimo (Déficit Não Justificado)',
            tipoTransacao: 'CONCESSAO_EMPRESTIMO_CONCILIACAO',
            fundoPrincipalOrigemId: fer.id,
            emprestimoId: emprestimoId,
            dataCriacao: DateTime.now(),
            dataAtualizacao: DateTime.now(),
          ));
        }
      }
    });
  }
}
