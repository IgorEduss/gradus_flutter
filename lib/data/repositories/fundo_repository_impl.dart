import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/fundo.dart';
import '../../domain/repositories/i_fundo_repository.dart';
import '../local/db/app_database.dart';
import '../models/mappers.dart';

@LazySingleton(as: IFundoRepository)
class FundoRepositoryImpl implements IFundoRepository {
  final AppDatabase _db;

  FundoRepositoryImpl(this._db);

  @override
  Future<List<Fundo>> getAllFundos() async {
    final result = await _db.select(_db.fundosPrincipais).get();
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> createFundo(Fundo fundo) async {
    await _db.into(_db.fundosPrincipais).insert(
          FundosPrincipaisCompanion(
            usuarioId: Value(fundo.usuarioId),
            tipoFundo: Value(fundo.tipoFundo),
            nomeFundo: Value(fundo.nomeFundo),
            saldoAtual: Value(fundo.saldoAtual),
            picoPatrimonioTotalAlcancado:
                Value(fundo.picoPatrimonioTotalAlcancado),
            dataCriacao: Value(fundo.dataCriacao),
            dataAtualizacao: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<Fundo?> getFundo(String tipoFundo) async {
    final query = _db.select(_db.fundosPrincipais)
      ..where((t) => t.tipoFundo.equals(tipoFundo));
    final result = await query.getSingleOrNull();
    return result?.toDomain();
  }

  @override
  Future<void> updateSaldo(int fundoId, double novoSaldo) async {
    await (_db.update(_db.fundosPrincipais)..where((t) => t.id.equals(fundoId)))
        .write(
      FundosPrincipaisCompanion(
        saldoAtual: Value(novoSaldo),
        dataAtualizacao: Value(DateTime.now()),
      ),
    );
  }

  @override
  Stream<Fundo?> watchFundo(String tipoFundo) {
    return (_db.select(_db.fundosPrincipais)
          ..where((t) => t.tipoFundo.equals(tipoFundo)))
        .watchSingleOrNull()
        .map((event) => event?.toDomain());
  }
}
