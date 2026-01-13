class Fundo {
  final int id;
  final int usuarioId;
  final String tipoFundo; // "FER" or "MSP"
  final String nomeFundo;
  final double saldoAtual;
  final double picoPatrimonioTotalAlcancado;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  Fundo({
    required this.id,
    required this.usuarioId,
    required this.tipoFundo,
    required this.nomeFundo,
    required this.saldoAtual,
    required this.picoPatrimonioTotalAlcancado,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  Fundo copyWith({
    int? id,
    int? usuarioId,
    String? tipoFundo,
    String? nomeFundo,
    double? saldoAtual,
    double? picoPatrimonioTotalAlcancado,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    return Fundo(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      tipoFundo: tipoFundo ?? this.tipoFundo,
      nomeFundo: nomeFundo ?? this.nomeFundo,
      saldoAtual: saldoAtual ?? this.saldoAtual,
      picoPatrimonioTotalAlcancado:
          picoPatrimonioTotalAlcancado ?? this.picoPatrimonioTotalAlcancado,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
