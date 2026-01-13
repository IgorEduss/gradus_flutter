class Transacao {
  final int id;
  final int usuarioId;
  final double valor;
  final DateTime dataTransacao;
  final String descricao;
  final String tipoTransacao;
  final int? fundoPrincipalOrigemId;
  final int? caixinhaOrigemId;
  final int? fundoPrincipalDestinoId;
  final int? caixinhaDestinoId;
  final int? emprestimoId;
  final int? compromissoId;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  Transacao({
    required this.id,
    required this.usuarioId,
    required this.valor,
    required this.dataTransacao,
    required this.descricao,
    required this.tipoTransacao,
    this.fundoPrincipalOrigemId,
    this.caixinhaOrigemId,
    this.fundoPrincipalDestinoId,
    this.caixinhaDestinoId,
    this.emprestimoId,
    this.compromissoId,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });
}
