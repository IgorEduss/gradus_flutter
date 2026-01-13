import '../../domain/entities/usuario.dart';
import '../../domain/entities/fundo.dart';
import '../../domain/entities/caixinha.dart';
import '../../domain/entities/emprestimo.dart';
import '../../domain/entities/compromisso.dart';
import '../../domain/entities/transacao.dart';
import '../local/db/app_database.dart' as db;

extension UsuarioMapper on db.Usuario {
  Usuario toDomain() {
    return Usuario(
      id: id,
      userCloudId: userCloudId,
      nome: nome,
      unidadePagamento: unidadePagamento,
      diaRevisaoMensal: diaRevisaoMensal,
      inflacaoAplicarFerEmprestimos: inflacaoAplicarFerEmprestimos,
      inflacaoAplicarFerFacilitadores: inflacaoAplicarFerFacilitadores,
      inflacaoAplicarMspDepositos: inflacaoAplicarMspDepositos,
      dataCriacao: dataCriacao,
      dataAtualizacao: dataAtualizacao,
    );
  }
}

extension FundoMapper on db.FundosPrincipai {
  Fundo toDomain() {
    return Fundo(
      id: id,
      usuarioId: usuarioId,
      tipoFundo: tipoFundo,
      nomeFundo: nomeFundo,
      saldoAtual: saldoAtual,
      picoPatrimonioTotalAlcancado: picoPatrimonioTotalAlcancado,
      dataCriacao: dataCriacao,
      dataAtualizacao: dataAtualizacao,
    );
  }
}

extension CaixinhaMapper on db.Caixinha {
  Caixinha toDomain() {
    return Caixinha(
      id: id,
      usuarioId: usuarioId,
      nomeCaixinha: nomeCaixinha,
      saldoAtual: saldoAtual,
      metaValor: metaValor,
      depositoObrigatorio: depositoObrigatorio,
      statusCaixinha: statusCaixinha,
      dataConclusao: dataConclusao,
      dataCriacao: dataCriacao,
      dataAtualizacao: dataAtualizacao,
    );
  }
}

extension EmprestimoMapper on db.Emprestimo {
  Emprestimo toDomain() {
    return Emprestimo(
      id: id,
      usuarioId: usuarioId,
      fundoOrigemId: fundoOrigemId,
      valorConcedido: valorConcedido,
      saldoDevedorAtual: saldoDevedorAtual,
      proposito: proposito,
      statusEmprestimo: statusEmprestimo,
      dataConcessao: dataConcessao,
      dataQuitacao: dataQuitacao,
      dataUltimoAjusteInflacao: dataUltimoAjusteInflacao,
      dataCriacao: dataCriacao,
      dataAtualizacao: dataAtualizacao,
    );
  }
}

extension CompromissoMapper on db.Compromisso {
  Compromisso toDomain() {
    return Compromisso(
      id: id,
      usuarioId: usuarioId,
      descricao: descricao,
      tipoCompromisso: tipoCompromisso,
      valorTotalComprometido: valorTotalComprometido,
      valorParcela: valorParcela,
      numeroTotalParcelas: numeroTotalParcelas,
      numeroParcelasPagas: numeroParcelasPagas,
      fundoPrincipalDestinoId: fundoPrincipalDestinoId,
      caixinhaDestinoId: caixinhaDestinoId,
      dataInicioCompromisso: dataInicioCompromisso,
      dataProximoVencimento: dataProximoVencimento,
      statusCompromisso: statusCompromisso,
      ajusteInflacaoAplicavel: ajusteInflacaoAplicavel,
      dataUltimoAjusteInflacao: dataUltimoAjusteInflacao,
      dataCriacao: dataCriacao,
      dataAtualizacao: dataAtualizacao,
    );
  }
}

extension TransacaoMapper on db.Transacoe {
  Transacao toDomain() {
    return Transacao(
      id: id,
      usuarioId: usuarioId,
      valor: valor,
      dataTransacao: dataTransacao,
      descricao: descricao,
      tipoTransacao: tipoTransacao,
      fundoPrincipalOrigemId: fundoPrincipalOrigemId,
      caixinhaOrigemId: caixinhaOrigemId,
      fundoPrincipalDestinoId: fundoPrincipalDestinoId,
      caixinhaDestinoId: caixinhaDestinoId,
      emprestimoId: emprestimoId,
      compromissoId: compromissoId,
      dataCriacao: dataCriacao,
      dataAtualizacao: dataAtualizacao,
    );
  }
}
