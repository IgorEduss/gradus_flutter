import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/transacao.dart';
import '../../domain/entities/compromisso.dart' as domain;
import '../../domain/repositories/i_transacao_repository.dart';
import '../local/db/app_database.dart';
import '../models/mappers.dart';

@LazySingleton(as: ITransacaoRepository)
class TransacaoRepositoryImpl implements ITransacaoRepository {
  final AppDatabase _db;

  TransacaoRepositoryImpl(this._db);

  @override
  Future<void> addTransacao(Transacao transacao) async {
    await _db.into(_db.transacoes).insert(
          TransacoesCompanion(
            usuarioId: Value(transacao.usuarioId),
            valor: Value(transacao.valor),
            dataTransacao: Value(transacao.dataTransacao),
            descricao: Value(transacao.descricao),
            tipoTransacao: Value(transacao.tipoTransacao),
            fundoPrincipalOrigemId: Value(transacao.fundoPrincipalOrigemId),
            caixinhaOrigemId: Value(transacao.caixinhaOrigemId),
            fundoPrincipalDestinoId: Value(transacao.fundoPrincipalDestinoId),
            caixinhaDestinoId: Value(transacao.caixinhaDestinoId),
            emprestimoId: Value(transacao.emprestimoId),
            compromissoId: Value(transacao.compromissoId),
            dataCriacao: Value(transacao.dataCriacao),
            dataAtualizacao: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<List<Transacao>> getExtrato(
      {DateTime? inicio, DateTime? fim, int? fundoId, String? tipoTransacao}) async {
    var query = _db.select(_db.transacoes);

    if (inicio != null) {
      query = query..where((t) => t.dataTransacao.isBiggerOrEqualValue(inicio));
    }
    if (fim != null) {
      query = query..where((t) => t.dataTransacao.isSmallerOrEqualValue(fim));
    }
    
    if (tipoTransacao != null) {
      query = query..where((t) => t.tipoTransacao.equals(tipoTransacao));
    }

    if (fundoId != null) {
      // Filter where EITHER origin OR destination is the fund ID
      query = query..where((t) {
        return t.fundoPrincipalOrigemId.equals(fundoId) | 
               t.fundoPrincipalDestinoId.equals(fundoId);
      });
    }

    query = query..orderBy([(t) => OrderingTerm.desc(t.dataTransacao)]);

    final result = await query.get();
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Stream<List<Transacao>> watchUltimasTransacoes({int limit = 10}) {
    return (_db.select(_db.transacoes)
          ..orderBy([(t) => OrderingTerm.desc(t.dataTransacao)])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map((e) => e.toDomain()).toList());
  }

  @override
  Future<void> runTransaction(Future<void> Function() action) async {
    return _db.transaction(action);
  }

  @override
  Future<void> deleteUltimaTransacao(int id) async {
    return _db.transaction(() async {
      // 1. Get the target transaction
      final target = await (_db.select(_db.transacoes)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (target == null) throw Exception('Transação não encontrada.');

      // 2. Check if there are any newer transactions (globally for this user)
      // We look for any transaction with dataTransacao or dataCriacao > target
      // Using dataCriacao is safer for "undo order".
      final newerTransactions = await (_db.select(_db.transacoes)
        ..where((t) => t.usuarioId.equals(target.usuarioId) & 
                       t.dataCriacao.isBiggerThanValue(target.dataCriacao)))
        .get();

      if (newerTransactions.isNotEmpty) {
        throw Exception('Apenas o último lançamento pode ser excluído. Para correções antigas, faça um estorno.');
      }

      // 3. Hard Delete
      await (_db.delete(_db.transacoes)..where((t) => t.id.equals(id))).go();
    });
  }
}
