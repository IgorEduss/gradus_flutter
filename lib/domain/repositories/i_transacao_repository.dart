import '../entities/transacao.dart';
import '../entities/compromisso.dart';

abstract class ITransacaoRepository {
  Future<void> addTransacao(Transacao transacao);
  Future<List<Transacao>> getExtrato({DateTime? inicio, DateTime? fim, int? fundoId, String? tipoTransacao});
  Stream<List<Transacao>> watchUltimasTransacoes({int limit = 10});
  Future<void> runTransaction(Future<void> Function() action);
  Future<void> deleteUltimaTransacao(int id);
}
