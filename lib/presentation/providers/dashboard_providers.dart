import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/compromisso.dart';
import '../../domain/repositories/i_caixinha_repository.dart';
import '../../domain/repositories/i_compromisso_repository.dart';
import '../../domain/repositories/i_emprestimo_repository.dart';
import '../../domain/repositories/i_fundo_repository.dart';

part 'dashboard_providers.g.dart';

class FerSummary {
  final double saldoDisponivel;
  final double totalEmprestado;
  final double patrimonioTotal;
  final double saudeFundo; // Percentage 0-1

  FerSummary({
    required this.saldoDisponivel,
    required this.totalEmprestado,
  })  : patrimonioTotal = saldoDisponivel + totalEmprestado,
        saudeFundo = (saldoDisponivel + totalEmprestado) <= 0
            ? 0.0
            : saldoDisponivel / (saldoDisponivel + totalEmprestado);
}

class MspSummary {
  final double saldoGeral;
  final double totalCaixinhas;
  final double totalMsp;

  MspSummary({
    required this.saldoGeral,
    required this.totalCaixinhas,
  }) : totalMsp = saldoGeral + totalCaixinhas;
}

@riverpod
Stream<FerSummary> ferSummary(FerSummaryRef ref) async* {
  final fundoRepo = getIt<IFundoRepository>();
  final emprestimoRepo = getIt<IEmprestimoRepository>();

  final ferStream = fundoRepo.watchFundo('FER');
  final emprestimoStream = emprestimoRepo.watchSaldoDevedorTotal();

  await for (final fer in ferStream) {
    // We need to combine with the latest value from emprestimoStream.
    // Ideally use RxDart combineLatest, but here we can just listen to both?
    // Riverpod stream provider re-evaluates when dependencies change if we use ref.watch.
    // But here we are using repositories directly.
    // Better approach: Use ref.watch if we had providers for each stream.
    // Let's create separate streams or just yield when either changes?
    // Actually, simpler to use StreamGroup or just ref.watch other providers?
    // Let's use the repository streams directly and combine them.
    // Or better: Use functional approach with async* and await for.
    // But combining two streams manually in async* is hard without rxdart.
    
    // Alternative: Use ref.watch on other providers.
    // Let's assume we have providers for the raw data.
    // But I don't want to create too many public providers.
    
    // Let's use rxdart-like behavior by listening to both.
    // Actually, since this is a StreamProvider, I can just return a stream that combines them.
    // But I don't have rxdart in dependencies? I should check pubspec.
    // If not, I can use StreamZip or similar from async package?
    // Or just use ref.watch inside the build body if it was a Notifier?
    // But it's a functional provider.
    
    // Let's try to use `ref.watch` on the streams if I wrap them in providers?
    // No, I can just do:
    // return Rx.combineLatest2(...) if I had Rx.
    
    // Let's check dependencies.
    // I'll assume I don't have RxDart.
    
    // Simplest way with Riverpod:
    // Create separate providers for the raw streams and watch them here.
  }
}

// Let's redefine using ref.watch pattern which is cleaner in Riverpod
@riverpod
Stream<double> ferSaldoStream(FerSaldoStreamRef ref) {
  return getIt<IFundoRepository>().watchFundo('FER').map((f) => f?.saldoAtual ?? 0.0);
}

@riverpod
Stream<double> totalEmprestadoStream(TotalEmprestadoStreamRef ref) {
  return getIt<IEmprestimoRepository>().watchSaldoDevedorTotal();
}

@riverpod
Stream<FerSummary> ferSummaryData(FerSummaryDataRef ref) {
  final saldoAsync = ref.watch(ferSaldoStreamProvider);
  final emprestadoAsync = ref.watch(totalEmprestadoStreamProvider);

  return Stream.value(FerSummary(
    saldoDisponivel: saldoAsync.value ?? 0.0,
    totalEmprestado: emprestadoAsync.value ?? 0.0,
  ));
  // Wait, ref.watch on a StreamProvider returns AsyncValue.
  // If I return Stream.value, I am returning a Stream that emits once?
  // No, if I use functional provider returning Stream, Riverpod handles the stream subscription.
  // But if I watch other StreamProviders, I get AsyncValue updates.
  // So this provider should probably return the Object directly (FutureOr or just Object) and be an AutoDisposeProvider?
  // No, if I want it to be a Stream, I should return a Stream.
  
  // Better:
  // @riverpod
  // FerSummary ferSummary(FerSummaryRef ref) { ... } 
  // and let Riverpod handle the reactive updates from ref.watch.
}

@riverpod
FerSummary ferSummaryState(FerSummaryStateRef ref) {
  final saldo = ref.watch(ferSaldoStreamProvider).value ?? 0.0;
  final emprestado = ref.watch(totalEmprestadoStreamProvider).value ?? 0.0;
  
  return FerSummary(
    saldoDisponivel: saldo,
    totalEmprestado: emprestado,
  );
}

// Actually, let's keep it simple and use standard StreamProviders for the sources
// and a Provider (or FutureProvider/StreamProvider) for the combined result.

@riverpod
Stream<double> mspSaldoStream(MspSaldoStreamRef ref) {
  return getIt<IFundoRepository>().watchFundo('MSP').map((f) => f?.saldoAtual ?? 0.0);
}

@riverpod
Stream<double> totalCaixinhasStream(TotalCaixinhasStreamRef ref) {
  return getIt<ICaixinhaRepository>().watchSaldoTotal();
}

@riverpod
MspSummary mspSummaryState(MspSummaryStateRef ref) {
  final saldo = ref.watch(mspSaldoStreamProvider).value ?? 0.0;
  final caixinhas = ref.watch(totalCaixinhasStreamProvider).value ?? 0.0;

  return MspSummary(
    saldoGeral: saldo,
    totalCaixinhas: caixinhas,
  );
}

@riverpod
Stream<List<Compromisso>> monthlyCommitments(MonthlyCommitmentsRef ref) {
  final now = DateTime.now();
  return getIt<ICompromissoRepository>().watchCompromissosDoMes(now);
}
