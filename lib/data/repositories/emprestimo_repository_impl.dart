import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/emprestimo.dart';
import '../../domain/repositories/i_emprestimo_repository.dart';
import '../local/db/app_database.dart' hide Emprestimo;
import '../models/mappers.dart';

@LazySingleton(as: IEmprestimoRepository)
class EmprestimoRepositoryImpl implements IEmprestimoRepository {
  final AppDatabase _db;

  EmprestimoRepositoryImpl(this._db);

  @override
  Future<int> createEmprestimo(Emprestimo emprestimo) async {
    return _db.into(_db.emprestimos).insert(
          EmprestimosCompanion(
            usuarioId: Value(emprestimo.usuarioId),
            fundoOrigemId: Value(emprestimo.fundoOrigemId),
            valorConcedido: Value(emprestimo.valorConcedido),
            saldoDevedorAtual: Value(emprestimo.saldoDevedorAtual),
            proposito: Value(emprestimo.proposito),
            statusEmprestimo: Value(emprestimo.statusEmprestimo),
            dataConcessao: Value(emprestimo.dataConcessao),
            dataCriacao: Value(emprestimo.dataCriacao),
            dataAtualizacao: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<List<Emprestimo>> getEmprestimosAtivos() async {
    final query = _db.select(_db.emprestimos)
      ..where((t) => t.statusEmprestimo.equals('ATIVO'));
    final result = await query.get();
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> quitarEmprestimo(int emprestimoId) async {
    await (_db.update(_db.emprestimos)..where((t) => t.id.equals(emprestimoId)))
        .write(
      EmprestimosCompanion(
        statusEmprestimo: const Value('QUITADO'),
        dataQuitacao: Value(DateTime.now()),
        saldoDevedorAtual: const Value(0.0),
        dataAtualizacao: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteEmprestimo(int emprestimoId) async {
    // Check for linked transactions
    final countObs = await (_db.select(_db.transacoes)
      ..where((t) => t.emprestimoId.equals(emprestimoId)))
      .get();
      
    final hasTransactions = countObs.isNotEmpty;
    
    if (hasTransactions) {
       // Archive (Quitado/Cancelado)
       await (_db.update(_db.emprestimos)..where((t) => t.id.equals(emprestimoId))).write(
        EmprestimosCompanion(
          statusEmprestimo: const Value('QUITADO'), // Assuming "Quitado" effectively hides it from "Active"
          dataQuitacao: Value(DateTime.now()),
          // Reset balance? Or keep history?
          // If we are deleting, likely an error. If we keep it as history, keep balance maybe? 
          // But strict "Quitado" usually implies 0 balance. 
          // Let's set balance to 0.0 to effectively close it.
          saldoDevedorAtual: const Value(0.0),
          dataAtualizacao: Value(DateTime.now()),
        ),
      );
    } else {
       // Hard Delete
       await (_db.delete(_db.emprestimos)..where((t) => t.id.equals(emprestimoId))).go();
    }
  }

  @override
  Future<void> updateSaldoDevedor(int emprestimoId, double novoSaldo) async {
    await (_db.update(_db.emprestimos)..where((t) => t.id.equals(emprestimoId)))
        .write(
      EmprestimosCompanion(
        saldoDevedorAtual: Value(novoSaldo),
        dataAtualizacao: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> updateEmprestimo(Emprestimo emprestimo) async {
    await (_db.update(_db.emprestimos)..where((t) => t.id.equals(emprestimo.id)))
        .write(
      EmprestimosCompanion(
        saldoDevedorAtual: Value(emprestimo.saldoDevedorAtual),
        dataUltimoAjusteInflacao: Value(emprestimo.dataUltimoAjusteInflacao),
        dataAtualizacao: Value(DateTime.now()),
      ),
    );
  }

  @override
  Stream<List<Emprestimo>> watchEmprestimosAtivos() {
    return (_db.select(_db.emprestimos)
          ..where((t) => t.statusEmprestimo.equals('ATIVO')))
        .watch()
        .map((rows) => rows.map((e) => e.toDomain()).toList());
  }

  @override
  Future<double> getSaldoDevedorTotal() async {
    final query = _db.selectOnly(_db.emprestimos)
      ..where(_db.emprestimos.statusEmprestimo.equals('ATIVO'))
      ..addColumns([_db.emprestimos.saldoDevedorAtual.sum()]);

    final result = await query.getSingle();
    return result.read(_db.emprestimos.saldoDevedorAtual.sum()) ?? 0.0;
  }

  @override
  Stream<double> watchSaldoDevedorTotal() {
    final query = _db.selectOnly(_db.emprestimos)
      ..where(_db.emprestimos.statusEmprestimo.equals('ATIVO'))
      ..addColumns([_db.emprestimos.saldoDevedorAtual.sum()]);

    return query
        .watchSingle()
        .map((row) => row.read(_db.emprestimos.saldoDevedorAtual.sum()) ?? 0.0);
  }
}
