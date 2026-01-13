import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/caixinha.dart';
import '../../domain/repositories/i_caixinha_repository.dart';
import '../local/db/app_database.dart' hide Caixinha;
import '../models/mappers.dart';

@LazySingleton(as: ICaixinhaRepository)
class CaixinhaRepositoryImpl implements ICaixinhaRepository {
  final AppDatabase _db;

  CaixinhaRepositoryImpl(this._db);

  @override
  Future<int> createCaixinha(Caixinha caixinha) async {
    return _db.into(_db.caixinhas).insert(
          CaixinhasCompanion(
            usuarioId: Value(caixinha.usuarioId),
            nomeCaixinha: Value(caixinha.nomeCaixinha),
            saldoAtual: Value(caixinha.saldoAtual),
            metaValor: Value(caixinha.metaValor),
            depositoObrigatorio: Value(caixinha.depositoObrigatorio),
            statusCaixinha: Value(caixinha.statusCaixinha),
            dataCriacao: Value(caixinha.dataCriacao),
            dataAtualizacao: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<void> deleteCaixinha(int id) async {
    // Check for linked transactions (Origem OR Destino)
    final countObs = await (_db.select(_db.transacoes)
      ..where((t) => t.caixinhaOrigemId.equals(id) | t.caixinhaDestinoId.equals(id)))
      .get();
      
    final hasTransactions = countObs.isNotEmpty;

    if (hasTransactions) {
      // Archive
      await (_db.update(_db.caixinhas)..where((t) => t.id.equals(id))).write(
        const CaixinhasCompanion(
          statusCaixinha: Value('ARQUIVADA'),
          dataAtualizacao: Value.absent(), // Trigger auto-update? Or manual
        ),
      );
      // Note: Value.absent() might not trigger default if not handled. 
      // Better to pass DateTime.now() if we want update time.
      // But standard way:
      await (_db.update(_db.caixinhas)..where((t) => t.id.equals(id))).write(
        CaixinhasCompanion(
          statusCaixinha: const Value('ARQUIVADA'),
          dataAtualizacao: Value(DateTime.now()),
        ),
      );
    } else {
      // Hard Delete
      await (_db.delete(_db.caixinhas)..where((t) => t.id.equals(id))).go();
    }
  }

  @override
  Future<List<Caixinha>> getCaixinhasAtivas() async {
    final query = _db.select(_db.caixinhas)
      ..where((t) => t.statusCaixinha.equals('ATIVA'));
    final result = await query.get();
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> updateCaixinha(Caixinha caixinha) async {
    await (_db.update(_db.caixinhas)..where((t) => t.id.equals(caixinha.id)))
        .write(
      CaixinhasCompanion(
        nomeCaixinha: Value(caixinha.nomeCaixinha),
        saldoAtual: Value(caixinha.saldoAtual),
        metaValor: Value(caixinha.metaValor),
        depositoObrigatorio: Value(caixinha.depositoObrigatorio),
        statusCaixinha: Value(caixinha.statusCaixinha),
        dataAtualizacao: Value(DateTime.now()),
      ),
    );
  }

  @override
  Stream<List<Caixinha>> watchCaixinhas() {
    return (_db.select(_db.caixinhas)
          ..where((t) => t.statusCaixinha.isNotValue('ARQUIVADA')) // Do we want archived? Assuming active list.
          ..orderBy([(t) => OrderingTerm(expression: t.nomeCaixinha)]))
        .watch()
        .map((rows) => rows.map((e) => e.toDomain()).toList());
  }

  @override
  Future<double> getSaldoTotal() async {
    final query = _db.selectOnly(_db.caixinhas)
      ..where(_db.caixinhas.statusCaixinha.equals('ATIVA'))
      ..addColumns([_db.caixinhas.saldoAtual.sum()]);

    final result = await query.getSingle();
    return result.read(_db.caixinhas.saldoAtual.sum()) ?? 0.0;
  }

  @override
  Stream<double> watchSaldoTotal() {
    final query = _db.selectOnly(_db.caixinhas)
      ..where(_db.caixinhas.statusCaixinha.equals('ATIVA'))
      ..addColumns([_db.caixinhas.saldoAtual.sum()]);

    return query
        .watchSingle()
        .map((row) => row.read(_db.caixinhas.saldoAtual.sum()) ?? 0.0);
  }
}
