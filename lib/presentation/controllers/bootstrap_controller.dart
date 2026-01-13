import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/entities/fundo.dart';
import '../../domain/repositories/i_usuario_repository.dart';
import '../../domain/repositories/i_fundo_repository.dart';

part 'bootstrap_controller.g.dart';

@riverpod
class BootstrapController extends _$BootstrapController {
  @override
  FutureOr<void> build() async {
    // Just check, do not create
    final usuarioRepo = getIt<IUsuarioRepository>();
    final usuario = await usuarioRepo.getUsuario();

    if (usuario == null) {
      // Logic to trigger redirection will be handled by the UI listening to this state
      // or we can throw an error/special state to indicate "Needs Onboarding"
      // But for now, let's just return null and let the UI decide.
      // Actually, the DashboardScreen calls this.
      // If we want to redirect, we should probably do it in the UI.
    }
  }
  
  Future<bool> checkUserExists() async {
    final usuarioRepo = getIt<IUsuarioRepository>();
    final usuario = await usuarioRepo.getUsuario();
    return usuario != null;
  }
}
