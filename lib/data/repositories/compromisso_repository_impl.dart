import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/compromisso.dart';
import '../../domain/repositories/i_compromisso_repository.dart';
import '../local/db/app_database.dart' hide Compromisso;
import '../models/mappers.dart';

@LazySingleton(as: ICompromissoRepository)
class CompromissoRepositoryImpl implements ICompromissoRepository {
  final AppDatabase _db;

  CompromissoRepositoryImpl(this._db);

  @override
  Future<void> createCompromisso(Compromisso compromisso) async {
    await _db.transaction(() async {
      await _db.into(_db.compromissos).insert(
            CompromissosCompanion(
              usuarioId: Value(compromisso.usuarioId),
              descricao: Value(compromisso.descricao),
              tipoCompromisso: Value(compromisso.tipoCompromisso),
              valorTotalComprometido: Value(compromisso.valorTotalComprometido),
              valorParcela: Value(compromisso.valorParcela),
              numeroTotalParcelas: Value(compromisso.numeroTotalParcelas),
              numeroParcelasPagas: Value(compromisso.numeroParcelasPagas),
              fundoPrincipalDestinoId: Value(compromisso.fundoPrincipalDestinoId),
              caixinhaDestinoId: Value(compromisso.caixinhaDestinoId),
              dataInicioCompromisso: Value(compromisso.dataInicioCompromisso),
              dataProximoVencimento: Value(compromisso.dataProximoVencimento),
              statusCompromisso: Value(compromisso.statusCompromisso),
              ajusteInflacaoAplicavel: Value(compromisso.ajusteInflacaoAplicavel),
              dataCriacao: Value(compromisso.dataCriacao),
              dataAtualizacao: Value(DateTime.now()),
            ),
          );
    });
  }

  @override
  Future<List<Compromisso>> getCompromissosDoMes(DateTime mesReferencia) async {
    // Logic to filter by month would typically involve checking dataProximoVencimento
    // For simplicity, we fetch active ones and filter in memory or refine query later
    final query = _db.select(_db.compromissos)
      ..where((t) => t.statusCompromisso.equals('ATIVO'));
    
    final result = await query.get();
    // In a real app, use SQL date functions or specific range queries
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> registrarPagamentoParcela(
      int compromissoId, int numeroParcelasPagas) async {
    await (_db.update(_db.compromissos)..where((t) => t.id.equals(compromissoId)))
        .write(
      CompromissosCompanion(
        numeroParcelasPagas: Value(numeroParcelasPagas),
        dataAtualizacao: Value(DateTime.now()),
      ),
    );
  }

  @override
  Stream<List<Compromisso>> watchCompromissosAtivos() {
    return (_db.select(_db.compromissos)
          ..where((t) => t.statusCompromisso.equals('ATIVO')))
        .watch()
        .map((rows) => rows.map((e) => e.toDomain()).toList());
  }

  @override
  Stream<List<Compromisso>> watchCompromissosDoMes(DateTime mesReferencia) {
    // Regra: O compromisso só aparece no mês SEGUINTE ao da data de início/cadastro.
    // Ex: Cadastro em Dez (inicio <= 31/12).
    // View Jan: endOfPreviousMonth = 31/12.
    // Condição: inicio <= 31/12. (True -> Aparece em Jan).
    // View Dez: endOfPreviousMonth = 30/11.
    // Condição: inicio <= 30/11 (False -> Não aparece em Dez).
    
    final endOfPreviousMonth = DateTime(mesReferencia.year, mesReferencia.month, 1)
        .subtract(const Duration(seconds: 1));

    return (_db.select(_db.compromissos)
          ..where((t) =>
              t.statusCompromisso.equals('ATIVO') &
              t.dataInicioCompromisso.isSmallerOrEqualValue(endOfPreviousMonth)))
        .watch()
        .map((rows) => rows.map((e) => e.toDomain()).toList());
  }
  @override
  Future<void> updateValorTotal(int compromissoId, double novoValor) async {
    await (_db.update(_db.compromissos)..where((t) => t.id.equals(compromissoId)))
        .write(
      CompromissosCompanion(
        valorTotalComprometido: Value(novoValor),
        dataAtualizacao: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> updateCompromisso(Compromisso compromisso) async {
    await (_db.update(_db.compromissos)..where((t) => t.id.equals(compromisso.id)))
        .write(
      CompromissosCompanion(
        descricao: Value(compromisso.descricao),
        valorParcela: Value(compromisso.valorParcela),
        // Assume total might change if re-calculated or edited? 
        // Typically user edits description, installment value, date.
        // Total committed might also be editable? 
        // Based on modal, we edit description, installment, total, start date.
        valorTotalComprometido: Value(compromisso.valorTotalComprometido),
        numeroTotalParcelas: Value(compromisso.numeroTotalParcelas),
        dataInicioCompromisso: Value(compromisso.dataInicioCompromisso),
        dataAtualizacao: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteCompromisso(int id) async {
     // Check for payments (Transactions linked to this commitment)
     final countObs = await (_db.select(_db.transacoes)
      ..where((t) => t.compromissoId.equals(id)))
      .get();
      
     final hasPayments = countObs.isNotEmpty;
     
     if (hasPayments) {
        // Archive
        await (_db.update(_db.compromissos)..where((t) => t.id.equals(id))).write(
          CompromissosCompanion(
            statusCompromisso: const Value('ARQUIVADO'),
            dataAtualizacao: Value(DateTime.now()),
          ),
        );
     } else {
        // Hard Delete
        await (_db.delete(_db.compromissos)..where((t) => t.id.equals(id))).go();
     }
  }
}
