import 'package:drift/drift.dart';

// 2.2.1. Tabela Usuarios
class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userCloudId => text().nullable()();
  TextColumn get nome => text().withDefault(const Constant('Usuário'))();
  RealColumn get unidadePagamento => real()();
  IntColumn get diaRevisaoMensal => integer()();
  BoolColumn get inflacaoAplicarFerEmprestimos => boolean().withDefault(const Constant(true))();
  BoolColumn get inflacaoAplicarFerFacilitadores => boolean().withDefault(const Constant(false))();
  BoolColumn get inflacaoAplicarMspDepositos => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dataCriacao => dateTime()();
  DateTimeColumn get dataAtualizacao => dateTime()();
}

// 2.2.2. Tabela FundosPrincipais
class FundosPrincipais extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get usuarioId => integer().references(Usuarios, #id)();
  TextColumn get tipoFundo => text()(); // "FER" ou "MSP"
  TextColumn get nomeFundo => text()();
  RealColumn get saldoAtual => real().withDefault(const Constant(0.0))();
  RealColumn get picoPatrimonioTotalAlcancado => real().withDefault(const Constant(0.0))();
  DateTimeColumn get dataCriacao => dateTime()();
  DateTimeColumn get dataAtualizacao => dateTime()();

  @override
  List<String> get customConstraints => [
    'UNIQUE(usuario_id, tipo_fundo)'
  ];
}

// 2.2.3. Tabela Caixinhas
class Caixinhas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get usuarioId => integer().references(Usuarios, #id)();
  TextColumn get nomeCaixinha => text()();
  RealColumn get saldoAtual => real().withDefault(const Constant(0.0))();
  RealColumn get metaValor => real().nullable()();
  BoolColumn get depositoObrigatorio => boolean().withDefault(const Constant(false))();
  TextColumn get statusCaixinha => text().withDefault(const Constant('ATIVA'))();
  DateTimeColumn get dataConclusao => dateTime().nullable()();
  DateTimeColumn get dataCriacao => dateTime()();
  DateTimeColumn get dataAtualizacao => dateTime()();
}

// 2.2.4. Tabela Emprestimos
class Emprestimos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get usuarioId => integer().references(Usuarios, #id)();
  IntColumn get fundoOrigemId => integer().references(FundosPrincipais, #id)();
  RealColumn get valorConcedido => real()();
  RealColumn get saldoDevedorAtual => real()();
  TextColumn get proposito => text().nullable()();
  TextColumn get statusEmprestimo => text()(); // "ATIVO", "QUITADO"
  DateTimeColumn get dataConcessao => dateTime()();
  DateTimeColumn get dataQuitacao => dateTime().nullable()();
  DateTimeColumn get dataUltimoAjusteInflacao => dateTime().nullable()();
  DateTimeColumn get dataCriacao => dateTime()();
  DateTimeColumn get dataAtualizacao => dateTime()();
}

// 2.2.5. Tabela Compromissos
class Compromissos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get usuarioId => integer().references(Usuarios, #id)();
  TextColumn get descricao => text()();
  TextColumn get tipoCompromisso => text()();
  RealColumn get valorTotalComprometido => real().nullable()();
  RealColumn get valorParcela => real()();
  IntColumn get numeroTotalParcelas => integer().nullable()();
  IntColumn get numeroParcelasPagas => integer().withDefault(const Constant(0))();
  IntColumn get fundoPrincipalDestinoId => integer().nullable().references(FundosPrincipais, #id)();
  IntColumn get caixinhaDestinoId => integer().nullable().references(Caixinhas, #id)();
  DateTimeColumn get dataInicioCompromisso => dateTime()();
  DateTimeColumn get dataProximoVencimento => dateTime().nullable()();
  TextColumn get statusCompromisso => text().withDefault(const Constant('ATIVO'))();
  BoolColumn get ajusteInflacaoAplicavel => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dataUltimoAjusteInflacao => dateTime().nullable()();
  DateTimeColumn get dataCriacao => dateTime()();
  DateTimeColumn get dataAtualizacao => dateTime()();
}

// 2.2.6. Tabela Transacoes
class Transacoes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get usuarioId => integer().references(Usuarios, #id)();
  RealColumn get valor => real()();
  DateTimeColumn get dataTransacao => dateTime()();
  TextColumn get descricao => text()();
  TextColumn get tipoTransacao => text()();
  IntColumn get fundoPrincipalOrigemId => integer().nullable().references(FundosPrincipais, #id)();
  IntColumn get caixinhaOrigemId => integer().nullable().references(Caixinhas, #id)();
  IntColumn get fundoPrincipalDestinoId => integer().nullable().references(FundosPrincipais, #id)();
  IntColumn get caixinhaDestinoId => integer().nullable().references(Caixinhas, #id)();
  IntColumn get emprestimoId => integer().nullable().references(Emprestimos, #id)();
  IntColumn get compromissoId => integer().nullable().references(Compromissos, #id)();
  DateTimeColumn get dataCriacao => dateTime()();
  DateTimeColumn get dataAtualizacao => dateTime()();
}
