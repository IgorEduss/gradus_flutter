import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/usecases/conciliar_saldos_usecase.dart';
import '../../domain/repositories/i_fundo_repository.dart';
import '../../domain/repositories/i_caixinha_repository.dart';
import '../providers/repositories_providers.dart';
import '../providers/usecases_providers.dart';

part 'conciliation_controller.g.dart';

@riverpod
class ConciliationController extends _$ConciliationController {
  late final ConciliarSaldosUseCase _conciliarSaldosUseCase;
  late final IFundoRepository _fundoRepository;
  late final ICaixinhaRepository _caixinhaRepository;

  @override
  Future<ConciliationState> build() async {
    _conciliarSaldosUseCase = ref.watch(conciliarSaldosUseCaseProvider);
    _fundoRepository = ref.watch(fundoRepositoryProvider);
    _caixinhaRepository = ref.watch(caixinhaRepositoryProvider);

    return _loadInitialData();
  }

  Future<ConciliationState> _loadInitialData() async {
    final fer = await _fundoRepository.getFundo('FER');
    final msp = await _fundoRepository.getFundo('MSP');
    final caixinhas = await _caixinhaRepository.getCaixinhasAtivas();
    final saldoCaixinhas = caixinhas.fold(0.0, (sum, c) => sum + c.saldoAtual);

    final saldoVirtual = (fer?.saldoAtual ?? 0.0) + (msp?.saldoAtual ?? 0.0) + saldoCaixinhas;

    return ConciliationState(
      saldoVirtual: saldoVirtual,
      saldoRealInput: 0.0,
      saldoJustificado: 0.0,
      diferenca: -saldoVirtual, // Inicialmente assume saldo real 0
    );
  }

  void updateSaldoReal(double valor) {
    if (state.value == null) return;
    final currentState = state.value!;
    
    final novaDiferenca = valor - currentState.saldoVirtual;
    
    state = AsyncValue.data(currentState.copyWith(
      saldoRealInput: valor,
      diferenca: novaDiferenca,
    ));
  }

  void updateSaldoJustificado(double valor) {
    if (state.value == null) return;
    final currentState = state.value!;
    
    state = AsyncValue.data(currentState.copyWith(
      saldoJustificado: valor,
    ));
  }

  Future<void> confirmarConciliacao(int usuarioId) async {
    if (state.value == null) return;
    final currentState = state.value!;

    state = const AsyncValue.loading();

    try {
      await _conciliarSaldosUseCase(
        usuarioId: usuarioId, // TODO: Obter do AuthProvider
        saldoRealTotal: currentState.saldoRealInput,
        valorJustificadoMsp: currentState.saldoJustificado,
      );
      
      // Recarrega os dados para mostrar zerado ou navega de volta
      final newState = await _loadInitialData();
      state = AsyncValue.data(newState);
      
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class ConciliationState {
  final double saldoVirtual;
  final double saldoRealInput;
  final double saldoJustificado;
  final double diferenca;

  ConciliationState({
    required this.saldoVirtual,
    required this.saldoRealInput,
    required this.saldoJustificado,
    required this.diferenca,
  });

  ConciliationState copyWith({
    double? saldoVirtual,
    double? saldoRealInput,
    double? saldoJustificado,
    double? diferenca,
  }) {
    return ConciliationState(
      saldoVirtual: saldoVirtual ?? this.saldoVirtual,
      saldoRealInput: saldoRealInput ?? this.saldoRealInput,
      saldoJustificado: saldoJustificado ?? this.saldoJustificado,
      diferenca: diferenca ?? this.diferenca,
    );
  }
}
