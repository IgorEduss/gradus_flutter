import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/fundo.dart';
import '../../domain/entities/caixinha.dart';
import '../../domain/entities/transacao.dart';
import '../../domain/repositories/i_fundo_repository.dart';
import '../../domain/repositories/i_caixinha_repository.dart';
import '../../domain/repositories/i_transacao_repository.dart';

part 'wallet_controller.g.dart';

class WalletData {
  final double totalNetWorth;
  final double ferBalance;
  final double mspTotalBalance; // Geral + Caixinhas
  final double mspAvailableBalance; // Só Geral
  final double caixinhasBalance;
  final List<Transacao> transactions;

  WalletData({
    required this.totalNetWorth,
    required this.ferBalance,
    required this.mspTotalBalance,
    required this.mspAvailableBalance,
    required this.caixinhasBalance,
    required this.transactions,
  });
}

@riverpod
class WalletController extends _$WalletController {
  @override
  Stream<WalletData> build() async* {
    final fundoRepo = getIt<IFundoRepository>();
    final caixinhaRepo = getIt<ICaixinhaRepository>();
    final transacaoRepo = getIt<ITransacaoRepository>();

    // Combine streams to update whenever any data changes
    // This is a simplified approach. In a perfect world we might use RxDart's CombineLatest,
    // but here we can just watch the repositories and yield.
    // However, since we are in a Stream build, we can't easily iterate multiple streams.
    // A better way for Riverpod is to watch other providers if they existed, or just periodically fetch/watch.
    
    // Better approach: Listen to the most frequent changer (Transactions) or just yield repeatedly?
    // Let's assume repositories provide Streams.
    
    // Creating a merged stream or just re-fetching on notify.
    // For now, let's watch the transaction stream as the "tick" and then fetch snapshots of balances.
    // Because balances only change when transactions happen.
    
    final transactionStream = transacaoRepo.watchUltimasTransacoes(limit: 50);

    await for (final transactions in transactionStream) {
      final fundos = await fundoRepo.getAllFundos();
      // Default to 0 if not found
      final fer = fundos.firstWhere((f) => f.tipoFundo == 'FER', orElse: () => Fundo(id: 0, usuarioId: 0, tipoFundo: 'FER', nomeFundo: 'FER', saldoAtual: 0, picoPatrimonioTotalAlcancado: 0, dataCriacao: DateTime.now(), dataAtualizacao: DateTime.now()));
      final msp = fundos.firstWhere((f) => f.tipoFundo == 'MSP', orElse: () => Fundo(id: 0, usuarioId: 0, tipoFundo: 'MSP', nomeFundo: 'MSP', saldoAtual: 0, picoPatrimonioTotalAlcancado: 0, dataCriacao: DateTime.now(), dataAtualizacao: DateTime.now()));

      final caixinhas = await caixinhaRepo.getCaixinhasAtivas();
      final totalCaixinhas = caixinhas.fold(0.0, (sum, c) => sum + c.saldoAtual);

      final totalNetWorth = fer.saldoAtual + msp.saldoAtual + totalCaixinhas;
      final mspTotal = msp.saldoAtual + totalCaixinhas;

      yield WalletData(
        totalNetWorth: totalNetWorth,
        ferBalance: fer.saldoAtual,
        mspTotalBalance: mspTotal,
        mspAvailableBalance: msp.saldoAtual,
        caixinhasBalance: totalCaixinhas,
        transactions: transactions,
      );
    }
  }
}
