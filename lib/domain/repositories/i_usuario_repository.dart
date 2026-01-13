import '../entities/usuario.dart';

abstract class IUsuarioRepository {
  Future<Usuario?> getUsuario();
  Future<void> saveUsuario(Usuario usuario);
  Future<void> updateConfiguracoes(Usuario usuario);
  Stream<Usuario?> watchUsuario();
}
