import 'package:injectable/injectable.dart';
import '../entities/transacao.dart';
import '../repositories/i_transacao_repository.dart';
import '../repositories/i_fundo_repository.dart';
import '../repositories/i_caixinha_repository.dart';

@injectable
class RealizarDepositoMspUseCase {
  final ITransacaoRepository _transacaoRepository;
  final IFundoRepository _fundoRepository;
  final ICaixinhaRepository _caixinhaRepository;

  RealizarDepositoMspUseCase(
    this._transacaoRepository,
    this._fundoRepository,
    this._caixinhaRepository,
  );

  Future<void> call({
    required int usuarioId,
    required double valor,
    required String descricao,
    int? caixinhaId,
  }) async {
    await _transacaoRepository.runTransaction(() async {
      // 1. Obter e Atualizar MSP (Apenas se NÃO for para caixinha)
      final msp = await _fundoRepository.getFundo('MSP');
      if (msp == null) throw Exception('Fundo MSP não encontrado.');

      if (caixinhaId == null) {
        final novoSaldoMsp = msp.saldoAtual + valor;
        await _fundoRepository.updateSaldo(msp.id, novoSaldoMsp);
      }

      // 2. Atualizar Caixinha (se selecionada)
      if (caixinhaId != null) {
        final caixinhas = await _caixinhaRepository.getCaixinhasAtivas();
        
        final caixinha = caixinhas.firstWhere(
            (c) => c.id == caixinhaId,
            orElse: () => throw Exception('Caixinha não encontrada.')
        );

        final novoSaldoCaixinha = caixinha.saldoAtual + valor;
        await _caixinhaRepository.updateCaixinha(caixinha.copyWith(saldoAtual: novoSaldoCaixinha));
      }

      // 3. Registrar Transação
      await _transacaoRepository.addTransacao(Transacao(
        id: 0,
        usuarioId: usuarioId,
        valor: valor,
        dataTransacao: DateTime.now(),
        descricao: descricao.isEmpty 
            ? (caixinhaId != null ? 'Depósito em Caixinha' : 'Depósito Pessoal') 
            : descricao,
        tipoTransacao: 'ENTRADA',
        fundoPrincipalDestinoId: msp.id,
        caixinhaDestinoId: caixinhaId,
        dataCriacao: DateTime.now(),
        dataAtualizacao: DateTime.now(),
      ));
    });
  }
}
