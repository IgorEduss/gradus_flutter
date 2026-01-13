import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/fundo.dart';
import '../../domain/repositories/i_fundo_repository.dart';

part 'fundos_provider.g.dart';

@riverpod
Stream<Fundo?> ferBalance(FerBalanceRef ref) {
  final repository = getIt<IFundoRepository>();
  return repository.watchFundo('FER');
}

@riverpod
Stream<Fundo?> mspBalance(MspBalanceRef ref) {
  final repository = getIt<IFundoRepository>();
  return repository.watchFundo('MSP');
}
