import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/i_usuario_repository.dart';

part 'user_provider.g.dart';

@riverpod
Stream<Usuario?> usuario(UsuarioRef ref) {
  final repository = getIt<IUsuarioRepository>();
  return repository.watchUsuario();
}
