import '../entities/compromisso.dart';

abstract class ICompromissoRepository {
  Future<List<Compromisso>> getCompromissosDoMes(DateTime mesReferencia);
  Future<void> createCompromisso(Compromisso compromisso);
  Future<void> registrarPagamentoParcela(int compromissoId, int numeroParcelasPagas);
  Stream<List<Compromisso>> watchCompromissosAtivos();
  Stream<List<Compromisso>> watchCompromissosDoMes(DateTime mesReferencia);
  Future<void> updateValorTotal(int compromissoId, double novoValor);
  Future<void> updateCompromisso(Compromisso compromisso);
  Future<void> deleteCompromisso(int id);
}
