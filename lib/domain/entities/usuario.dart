class Usuario {
  final int id;
  final String? userCloudId;
  final String nome;
  final double unidadePagamento;
  final int diaRevisaoMensal;
  final bool inflacaoAplicarFerEmprestimos;
  final bool inflacaoAplicarFerFacilitadores;
  final bool inflacaoAplicarMspDepositos;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  Usuario({
    required this.id,
    this.userCloudId,
    required this.nome,
    required this.unidadePagamento,
    required this.diaRevisaoMensal,
    required this.inflacaoAplicarFerEmprestimos,
    required this.inflacaoAplicarFerFacilitadores,
    required this.inflacaoAplicarMspDepositos,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });
}
