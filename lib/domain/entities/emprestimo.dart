class Emprestimo {
  final int id;
  final int usuarioId;
  final int fundoOrigemId;
  final double valorConcedido;
  final double saldoDevedorAtual;
  final String? proposito;
  final String statusEmprestimo; // "ATIVO", "QUITADO"
  final DateTime dataConcessao;
  final DateTime? dataQuitacao;
  final DateTime? dataUltimoAjusteInflacao;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  Emprestimo({
    required this.id,
    required this.usuarioId,
    required this.fundoOrigemId,
    required this.valorConcedido,
    required this.saldoDevedorAtual,
    this.proposito,
    required this.statusEmprestimo,
    required this.dataConcessao,
    this.dataQuitacao,
    this.dataUltimoAjusteInflacao,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });
}
