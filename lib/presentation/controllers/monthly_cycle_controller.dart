import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/compromisso.dart';
import '../../domain/repositories/i_compromisso_repository.dart';
import '../../domain/usecases/processar_ciclo_mensal_usecase.dart';
import '../../domain/usecases/calcular_inflacao_usecase.dart';
import '../providers/user_provider.dart';
import '../providers/selected_month_provider.dart';
import '../../domain/usecases/realizar_deposito_usecase.dart';

part 'monthly_cycle_controller.g.dart';


@riverpod
class MonthlyCycleController extends _$MonthlyCycleController {
  @override
  FutureOr<void> build() {
    // Initial state is idle. We trigger inflation calculation as a side effect.
    _initInflacao();
    return null;
  }

  Future<void> _initInflacao() async {
    try {
      final calcularInflacaoUseCase = GetIt.I<CalcularInflacaoUseCase>();
      final user = await ref.read(usuarioProvider.future);
      if (user != null) {
        await calcularInflacaoUseCase(user.id);
      }
    } catch (e) {
      // Silently fail or log
    }
  }

  Future<void> realizarDeposito(Compromisso compromisso, {required double valorDepositado}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final realizarDepositoUseCase = GetIt.I<RealizarDepositoUseCase>();
      await realizarDepositoUseCase(compromisso: compromisso, valorDepositado: valorDepositado);
    });
  }

  Future<void> processarCiclo({
    required double valorPago,
    required List<Compromisso> compromissos,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final processarCicloUseCase = GetIt.I<ProcessarCicloMensalUseCase>();
      final user = await ref.read(usuarioProvider.future);

      if (user == null) throw Exception('Usuário não encontrado');

      await processarCicloUseCase(
        usuarioId: user.id,
        valorPago: valorPago,
        compromissos: compromissos,
        unidadePagamento: user.unidadePagamento,
      );
    });
  }

  Future<void> forceInflationAdjustment(double manualRate) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final calcularInflacaoUseCase = GetIt.I<CalcularInflacaoUseCase>();
      final user = await ref.read(usuarioProvider.future);
      if (user != null) {
        await calcularInflacaoUseCase(user.id, manualRate: manualRate);
      }
    });
  }
}



@riverpod
@riverpod
Stream<List<Compromisso>> compromissosDoMes(CompromissosDoMesRef ref) {
  final repository = GetIt.I<ICompromissoRepository>();
  final selectedDate = ref.watch(selectedMonthProvider);
  
  return repository.watchCompromissosDoMes(selectedDate);
}
