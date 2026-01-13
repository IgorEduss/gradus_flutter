import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/injection.dart';
import '../../domain/usecases/conciliar_saldos_usecase.dart';
import '../../domain/usecases/realizar_deposito_msp_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/realizar_uso_msp_usecase.dart';
import 'package:get_it/get_it.dart';

part 'usecases_providers.g.dart';

@riverpod
ConciliarSaldosUseCase conciliarSaldosUseCase(ConciliarSaldosUseCaseRef ref) {
  return getIt<ConciliarSaldosUseCase>();
}
final realizarUsoMspUseCaseProvider = Provider<RealizarUsoMspUseCase>((ref) {
  return GetIt.I<RealizarUsoMspUseCase>();
});

final realizarDepositoMspUseCaseProvider = Provider<RealizarDepositoMspUseCase>((ref) {
  return GetIt.I<RealizarDepositoMspUseCase>();
});
