import '../entities/emprestimo.dart';

abstract class IEmprestimoRepository {
  Future<List<Emprestimo>> getEmprestimosAtivos();
  Future<int> createEmprestimo(Emprestimo emprestimo);
  Future<void> updateSaldoDevedor(int emprestimoId, double novoSaldo);
  Future<void> updateEmprestimo(Emprestimo emprestimo);
  Future<void> quitarEmprestimo(int emprestimoId);
  Future<void> deleteEmprestimo(int emprestimoId); // Soft delete
  Stream<List<Emprestimo>> watchEmprestimosAtivos();
  Future<double> getSaldoDevedorTotal();
  Stream<double> watchSaldoDevedorTotal();
}
