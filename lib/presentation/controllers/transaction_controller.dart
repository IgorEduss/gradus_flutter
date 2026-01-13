import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/transacao.dart';
import '../../domain/entities/fundo.dart';
import '../../domain/repositories/i_transacao_repository.dart';
import '../../domain/repositories/i_fundo_repository.dart';

part 'transaction_controller.g.dart';

@riverpod
class TransactionController extends _$TransactionController {
  @override
  FutureOr<void> build() {
    // Initial state is void (idle)
  }

  Future<void> addTransaction({
    required double valor,
    required String descricao,
    required String tipoTransacao, // "ENTRADA" ou "SAIDA"
    required String tipoFundo, // "FER" ou "MSP"
    required int usuarioId,
    int? commitmentId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      print('TransactionController: addTransaction called');
      final transacaoRepository = GetIt.I<ITransacaoRepository>();
      final fundoRepository = GetIt.I<IFundoRepository>();

      // 1. Buscar o fundo correspondente para obter o ID e saldo atual
      print('TransactionController: Fetching fundo $tipoFundo');
      final fundo = await fundoRepository.getFundo(tipoFundo);
      if (fundo == null) {
        print('TransactionController: Fundo not found');
        throw Exception('Fundo $tipoFundo não encontrado.');
      }
      print('TransactionController: Fundo found: ${fundo.id}, Saldo: ${fundo.saldoAtual}');

      // 2. Criar a transação
      final novaTransacao = Transacao(
        id: 0, // ID será gerado pelo banco
        usuarioId: usuarioId,
        valor: valor,
        dataTransacao: DateTime.now(),
        descricao: descricao,
        tipoTransacao: tipoTransacao,
        fundoPrincipalOrigemId: tipoTransacao == 'SAIDA' ? fundo.id : null,
        fundoPrincipalDestinoId: tipoTransacao == 'ENTRADA' ? fundo.id : null,
        compromissoId: commitmentId,
        dataCriacao: DateTime.now(),
        dataAtualizacao: DateTime.now(),
      );

      print('TransactionController: Adding transaction to DB');
      await transacaoRepository.addTransacao(novaTransacao);

      // 3. Atualizar o saldo do fundo
      double novoSaldo = fundo.saldoAtual;
      if (tipoTransacao == 'ENTRADA') {
        novoSaldo += valor;
      } else {
        novoSaldo -= valor;
      }

      print('TransactionController: Updating saldo to $novoSaldo');
      await fundoRepository.updateSaldo(fundo.id, novoSaldo);
      print('TransactionController: Success');
    });
  }
}
