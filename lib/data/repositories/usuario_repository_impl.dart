import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/i_usuario_repository.dart';
import '../local/db/app_database.dart' hide Usuario;
import '../models/mappers.dart';

@LazySingleton(as: IUsuarioRepository)
class UsuarioRepositoryImpl implements IUsuarioRepository {
  final AppDatabase _db;

  UsuarioRepositoryImpl(this._db);

  @override
  Future<Usuario?> getUsuario() async {
    final query = _db.select(_db.usuarios)..limit(1);
    final result = await query.getSingleOrNull();
    return result?.toDomain();
  }

  @override
  Future<void> saveUsuario(Usuario usuario) async {
    await _db.into(_db.usuarios).insertOnConflictUpdate(
          UsuariosCompanion(
            id: Value(usuario.id),
            userCloudId: Value(usuario.userCloudId),
            nome: Value(usuario.nome),
            unidadePagamento: Value(usuario.unidadePagamento),
            diaRevisaoMensal: Value(usuario.diaRevisaoMensal),
            inflacaoAplicarFerEmprestimos:
                Value(usuario.inflacaoAplicarFerEmprestimos),
            inflacaoAplicarFerFacilitadores:
                Value(usuario.inflacaoAplicarFerFacilitadores),
            inflacaoAplicarMspDepositos:
                Value(usuario.inflacaoAplicarMspDepositos),
            dataCriacao: Value(usuario.dataCriacao),
            dataAtualizacao: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<void> updateConfiguracoes(Usuario usuario) async {
    await (_db.update(_db.usuarios)..where((t) => t.id.equals(usuario.id)))
        .write(
      UsuariosCompanion(
        unidadePagamento: Value(usuario.unidadePagamento),
        diaRevisaoMensal: Value(usuario.diaRevisaoMensal),
        inflacaoAplicarFerEmprestimos:
            Value(usuario.inflacaoAplicarFerEmprestimos),
        inflacaoAplicarFerFacilitadores:
            Value(usuario.inflacaoAplicarFerFacilitadores),
        inflacaoAplicarMspDepositos:
            Value(usuario.inflacaoAplicarMspDepositos),
        dataAtualizacao: Value(DateTime.now()),
      ),
    );
  }

  @override
  Stream<Usuario?> watchUsuario() {
    return (_db.select(_db.usuarios)..limit(1))
        .watchSingleOrNull()
        .map((event) => event?.toDomain());
  }
}
