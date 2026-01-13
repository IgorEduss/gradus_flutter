class Compromisso {
  final int id;
  final int usuarioId;
  final String descricao;
  final String tipoCompromisso;
  final double? valorTotalComprometido;
  final double valorParcela;
  final int? numeroTotalParcelas;
  final int numeroParcelasPagas;
  final int? fundoPrincipalDestinoId;
  final int? caixinhaDestinoId;
  final DateTime dataInicioCompromisso;
  final DateTime? dataProximoVencimento;
  final String statusCompromisso; // "ATIVO", "CONCLUIDO", "CANCELADO"
  final bool ajusteInflacaoAplicavel;
  final DateTime? dataUltimoAjusteInflacao;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  Compromisso({
    required this.id,
    required this.usuarioId,
    required this.descricao,
    required this.tipoCompromisso,
    this.valorTotalComprometido,
    required this.valorParcela,
    this.numeroTotalParcelas,
    required this.numeroParcelasPagas,
    this.fundoPrincipalDestinoId,
    this.caixinhaDestinoId,
    required this.dataInicioCompromisso,
    this.dataProximoVencimento,
    required this.statusCompromisso,
    required this.ajusteInflacaoAplicavel,
    this.dataUltimoAjusteInflacao,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  Compromisso copyWith({
    int? id,
    int? usuarioId,
    String? descricao,
    String? tipoCompromisso,
    double? valorTotalComprometido,
    double? valorParcela,
    int? numeroTotalParcelas,
    int? numeroParcelasPagas,
    int? fundoPrincipalDestinoId,
    int? caixinhaDestinoId,
    DateTime? dataInicioCompromisso,
    DateTime? dataProximoVencimento,
    String? statusCompromisso,
    bool? ajusteInflacaoAplicavel,
    DateTime? dataUltimoAjusteInflacao,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    return Compromisso(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      descricao: descricao ?? this.descricao,
      tipoCompromisso: tipoCompromisso ?? this.tipoCompromisso,
      valorTotalComprometido: valorTotalComprometido ?? this.valorTotalComprometido,
      valorParcela: valorParcela ?? this.valorParcela,
      numeroTotalParcelas: numeroTotalParcelas ?? this.numeroTotalParcelas,
      numeroParcelasPagas: numeroParcelasPagas ?? this.numeroParcelasPagas,
      fundoPrincipalDestinoId: fundoPrincipalDestinoId ?? this.fundoPrincipalDestinoId,
      caixinhaDestinoId: caixinhaDestinoId ?? this.caixinhaDestinoId,
      dataInicioCompromisso: dataInicioCompromisso ?? this.dataInicioCompromisso,
      dataProximoVencimento: dataProximoVencimento ?? this.dataProximoVencimento,
      statusCompromisso: statusCompromisso ?? this.statusCompromisso,
      ajusteInflacaoAplicavel: ajusteInflacaoAplicavel ?? this.ajusteInflacaoAplicavel,
      dataUltimoAjusteInflacao: dataUltimoAjusteInflacao ?? this.dataUltimoAjusteInflacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
