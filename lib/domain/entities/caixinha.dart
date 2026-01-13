class Caixinha {
  final int id;
  final int usuarioId;
  final String nomeCaixinha;
  final double saldoAtual;
  final double? metaValor;
  final bool depositoObrigatorio;
  final String statusCaixinha; // "ATIVA", "CONCLUÍDA", "PAUSADA"
  final DateTime? dataConclusao;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  Caixinha({
    required this.id,
    required this.usuarioId,
    required this.nomeCaixinha,
    required this.saldoAtual,
    this.metaValor,
    required this.depositoObrigatorio,
    required this.statusCaixinha,
    this.dataConclusao,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });
  Caixinha copyWith({
    int? id,
    int? usuarioId,
    String? nomeCaixinha,
    double? saldoAtual,
    double? metaValor,
    bool? depositoObrigatorio,
    String? statusCaixinha,
    DateTime? dataConclusao,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    return Caixinha(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      nomeCaixinha: nomeCaixinha ?? this.nomeCaixinha,
      saldoAtual: saldoAtual ?? this.saldoAtual,
      metaValor: metaValor ?? this.metaValor,
      depositoObrigatorio: depositoObrigatorio ?? this.depositoObrigatorio,
      statusCaixinha: statusCaixinha ?? this.statusCaixinha,
      dataConclusao: dataConclusao ?? this.dataConclusao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
