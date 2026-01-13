import '../entities/fundo.dart';

abstract class IFundoRepository {
  Future<Fundo?> getFundo(String tipoFundo); // "FER" or "MSP"
  Future<List<Fundo>> getAllFundos();
  Future<void> createFundo(Fundo fundo);
  Future<void> updateSaldo(int fundoId, double novoSaldo);
  Stream<Fundo?> watchFundo(String tipoFundo);
}
