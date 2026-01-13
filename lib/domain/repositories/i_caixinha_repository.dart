import '../entities/caixinha.dart';

abstract class ICaixinhaRepository {
  Future<List<Caixinha>> getCaixinhasAtivas();
  Future<int> createCaixinha(Caixinha caixinha);
  Future<void> updateCaixinha(Caixinha caixinha);
  Future<void> deleteCaixinha(int id); // Soft delete
  Stream<List<Caixinha>> watchCaixinhas();
  Future<double> getSaldoTotal();
  Stream<double> watchSaldoTotal();
}
