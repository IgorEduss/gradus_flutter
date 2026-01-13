// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsuariosTable extends Usuarios with TableInfo<$UsuariosTable, Usuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userCloudIdMeta = const VerificationMeta(
    'userCloudId',
  );
  @override
  late final GeneratedColumn<String> userCloudId = GeneratedColumn<String>(
    'user_cloud_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Usuário'),
  );
  static const VerificationMeta _unidadePagamentoMeta = const VerificationMeta(
    'unidadePagamento',
  );
  @override
  late final GeneratedColumn<double> unidadePagamento = GeneratedColumn<double>(
    'unidade_pagamento',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diaRevisaoMensalMeta = const VerificationMeta(
    'diaRevisaoMensal',
  );
  @override
  late final GeneratedColumn<int> diaRevisaoMensal = GeneratedColumn<int>(
    'dia_revisao_mensal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inflacaoAplicarFerEmprestimosMeta =
      const VerificationMeta('inflacaoAplicarFerEmprestimos');
  @override
  late final GeneratedColumn<bool> inflacaoAplicarFerEmprestimos =
      GeneratedColumn<bool>(
        'inflacao_aplicar_fer_emprestimos',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("inflacao_aplicar_fer_emprestimos" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _inflacaoAplicarFerFacilitadoresMeta =
      const VerificationMeta('inflacaoAplicarFerFacilitadores');
  @override
  late final GeneratedColumn<bool> inflacaoAplicarFerFacilitadores =
      GeneratedColumn<bool>(
        'inflacao_aplicar_fer_facilitadores',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("inflacao_aplicar_fer_facilitadores" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _inflacaoAplicarMspDepositosMeta =
      const VerificationMeta('inflacaoAplicarMspDepositos');
  @override
  late final GeneratedColumn<bool> inflacaoAplicarMspDepositos =
      GeneratedColumn<bool>(
        'inflacao_aplicar_msp_depositos',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("inflacao_aplicar_msp_depositos" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userCloudId,
    nome,
    unidadePagamento,
    diaRevisaoMensal,
    inflacaoAplicarFerEmprestimos,
    inflacaoAplicarFerFacilitadores,
    inflacaoAplicarMspDepositos,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Usuario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_cloud_id')) {
      context.handle(
        _userCloudIdMeta,
        userCloudId.isAcceptableOrUnknown(
          data['user_cloud_id']!,
          _userCloudIdMeta,
        ),
      );
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    }
    if (data.containsKey('unidade_pagamento')) {
      context.handle(
        _unidadePagamentoMeta,
        unidadePagamento.isAcceptableOrUnknown(
          data['unidade_pagamento']!,
          _unidadePagamentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unidadePagamentoMeta);
    }
    if (data.containsKey('dia_revisao_mensal')) {
      context.handle(
        _diaRevisaoMensalMeta,
        diaRevisaoMensal.isAcceptableOrUnknown(
          data['dia_revisao_mensal']!,
          _diaRevisaoMensalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diaRevisaoMensalMeta);
    }
    if (data.containsKey('inflacao_aplicar_fer_emprestimos')) {
      context.handle(
        _inflacaoAplicarFerEmprestimosMeta,
        inflacaoAplicarFerEmprestimos.isAcceptableOrUnknown(
          data['inflacao_aplicar_fer_emprestimos']!,
          _inflacaoAplicarFerEmprestimosMeta,
        ),
      );
    }
    if (data.containsKey('inflacao_aplicar_fer_facilitadores')) {
      context.handle(
        _inflacaoAplicarFerFacilitadoresMeta,
        inflacaoAplicarFerFacilitadores.isAcceptableOrUnknown(
          data['inflacao_aplicar_fer_facilitadores']!,
          _inflacaoAplicarFerFacilitadoresMeta,
        ),
      );
    }
    if (data.containsKey('inflacao_aplicar_msp_depositos')) {
      context.handle(
        _inflacaoAplicarMspDepositosMeta,
        inflacaoAplicarMspDepositos.isAcceptableOrUnknown(
          data['inflacao_aplicar_msp_depositos']!,
          _inflacaoAplicarMspDepositosMeta,
        ),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataAtualizacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Usuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Usuario(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userCloudId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_cloud_id'],
      ),
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      unidadePagamento: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unidade_pagamento'],
      )!,
      diaRevisaoMensal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_revisao_mensal'],
      )!,
      inflacaoAplicarFerEmprestimos: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}inflacao_aplicar_fer_emprestimos'],
      )!,
      inflacaoAplicarFerFacilitadores: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}inflacao_aplicar_fer_facilitadores'],
      )!,
      inflacaoAplicarMspDepositos: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}inflacao_aplicar_msp_depositos'],
      )!,
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      )!,
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }
}

class Usuario extends DataClass implements Insertable<Usuario> {
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
  const Usuario({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userCloudId != null) {
      map['user_cloud_id'] = Variable<String>(userCloudId);
    }
    map['nome'] = Variable<String>(nome);
    map['unidade_pagamento'] = Variable<double>(unidadePagamento);
    map['dia_revisao_mensal'] = Variable<int>(diaRevisaoMensal);
    map['inflacao_aplicar_fer_emprestimos'] = Variable<bool>(
      inflacaoAplicarFerEmprestimos,
    );
    map['inflacao_aplicar_fer_facilitadores'] = Variable<bool>(
      inflacaoAplicarFerFacilitadores,
    );
    map['inflacao_aplicar_msp_depositos'] = Variable<bool>(
      inflacaoAplicarMspDepositos,
    );
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      userCloudId: userCloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(userCloudId),
      nome: Value(nome),
      unidadePagamento: Value(unidadePagamento),
      diaRevisaoMensal: Value(diaRevisaoMensal),
      inflacaoAplicarFerEmprestimos: Value(inflacaoAplicarFerEmprestimos),
      inflacaoAplicarFerFacilitadores: Value(inflacaoAplicarFerFacilitadores),
      inflacaoAplicarMspDepositos: Value(inflacaoAplicarMspDepositos),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: Value(dataAtualizacao),
    );
  }

  factory Usuario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Usuario(
      id: serializer.fromJson<int>(json['id']),
      userCloudId: serializer.fromJson<String?>(json['userCloudId']),
      nome: serializer.fromJson<String>(json['nome']),
      unidadePagamento: serializer.fromJson<double>(json['unidadePagamento']),
      diaRevisaoMensal: serializer.fromJson<int>(json['diaRevisaoMensal']),
      inflacaoAplicarFerEmprestimos: serializer.fromJson<bool>(
        json['inflacaoAplicarFerEmprestimos'],
      ),
      inflacaoAplicarFerFacilitadores: serializer.fromJson<bool>(
        json['inflacaoAplicarFerFacilitadores'],
      ),
      inflacaoAplicarMspDepositos: serializer.fromJson<bool>(
        json['inflacaoAplicarMspDepositos'],
      ),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userCloudId': serializer.toJson<String?>(userCloudId),
      'nome': serializer.toJson<String>(nome),
      'unidadePagamento': serializer.toJson<double>(unidadePagamento),
      'diaRevisaoMensal': serializer.toJson<int>(diaRevisaoMensal),
      'inflacaoAplicarFerEmprestimos': serializer.toJson<bool>(
        inflacaoAplicarFerEmprestimos,
      ),
      'inflacaoAplicarFerFacilitadores': serializer.toJson<bool>(
        inflacaoAplicarFerFacilitadores,
      ),
      'inflacaoAplicarMspDepositos': serializer.toJson<bool>(
        inflacaoAplicarMspDepositos,
      ),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime>(dataAtualizacao),
    };
  }

  Usuario copyWith({
    int? id,
    Value<String?> userCloudId = const Value.absent(),
    String? nome,
    double? unidadePagamento,
    int? diaRevisaoMensal,
    bool? inflacaoAplicarFerEmprestimos,
    bool? inflacaoAplicarFerFacilitadores,
    bool? inflacaoAplicarMspDepositos,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) => Usuario(
    id: id ?? this.id,
    userCloudId: userCloudId.present ? userCloudId.value : this.userCloudId,
    nome: nome ?? this.nome,
    unidadePagamento: unidadePagamento ?? this.unidadePagamento,
    diaRevisaoMensal: diaRevisaoMensal ?? this.diaRevisaoMensal,
    inflacaoAplicarFerEmprestimos:
        inflacaoAplicarFerEmprestimos ?? this.inflacaoAplicarFerEmprestimos,
    inflacaoAplicarFerFacilitadores:
        inflacaoAplicarFerFacilitadores ?? this.inflacaoAplicarFerFacilitadores,
    inflacaoAplicarMspDepositos:
        inflacaoAplicarMspDepositos ?? this.inflacaoAplicarMspDepositos,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
  );
  Usuario copyWithCompanion(UsuariosCompanion data) {
    return Usuario(
      id: data.id.present ? data.id.value : this.id,
      userCloudId: data.userCloudId.present
          ? data.userCloudId.value
          : this.userCloudId,
      nome: data.nome.present ? data.nome.value : this.nome,
      unidadePagamento: data.unidadePagamento.present
          ? data.unidadePagamento.value
          : this.unidadePagamento,
      diaRevisaoMensal: data.diaRevisaoMensal.present
          ? data.diaRevisaoMensal.value
          : this.diaRevisaoMensal,
      inflacaoAplicarFerEmprestimos: data.inflacaoAplicarFerEmprestimos.present
          ? data.inflacaoAplicarFerEmprestimos.value
          : this.inflacaoAplicarFerEmprestimos,
      inflacaoAplicarFerFacilitadores:
          data.inflacaoAplicarFerFacilitadores.present
          ? data.inflacaoAplicarFerFacilitadores.value
          : this.inflacaoAplicarFerFacilitadores,
      inflacaoAplicarMspDepositos: data.inflacaoAplicarMspDepositos.present
          ? data.inflacaoAplicarMspDepositos.value
          : this.inflacaoAplicarMspDepositos,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Usuario(')
          ..write('id: $id, ')
          ..write('userCloudId: $userCloudId, ')
          ..write('nome: $nome, ')
          ..write('unidadePagamento: $unidadePagamento, ')
          ..write('diaRevisaoMensal: $diaRevisaoMensal, ')
          ..write(
            'inflacaoAplicarFerEmprestimos: $inflacaoAplicarFerEmprestimos, ',
          )
          ..write(
            'inflacaoAplicarFerFacilitadores: $inflacaoAplicarFerFacilitadores, ',
          )
          ..write('inflacaoAplicarMspDepositos: $inflacaoAplicarMspDepositos, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userCloudId,
    nome,
    unidadePagamento,
    diaRevisaoMensal,
    inflacaoAplicarFerEmprestimos,
    inflacaoAplicarFerFacilitadores,
    inflacaoAplicarMspDepositos,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Usuario &&
          other.id == this.id &&
          other.userCloudId == this.userCloudId &&
          other.nome == this.nome &&
          other.unidadePagamento == this.unidadePagamento &&
          other.diaRevisaoMensal == this.diaRevisaoMensal &&
          other.inflacaoAplicarFerEmprestimos ==
              this.inflacaoAplicarFerEmprestimos &&
          other.inflacaoAplicarFerFacilitadores ==
              this.inflacaoAplicarFerFacilitadores &&
          other.inflacaoAplicarMspDepositos ==
              this.inflacaoAplicarMspDepositos &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class UsuariosCompanion extends UpdateCompanion<Usuario> {
  final Value<int> id;
  final Value<String?> userCloudId;
  final Value<String> nome;
  final Value<double> unidadePagamento;
  final Value<int> diaRevisaoMensal;
  final Value<bool> inflacaoAplicarFerEmprestimos;
  final Value<bool> inflacaoAplicarFerFacilitadores;
  final Value<bool> inflacaoAplicarMspDepositos;
  final Value<DateTime> dataCriacao;
  final Value<DateTime> dataAtualizacao;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.userCloudId = const Value.absent(),
    this.nome = const Value.absent(),
    this.unidadePagamento = const Value.absent(),
    this.diaRevisaoMensal = const Value.absent(),
    this.inflacaoAplicarFerEmprestimos = const Value.absent(),
    this.inflacaoAplicarFerFacilitadores = const Value.absent(),
    this.inflacaoAplicarMspDepositos = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  UsuariosCompanion.insert({
    this.id = const Value.absent(),
    this.userCloudId = const Value.absent(),
    this.nome = const Value.absent(),
    required double unidadePagamento,
    required int diaRevisaoMensal,
    this.inflacaoAplicarFerEmprestimos = const Value.absent(),
    this.inflacaoAplicarFerFacilitadores = const Value.absent(),
    this.inflacaoAplicarMspDepositos = const Value.absent(),
    required DateTime dataCriacao,
    required DateTime dataAtualizacao,
  }) : unidadePagamento = Value(unidadePagamento),
       diaRevisaoMensal = Value(diaRevisaoMensal),
       dataCriacao = Value(dataCriacao),
       dataAtualizacao = Value(dataAtualizacao);
  static Insertable<Usuario> custom({
    Expression<int>? id,
    Expression<String>? userCloudId,
    Expression<String>? nome,
    Expression<double>? unidadePagamento,
    Expression<int>? diaRevisaoMensal,
    Expression<bool>? inflacaoAplicarFerEmprestimos,
    Expression<bool>? inflacaoAplicarFerFacilitadores,
    Expression<bool>? inflacaoAplicarMspDepositos,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userCloudId != null) 'user_cloud_id': userCloudId,
      if (nome != null) 'nome': nome,
      if (unidadePagamento != null) 'unidade_pagamento': unidadePagamento,
      if (diaRevisaoMensal != null) 'dia_revisao_mensal': diaRevisaoMensal,
      if (inflacaoAplicarFerEmprestimos != null)
        'inflacao_aplicar_fer_emprestimos': inflacaoAplicarFerEmprestimos,
      if (inflacaoAplicarFerFacilitadores != null)
        'inflacao_aplicar_fer_facilitadores': inflacaoAplicarFerFacilitadores,
      if (inflacaoAplicarMspDepositos != null)
        'inflacao_aplicar_msp_depositos': inflacaoAplicarMspDepositos,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  UsuariosCompanion copyWith({
    Value<int>? id,
    Value<String?>? userCloudId,
    Value<String>? nome,
    Value<double>? unidadePagamento,
    Value<int>? diaRevisaoMensal,
    Value<bool>? inflacaoAplicarFerEmprestimos,
    Value<bool>? inflacaoAplicarFerFacilitadores,
    Value<bool>? inflacaoAplicarMspDepositos,
    Value<DateTime>? dataCriacao,
    Value<DateTime>? dataAtualizacao,
  }) {
    return UsuariosCompanion(
      id: id ?? this.id,
      userCloudId: userCloudId ?? this.userCloudId,
      nome: nome ?? this.nome,
      unidadePagamento: unidadePagamento ?? this.unidadePagamento,
      diaRevisaoMensal: diaRevisaoMensal ?? this.diaRevisaoMensal,
      inflacaoAplicarFerEmprestimos:
          inflacaoAplicarFerEmprestimos ?? this.inflacaoAplicarFerEmprestimos,
      inflacaoAplicarFerFacilitadores:
          inflacaoAplicarFerFacilitadores ??
          this.inflacaoAplicarFerFacilitadores,
      inflacaoAplicarMspDepositos:
          inflacaoAplicarMspDepositos ?? this.inflacaoAplicarMspDepositos,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userCloudId.present) {
      map['user_cloud_id'] = Variable<String>(userCloudId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (unidadePagamento.present) {
      map['unidade_pagamento'] = Variable<double>(unidadePagamento.value);
    }
    if (diaRevisaoMensal.present) {
      map['dia_revisao_mensal'] = Variable<int>(diaRevisaoMensal.value);
    }
    if (inflacaoAplicarFerEmprestimos.present) {
      map['inflacao_aplicar_fer_emprestimos'] = Variable<bool>(
        inflacaoAplicarFerEmprestimos.value,
      );
    }
    if (inflacaoAplicarFerFacilitadores.present) {
      map['inflacao_aplicar_fer_facilitadores'] = Variable<bool>(
        inflacaoAplicarFerFacilitadores.value,
      );
    }
    if (inflacaoAplicarMspDepositos.present) {
      map['inflacao_aplicar_msp_depositos'] = Variable<bool>(
        inflacaoAplicarMspDepositos.value,
      );
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('userCloudId: $userCloudId, ')
          ..write('nome: $nome, ')
          ..write('unidadePagamento: $unidadePagamento, ')
          ..write('diaRevisaoMensal: $diaRevisaoMensal, ')
          ..write(
            'inflacaoAplicarFerEmprestimos: $inflacaoAplicarFerEmprestimos, ',
          )
          ..write(
            'inflacaoAplicarFerFacilitadores: $inflacaoAplicarFerFacilitadores, ',
          )
          ..write('inflacaoAplicarMspDepositos: $inflacaoAplicarMspDepositos, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $FundosPrincipaisTable extends FundosPrincipais
    with TableInfo<$FundosPrincipaisTable, FundosPrincipai> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FundosPrincipaisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _tipoFundoMeta = const VerificationMeta(
    'tipoFundo',
  );
  @override
  late final GeneratedColumn<String> tipoFundo = GeneratedColumn<String>(
    'tipo_fundo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeFundoMeta = const VerificationMeta(
    'nomeFundo',
  );
  @override
  late final GeneratedColumn<String> nomeFundo = GeneratedColumn<String>(
    'nome_fundo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoAtualMeta = const VerificationMeta(
    'saldoAtual',
  );
  @override
  late final GeneratedColumn<double> saldoAtual = GeneratedColumn<double>(
    'saldo_atual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _picoPatrimonioTotalAlcancadoMeta =
      const VerificationMeta('picoPatrimonioTotalAlcancado');
  @override
  late final GeneratedColumn<double> picoPatrimonioTotalAlcancado =
      GeneratedColumn<double>(
        'pico_patrimonio_total_alcancado',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    tipoFundo,
    nomeFundo,
    saldoAtual,
    picoPatrimonioTotalAlcancado,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fundos_principais';
  @override
  VerificationContext validateIntegrity(
    Insertable<FundosPrincipai> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('tipo_fundo')) {
      context.handle(
        _tipoFundoMeta,
        tipoFundo.isAcceptableOrUnknown(data['tipo_fundo']!, _tipoFundoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoFundoMeta);
    }
    if (data.containsKey('nome_fundo')) {
      context.handle(
        _nomeFundoMeta,
        nomeFundo.isAcceptableOrUnknown(data['nome_fundo']!, _nomeFundoMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeFundoMeta);
    }
    if (data.containsKey('saldo_atual')) {
      context.handle(
        _saldoAtualMeta,
        saldoAtual.isAcceptableOrUnknown(data['saldo_atual']!, _saldoAtualMeta),
      );
    }
    if (data.containsKey('pico_patrimonio_total_alcancado')) {
      context.handle(
        _picoPatrimonioTotalAlcancadoMeta,
        picoPatrimonioTotalAlcancado.isAcceptableOrUnknown(
          data['pico_patrimonio_total_alcancado']!,
          _picoPatrimonioTotalAlcancadoMeta,
        ),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataAtualizacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FundosPrincipai map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FundosPrincipai(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      tipoFundo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_fundo'],
      )!,
      nomeFundo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_fundo'],
      )!,
      saldoAtual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_atual'],
      )!,
      picoPatrimonioTotalAlcancado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pico_patrimonio_total_alcancado'],
      )!,
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      )!,
    );
  }

  @override
  $FundosPrincipaisTable createAlias(String alias) {
    return $FundosPrincipaisTable(attachedDatabase, alias);
  }
}

class FundosPrincipai extends DataClass implements Insertable<FundosPrincipai> {
  final int id;
  final int usuarioId;
  final String tipoFundo;
  final String nomeFundo;
  final double saldoAtual;
  final double picoPatrimonioTotalAlcancado;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  const FundosPrincipai({
    required this.id,
    required this.usuarioId,
    required this.tipoFundo,
    required this.nomeFundo,
    required this.saldoAtual,
    required this.picoPatrimonioTotalAlcancado,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['tipo_fundo'] = Variable<String>(tipoFundo);
    map['nome_fundo'] = Variable<String>(nomeFundo);
    map['saldo_atual'] = Variable<double>(saldoAtual);
    map['pico_patrimonio_total_alcancado'] = Variable<double>(
      picoPatrimonioTotalAlcancado,
    );
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    return map;
  }

  FundosPrincipaisCompanion toCompanion(bool nullToAbsent) {
    return FundosPrincipaisCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      tipoFundo: Value(tipoFundo),
      nomeFundo: Value(nomeFundo),
      saldoAtual: Value(saldoAtual),
      picoPatrimonioTotalAlcancado: Value(picoPatrimonioTotalAlcancado),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: Value(dataAtualizacao),
    );
  }

  factory FundosPrincipai.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FundosPrincipai(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      tipoFundo: serializer.fromJson<String>(json['tipoFundo']),
      nomeFundo: serializer.fromJson<String>(json['nomeFundo']),
      saldoAtual: serializer.fromJson<double>(json['saldoAtual']),
      picoPatrimonioTotalAlcancado: serializer.fromJson<double>(
        json['picoPatrimonioTotalAlcancado'],
      ),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'tipoFundo': serializer.toJson<String>(tipoFundo),
      'nomeFundo': serializer.toJson<String>(nomeFundo),
      'saldoAtual': serializer.toJson<double>(saldoAtual),
      'picoPatrimonioTotalAlcancado': serializer.toJson<double>(
        picoPatrimonioTotalAlcancado,
      ),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime>(dataAtualizacao),
    };
  }

  FundosPrincipai copyWith({
    int? id,
    int? usuarioId,
    String? tipoFundo,
    String? nomeFundo,
    double? saldoAtual,
    double? picoPatrimonioTotalAlcancado,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) => FundosPrincipai(
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
  FundosPrincipai copyWithCompanion(FundosPrincipaisCompanion data) {
    return FundosPrincipai(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      tipoFundo: data.tipoFundo.present ? data.tipoFundo.value : this.tipoFundo,
      nomeFundo: data.nomeFundo.present ? data.nomeFundo.value : this.nomeFundo,
      saldoAtual: data.saldoAtual.present
          ? data.saldoAtual.value
          : this.saldoAtual,
      picoPatrimonioTotalAlcancado: data.picoPatrimonioTotalAlcancado.present
          ? data.picoPatrimonioTotalAlcancado.value
          : this.picoPatrimonioTotalAlcancado,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FundosPrincipai(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('tipoFundo: $tipoFundo, ')
          ..write('nomeFundo: $nomeFundo, ')
          ..write('saldoAtual: $saldoAtual, ')
          ..write(
            'picoPatrimonioTotalAlcancado: $picoPatrimonioTotalAlcancado, ',
          )
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    tipoFundo,
    nomeFundo,
    saldoAtual,
    picoPatrimonioTotalAlcancado,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FundosPrincipai &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.tipoFundo == this.tipoFundo &&
          other.nomeFundo == this.nomeFundo &&
          other.saldoAtual == this.saldoAtual &&
          other.picoPatrimonioTotalAlcancado ==
              this.picoPatrimonioTotalAlcancado &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class FundosPrincipaisCompanion extends UpdateCompanion<FundosPrincipai> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<String> tipoFundo;
  final Value<String> nomeFundo;
  final Value<double> saldoAtual;
  final Value<double> picoPatrimonioTotalAlcancado;
  final Value<DateTime> dataCriacao;
  final Value<DateTime> dataAtualizacao;
  const FundosPrincipaisCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.tipoFundo = const Value.absent(),
    this.nomeFundo = const Value.absent(),
    this.saldoAtual = const Value.absent(),
    this.picoPatrimonioTotalAlcancado = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  FundosPrincipaisCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    required String tipoFundo,
    required String nomeFundo,
    this.saldoAtual = const Value.absent(),
    this.picoPatrimonioTotalAlcancado = const Value.absent(),
    required DateTime dataCriacao,
    required DateTime dataAtualizacao,
  }) : usuarioId = Value(usuarioId),
       tipoFundo = Value(tipoFundo),
       nomeFundo = Value(nomeFundo),
       dataCriacao = Value(dataCriacao),
       dataAtualizacao = Value(dataAtualizacao);
  static Insertable<FundosPrincipai> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<String>? tipoFundo,
    Expression<String>? nomeFundo,
    Expression<double>? saldoAtual,
    Expression<double>? picoPatrimonioTotalAlcancado,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (tipoFundo != null) 'tipo_fundo': tipoFundo,
      if (nomeFundo != null) 'nome_fundo': nomeFundo,
      if (saldoAtual != null) 'saldo_atual': saldoAtual,
      if (picoPatrimonioTotalAlcancado != null)
        'pico_patrimonio_total_alcancado': picoPatrimonioTotalAlcancado,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  FundosPrincipaisCompanion copyWith({
    Value<int>? id,
    Value<int>? usuarioId,
    Value<String>? tipoFundo,
    Value<String>? nomeFundo,
    Value<double>? saldoAtual,
    Value<double>? picoPatrimonioTotalAlcancado,
    Value<DateTime>? dataCriacao,
    Value<DateTime>? dataAtualizacao,
  }) {
    return FundosPrincipaisCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (tipoFundo.present) {
      map['tipo_fundo'] = Variable<String>(tipoFundo.value);
    }
    if (nomeFundo.present) {
      map['nome_fundo'] = Variable<String>(nomeFundo.value);
    }
    if (saldoAtual.present) {
      map['saldo_atual'] = Variable<double>(saldoAtual.value);
    }
    if (picoPatrimonioTotalAlcancado.present) {
      map['pico_patrimonio_total_alcancado'] = Variable<double>(
        picoPatrimonioTotalAlcancado.value,
      );
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FundosPrincipaisCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('tipoFundo: $tipoFundo, ')
          ..write('nomeFundo: $nomeFundo, ')
          ..write('saldoAtual: $saldoAtual, ')
          ..write(
            'picoPatrimonioTotalAlcancado: $picoPatrimonioTotalAlcancado, ',
          )
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $CaixinhasTable extends Caixinhas
    with TableInfo<$CaixinhasTable, Caixinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaixinhasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _nomeCaixinhaMeta = const VerificationMeta(
    'nomeCaixinha',
  );
  @override
  late final GeneratedColumn<String> nomeCaixinha = GeneratedColumn<String>(
    'nome_caixinha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoAtualMeta = const VerificationMeta(
    'saldoAtual',
  );
  @override
  late final GeneratedColumn<double> saldoAtual = GeneratedColumn<double>(
    'saldo_atual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _metaValorMeta = const VerificationMeta(
    'metaValor',
  );
  @override
  late final GeneratedColumn<double> metaValor = GeneratedColumn<double>(
    'meta_valor',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _depositoObrigatorioMeta =
      const VerificationMeta('depositoObrigatorio');
  @override
  late final GeneratedColumn<bool> depositoObrigatorio = GeneratedColumn<bool>(
    'deposito_obrigatorio',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deposito_obrigatorio" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusCaixinhaMeta = const VerificationMeta(
    'statusCaixinha',
  );
  @override
  late final GeneratedColumn<String> statusCaixinha = GeneratedColumn<String>(
    'status_caixinha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ATIVA'),
  );
  static const VerificationMeta _dataConclusaoMeta = const VerificationMeta(
    'dataConclusao',
  );
  @override
  late final GeneratedColumn<DateTime> dataConclusao =
      GeneratedColumn<DateTime>(
        'data_conclusao',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    nomeCaixinha,
    saldoAtual,
    metaValor,
    depositoObrigatorio,
    statusCaixinha,
    dataConclusao,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'caixinhas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Caixinha> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('nome_caixinha')) {
      context.handle(
        _nomeCaixinhaMeta,
        nomeCaixinha.isAcceptableOrUnknown(
          data['nome_caixinha']!,
          _nomeCaixinhaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nomeCaixinhaMeta);
    }
    if (data.containsKey('saldo_atual')) {
      context.handle(
        _saldoAtualMeta,
        saldoAtual.isAcceptableOrUnknown(data['saldo_atual']!, _saldoAtualMeta),
      );
    }
    if (data.containsKey('meta_valor')) {
      context.handle(
        _metaValorMeta,
        metaValor.isAcceptableOrUnknown(data['meta_valor']!, _metaValorMeta),
      );
    }
    if (data.containsKey('deposito_obrigatorio')) {
      context.handle(
        _depositoObrigatorioMeta,
        depositoObrigatorio.isAcceptableOrUnknown(
          data['deposito_obrigatorio']!,
          _depositoObrigatorioMeta,
        ),
      );
    }
    if (data.containsKey('status_caixinha')) {
      context.handle(
        _statusCaixinhaMeta,
        statusCaixinha.isAcceptableOrUnknown(
          data['status_caixinha']!,
          _statusCaixinhaMeta,
        ),
      );
    }
    if (data.containsKey('data_conclusao')) {
      context.handle(
        _dataConclusaoMeta,
        dataConclusao.isAcceptableOrUnknown(
          data['data_conclusao']!,
          _dataConclusaoMeta,
        ),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataAtualizacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Caixinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Caixinha(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      nomeCaixinha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_caixinha'],
      )!,
      saldoAtual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_atual'],
      )!,
      metaValor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}meta_valor'],
      ),
      depositoObrigatorio: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deposito_obrigatorio'],
      )!,
      statusCaixinha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_caixinha'],
      )!,
      dataConclusao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_conclusao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      )!,
    );
  }

  @override
  $CaixinhasTable createAlias(String alias) {
    return $CaixinhasTable(attachedDatabase, alias);
  }
}

class Caixinha extends DataClass implements Insertable<Caixinha> {
  final int id;
  final int usuarioId;
  final String nomeCaixinha;
  final double saldoAtual;
  final double? metaValor;
  final bool depositoObrigatorio;
  final String statusCaixinha;
  final DateTime? dataConclusao;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  const Caixinha({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['nome_caixinha'] = Variable<String>(nomeCaixinha);
    map['saldo_atual'] = Variable<double>(saldoAtual);
    if (!nullToAbsent || metaValor != null) {
      map['meta_valor'] = Variable<double>(metaValor);
    }
    map['deposito_obrigatorio'] = Variable<bool>(depositoObrigatorio);
    map['status_caixinha'] = Variable<String>(statusCaixinha);
    if (!nullToAbsent || dataConclusao != null) {
      map['data_conclusao'] = Variable<DateTime>(dataConclusao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    return map;
  }

  CaixinhasCompanion toCompanion(bool nullToAbsent) {
    return CaixinhasCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      nomeCaixinha: Value(nomeCaixinha),
      saldoAtual: Value(saldoAtual),
      metaValor: metaValor == null && nullToAbsent
          ? const Value.absent()
          : Value(metaValor),
      depositoObrigatorio: Value(depositoObrigatorio),
      statusCaixinha: Value(statusCaixinha),
      dataConclusao: dataConclusao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataConclusao),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: Value(dataAtualizacao),
    );
  }

  factory Caixinha.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Caixinha(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      nomeCaixinha: serializer.fromJson<String>(json['nomeCaixinha']),
      saldoAtual: serializer.fromJson<double>(json['saldoAtual']),
      metaValor: serializer.fromJson<double?>(json['metaValor']),
      depositoObrigatorio: serializer.fromJson<bool>(
        json['depositoObrigatorio'],
      ),
      statusCaixinha: serializer.fromJson<String>(json['statusCaixinha']),
      dataConclusao: serializer.fromJson<DateTime?>(json['dataConclusao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'nomeCaixinha': serializer.toJson<String>(nomeCaixinha),
      'saldoAtual': serializer.toJson<double>(saldoAtual),
      'metaValor': serializer.toJson<double?>(metaValor),
      'depositoObrigatorio': serializer.toJson<bool>(depositoObrigatorio),
      'statusCaixinha': serializer.toJson<String>(statusCaixinha),
      'dataConclusao': serializer.toJson<DateTime?>(dataConclusao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime>(dataAtualizacao),
    };
  }

  Caixinha copyWith({
    int? id,
    int? usuarioId,
    String? nomeCaixinha,
    double? saldoAtual,
    Value<double?> metaValor = const Value.absent(),
    bool? depositoObrigatorio,
    String? statusCaixinha,
    Value<DateTime?> dataConclusao = const Value.absent(),
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) => Caixinha(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    nomeCaixinha: nomeCaixinha ?? this.nomeCaixinha,
    saldoAtual: saldoAtual ?? this.saldoAtual,
    metaValor: metaValor.present ? metaValor.value : this.metaValor,
    depositoObrigatorio: depositoObrigatorio ?? this.depositoObrigatorio,
    statusCaixinha: statusCaixinha ?? this.statusCaixinha,
    dataConclusao: dataConclusao.present
        ? dataConclusao.value
        : this.dataConclusao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
  );
  Caixinha copyWithCompanion(CaixinhasCompanion data) {
    return Caixinha(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      nomeCaixinha: data.nomeCaixinha.present
          ? data.nomeCaixinha.value
          : this.nomeCaixinha,
      saldoAtual: data.saldoAtual.present
          ? data.saldoAtual.value
          : this.saldoAtual,
      metaValor: data.metaValor.present ? data.metaValor.value : this.metaValor,
      depositoObrigatorio: data.depositoObrigatorio.present
          ? data.depositoObrigatorio.value
          : this.depositoObrigatorio,
      statusCaixinha: data.statusCaixinha.present
          ? data.statusCaixinha.value
          : this.statusCaixinha,
      dataConclusao: data.dataConclusao.present
          ? data.dataConclusao.value
          : this.dataConclusao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Caixinha(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('nomeCaixinha: $nomeCaixinha, ')
          ..write('saldoAtual: $saldoAtual, ')
          ..write('metaValor: $metaValor, ')
          ..write('depositoObrigatorio: $depositoObrigatorio, ')
          ..write('statusCaixinha: $statusCaixinha, ')
          ..write('dataConclusao: $dataConclusao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    nomeCaixinha,
    saldoAtual,
    metaValor,
    depositoObrigatorio,
    statusCaixinha,
    dataConclusao,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Caixinha &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.nomeCaixinha == this.nomeCaixinha &&
          other.saldoAtual == this.saldoAtual &&
          other.metaValor == this.metaValor &&
          other.depositoObrigatorio == this.depositoObrigatorio &&
          other.statusCaixinha == this.statusCaixinha &&
          other.dataConclusao == this.dataConclusao &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class CaixinhasCompanion extends UpdateCompanion<Caixinha> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<String> nomeCaixinha;
  final Value<double> saldoAtual;
  final Value<double?> metaValor;
  final Value<bool> depositoObrigatorio;
  final Value<String> statusCaixinha;
  final Value<DateTime?> dataConclusao;
  final Value<DateTime> dataCriacao;
  final Value<DateTime> dataAtualizacao;
  const CaixinhasCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.nomeCaixinha = const Value.absent(),
    this.saldoAtual = const Value.absent(),
    this.metaValor = const Value.absent(),
    this.depositoObrigatorio = const Value.absent(),
    this.statusCaixinha = const Value.absent(),
    this.dataConclusao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  CaixinhasCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    required String nomeCaixinha,
    this.saldoAtual = const Value.absent(),
    this.metaValor = const Value.absent(),
    this.depositoObrigatorio = const Value.absent(),
    this.statusCaixinha = const Value.absent(),
    this.dataConclusao = const Value.absent(),
    required DateTime dataCriacao,
    required DateTime dataAtualizacao,
  }) : usuarioId = Value(usuarioId),
       nomeCaixinha = Value(nomeCaixinha),
       dataCriacao = Value(dataCriacao),
       dataAtualizacao = Value(dataAtualizacao);
  static Insertable<Caixinha> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<String>? nomeCaixinha,
    Expression<double>? saldoAtual,
    Expression<double>? metaValor,
    Expression<bool>? depositoObrigatorio,
    Expression<String>? statusCaixinha,
    Expression<DateTime>? dataConclusao,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (nomeCaixinha != null) 'nome_caixinha': nomeCaixinha,
      if (saldoAtual != null) 'saldo_atual': saldoAtual,
      if (metaValor != null) 'meta_valor': metaValor,
      if (depositoObrigatorio != null)
        'deposito_obrigatorio': depositoObrigatorio,
      if (statusCaixinha != null) 'status_caixinha': statusCaixinha,
      if (dataConclusao != null) 'data_conclusao': dataConclusao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  CaixinhasCompanion copyWith({
    Value<int>? id,
    Value<int>? usuarioId,
    Value<String>? nomeCaixinha,
    Value<double>? saldoAtual,
    Value<double?>? metaValor,
    Value<bool>? depositoObrigatorio,
    Value<String>? statusCaixinha,
    Value<DateTime?>? dataConclusao,
    Value<DateTime>? dataCriacao,
    Value<DateTime>? dataAtualizacao,
  }) {
    return CaixinhasCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (nomeCaixinha.present) {
      map['nome_caixinha'] = Variable<String>(nomeCaixinha.value);
    }
    if (saldoAtual.present) {
      map['saldo_atual'] = Variable<double>(saldoAtual.value);
    }
    if (metaValor.present) {
      map['meta_valor'] = Variable<double>(metaValor.value);
    }
    if (depositoObrigatorio.present) {
      map['deposito_obrigatorio'] = Variable<bool>(depositoObrigatorio.value);
    }
    if (statusCaixinha.present) {
      map['status_caixinha'] = Variable<String>(statusCaixinha.value);
    }
    if (dataConclusao.present) {
      map['data_conclusao'] = Variable<DateTime>(dataConclusao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaixinhasCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('nomeCaixinha: $nomeCaixinha, ')
          ..write('saldoAtual: $saldoAtual, ')
          ..write('metaValor: $metaValor, ')
          ..write('depositoObrigatorio: $depositoObrigatorio, ')
          ..write('statusCaixinha: $statusCaixinha, ')
          ..write('dataConclusao: $dataConclusao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $EmprestimosTable extends Emprestimos
    with TableInfo<$EmprestimosTable, Emprestimo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmprestimosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _fundoOrigemIdMeta = const VerificationMeta(
    'fundoOrigemId',
  );
  @override
  late final GeneratedColumn<int> fundoOrigemId = GeneratedColumn<int>(
    'fundo_origem_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES fundos_principais (id)',
    ),
  );
  static const VerificationMeta _valorConcedidoMeta = const VerificationMeta(
    'valorConcedido',
  );
  @override
  late final GeneratedColumn<double> valorConcedido = GeneratedColumn<double>(
    'valor_concedido',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoDevedorAtualMeta = const VerificationMeta(
    'saldoDevedorAtual',
  );
  @override
  late final GeneratedColumn<double> saldoDevedorAtual =
      GeneratedColumn<double>(
        'saldo_devedor_atual',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _propositoMeta = const VerificationMeta(
    'proposito',
  );
  @override
  late final GeneratedColumn<String> proposito = GeneratedColumn<String>(
    'proposito',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusEmprestimoMeta = const VerificationMeta(
    'statusEmprestimo',
  );
  @override
  late final GeneratedColumn<String> statusEmprestimo = GeneratedColumn<String>(
    'status_emprestimo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataConcessaoMeta = const VerificationMeta(
    'dataConcessao',
  );
  @override
  late final GeneratedColumn<DateTime> dataConcessao =
      GeneratedColumn<DateTime>(
        'data_concessao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dataQuitacaoMeta = const VerificationMeta(
    'dataQuitacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataQuitacao = GeneratedColumn<DateTime>(
    'data_quitacao',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataUltimoAjusteInflacaoMeta =
      const VerificationMeta('dataUltimoAjusteInflacao');
  @override
  late final GeneratedColumn<DateTime> dataUltimoAjusteInflacao =
      GeneratedColumn<DateTime>(
        'data_ultimo_ajuste_inflacao',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    fundoOrigemId,
    valorConcedido,
    saldoDevedorAtual,
    proposito,
    statusEmprestimo,
    dataConcessao,
    dataQuitacao,
    dataUltimoAjusteInflacao,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emprestimos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Emprestimo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fundo_origem_id')) {
      context.handle(
        _fundoOrigemIdMeta,
        fundoOrigemId.isAcceptableOrUnknown(
          data['fundo_origem_id']!,
          _fundoOrigemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fundoOrigemIdMeta);
    }
    if (data.containsKey('valor_concedido')) {
      context.handle(
        _valorConcedidoMeta,
        valorConcedido.isAcceptableOrUnknown(
          data['valor_concedido']!,
          _valorConcedidoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorConcedidoMeta);
    }
    if (data.containsKey('saldo_devedor_atual')) {
      context.handle(
        _saldoDevedorAtualMeta,
        saldoDevedorAtual.isAcceptableOrUnknown(
          data['saldo_devedor_atual']!,
          _saldoDevedorAtualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saldoDevedorAtualMeta);
    }
    if (data.containsKey('proposito')) {
      context.handle(
        _propositoMeta,
        proposito.isAcceptableOrUnknown(data['proposito']!, _propositoMeta),
      );
    }
    if (data.containsKey('status_emprestimo')) {
      context.handle(
        _statusEmprestimoMeta,
        statusEmprestimo.isAcceptableOrUnknown(
          data['status_emprestimo']!,
          _statusEmprestimoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statusEmprestimoMeta);
    }
    if (data.containsKey('data_concessao')) {
      context.handle(
        _dataConcessaoMeta,
        dataConcessao.isAcceptableOrUnknown(
          data['data_concessao']!,
          _dataConcessaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataConcessaoMeta);
    }
    if (data.containsKey('data_quitacao')) {
      context.handle(
        _dataQuitacaoMeta,
        dataQuitacao.isAcceptableOrUnknown(
          data['data_quitacao']!,
          _dataQuitacaoMeta,
        ),
      );
    }
    if (data.containsKey('data_ultimo_ajuste_inflacao')) {
      context.handle(
        _dataUltimoAjusteInflacaoMeta,
        dataUltimoAjusteInflacao.isAcceptableOrUnknown(
          data['data_ultimo_ajuste_inflacao']!,
          _dataUltimoAjusteInflacaoMeta,
        ),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataAtualizacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Emprestimo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Emprestimo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fundoOrigemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fundo_origem_id'],
      )!,
      valorConcedido: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_concedido'],
      )!,
      saldoDevedorAtual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_devedor_atual'],
      )!,
      proposito: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proposito'],
      ),
      statusEmprestimo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_emprestimo'],
      )!,
      dataConcessao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_concessao'],
      )!,
      dataQuitacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_quitacao'],
      ),
      dataUltimoAjusteInflacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_ultimo_ajuste_inflacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      )!,
    );
  }

  @override
  $EmprestimosTable createAlias(String alias) {
    return $EmprestimosTable(attachedDatabase, alias);
  }
}

class Emprestimo extends DataClass implements Insertable<Emprestimo> {
  final int id;
  final int usuarioId;
  final int fundoOrigemId;
  final double valorConcedido;
  final double saldoDevedorAtual;
  final String? proposito;
  final String statusEmprestimo;
  final DateTime dataConcessao;
  final DateTime? dataQuitacao;
  final DateTime? dataUltimoAjusteInflacao;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  const Emprestimo({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fundo_origem_id'] = Variable<int>(fundoOrigemId);
    map['valor_concedido'] = Variable<double>(valorConcedido);
    map['saldo_devedor_atual'] = Variable<double>(saldoDevedorAtual);
    if (!nullToAbsent || proposito != null) {
      map['proposito'] = Variable<String>(proposito);
    }
    map['status_emprestimo'] = Variable<String>(statusEmprestimo);
    map['data_concessao'] = Variable<DateTime>(dataConcessao);
    if (!nullToAbsent || dataQuitacao != null) {
      map['data_quitacao'] = Variable<DateTime>(dataQuitacao);
    }
    if (!nullToAbsent || dataUltimoAjusteInflacao != null) {
      map['data_ultimo_ajuste_inflacao'] = Variable<DateTime>(
        dataUltimoAjusteInflacao,
      );
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    return map;
  }

  EmprestimosCompanion toCompanion(bool nullToAbsent) {
    return EmprestimosCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      fundoOrigemId: Value(fundoOrigemId),
      valorConcedido: Value(valorConcedido),
      saldoDevedorAtual: Value(saldoDevedorAtual),
      proposito: proposito == null && nullToAbsent
          ? const Value.absent()
          : Value(proposito),
      statusEmprestimo: Value(statusEmprestimo),
      dataConcessao: Value(dataConcessao),
      dataQuitacao: dataQuitacao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataQuitacao),
      dataUltimoAjusteInflacao: dataUltimoAjusteInflacao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataUltimoAjusteInflacao),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: Value(dataAtualizacao),
    );
  }

  factory Emprestimo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Emprestimo(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      fundoOrigemId: serializer.fromJson<int>(json['fundoOrigemId']),
      valorConcedido: serializer.fromJson<double>(json['valorConcedido']),
      saldoDevedorAtual: serializer.fromJson<double>(json['saldoDevedorAtual']),
      proposito: serializer.fromJson<String?>(json['proposito']),
      statusEmprestimo: serializer.fromJson<String>(json['statusEmprestimo']),
      dataConcessao: serializer.fromJson<DateTime>(json['dataConcessao']),
      dataQuitacao: serializer.fromJson<DateTime?>(json['dataQuitacao']),
      dataUltimoAjusteInflacao: serializer.fromJson<DateTime?>(
        json['dataUltimoAjusteInflacao'],
      ),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'fundoOrigemId': serializer.toJson<int>(fundoOrigemId),
      'valorConcedido': serializer.toJson<double>(valorConcedido),
      'saldoDevedorAtual': serializer.toJson<double>(saldoDevedorAtual),
      'proposito': serializer.toJson<String?>(proposito),
      'statusEmprestimo': serializer.toJson<String>(statusEmprestimo),
      'dataConcessao': serializer.toJson<DateTime>(dataConcessao),
      'dataQuitacao': serializer.toJson<DateTime?>(dataQuitacao),
      'dataUltimoAjusteInflacao': serializer.toJson<DateTime?>(
        dataUltimoAjusteInflacao,
      ),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime>(dataAtualizacao),
    };
  }

  Emprestimo copyWith({
    int? id,
    int? usuarioId,
    int? fundoOrigemId,
    double? valorConcedido,
    double? saldoDevedorAtual,
    Value<String?> proposito = const Value.absent(),
    String? statusEmprestimo,
    DateTime? dataConcessao,
    Value<DateTime?> dataQuitacao = const Value.absent(),
    Value<DateTime?> dataUltimoAjusteInflacao = const Value.absent(),
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) => Emprestimo(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    fundoOrigemId: fundoOrigemId ?? this.fundoOrigemId,
    valorConcedido: valorConcedido ?? this.valorConcedido,
    saldoDevedorAtual: saldoDevedorAtual ?? this.saldoDevedorAtual,
    proposito: proposito.present ? proposito.value : this.proposito,
    statusEmprestimo: statusEmprestimo ?? this.statusEmprestimo,
    dataConcessao: dataConcessao ?? this.dataConcessao,
    dataQuitacao: dataQuitacao.present ? dataQuitacao.value : this.dataQuitacao,
    dataUltimoAjusteInflacao: dataUltimoAjusteInflacao.present
        ? dataUltimoAjusteInflacao.value
        : this.dataUltimoAjusteInflacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
  );
  Emprestimo copyWithCompanion(EmprestimosCompanion data) {
    return Emprestimo(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fundoOrigemId: data.fundoOrigemId.present
          ? data.fundoOrigemId.value
          : this.fundoOrigemId,
      valorConcedido: data.valorConcedido.present
          ? data.valorConcedido.value
          : this.valorConcedido,
      saldoDevedorAtual: data.saldoDevedorAtual.present
          ? data.saldoDevedorAtual.value
          : this.saldoDevedorAtual,
      proposito: data.proposito.present ? data.proposito.value : this.proposito,
      statusEmprestimo: data.statusEmprestimo.present
          ? data.statusEmprestimo.value
          : this.statusEmprestimo,
      dataConcessao: data.dataConcessao.present
          ? data.dataConcessao.value
          : this.dataConcessao,
      dataQuitacao: data.dataQuitacao.present
          ? data.dataQuitacao.value
          : this.dataQuitacao,
      dataUltimoAjusteInflacao: data.dataUltimoAjusteInflacao.present
          ? data.dataUltimoAjusteInflacao.value
          : this.dataUltimoAjusteInflacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Emprestimo(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fundoOrigemId: $fundoOrigemId, ')
          ..write('valorConcedido: $valorConcedido, ')
          ..write('saldoDevedorAtual: $saldoDevedorAtual, ')
          ..write('proposito: $proposito, ')
          ..write('statusEmprestimo: $statusEmprestimo, ')
          ..write('dataConcessao: $dataConcessao, ')
          ..write('dataQuitacao: $dataQuitacao, ')
          ..write('dataUltimoAjusteInflacao: $dataUltimoAjusteInflacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    fundoOrigemId,
    valorConcedido,
    saldoDevedorAtual,
    proposito,
    statusEmprestimo,
    dataConcessao,
    dataQuitacao,
    dataUltimoAjusteInflacao,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Emprestimo &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.fundoOrigemId == this.fundoOrigemId &&
          other.valorConcedido == this.valorConcedido &&
          other.saldoDevedorAtual == this.saldoDevedorAtual &&
          other.proposito == this.proposito &&
          other.statusEmprestimo == this.statusEmprestimo &&
          other.dataConcessao == this.dataConcessao &&
          other.dataQuitacao == this.dataQuitacao &&
          other.dataUltimoAjusteInflacao == this.dataUltimoAjusteInflacao &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class EmprestimosCompanion extends UpdateCompanion<Emprestimo> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<int> fundoOrigemId;
  final Value<double> valorConcedido;
  final Value<double> saldoDevedorAtual;
  final Value<String?> proposito;
  final Value<String> statusEmprestimo;
  final Value<DateTime> dataConcessao;
  final Value<DateTime?> dataQuitacao;
  final Value<DateTime?> dataUltimoAjusteInflacao;
  final Value<DateTime> dataCriacao;
  final Value<DateTime> dataAtualizacao;
  const EmprestimosCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fundoOrigemId = const Value.absent(),
    this.valorConcedido = const Value.absent(),
    this.saldoDevedorAtual = const Value.absent(),
    this.proposito = const Value.absent(),
    this.statusEmprestimo = const Value.absent(),
    this.dataConcessao = const Value.absent(),
    this.dataQuitacao = const Value.absent(),
    this.dataUltimoAjusteInflacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  EmprestimosCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    required int fundoOrigemId,
    required double valorConcedido,
    required double saldoDevedorAtual,
    this.proposito = const Value.absent(),
    required String statusEmprestimo,
    required DateTime dataConcessao,
    this.dataQuitacao = const Value.absent(),
    this.dataUltimoAjusteInflacao = const Value.absent(),
    required DateTime dataCriacao,
    required DateTime dataAtualizacao,
  }) : usuarioId = Value(usuarioId),
       fundoOrigemId = Value(fundoOrigemId),
       valorConcedido = Value(valorConcedido),
       saldoDevedorAtual = Value(saldoDevedorAtual),
       statusEmprestimo = Value(statusEmprestimo),
       dataConcessao = Value(dataConcessao),
       dataCriacao = Value(dataCriacao),
       dataAtualizacao = Value(dataAtualizacao);
  static Insertable<Emprestimo> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<int>? fundoOrigemId,
    Expression<double>? valorConcedido,
    Expression<double>? saldoDevedorAtual,
    Expression<String>? proposito,
    Expression<String>? statusEmprestimo,
    Expression<DateTime>? dataConcessao,
    Expression<DateTime>? dataQuitacao,
    Expression<DateTime>? dataUltimoAjusteInflacao,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fundoOrigemId != null) 'fundo_origem_id': fundoOrigemId,
      if (valorConcedido != null) 'valor_concedido': valorConcedido,
      if (saldoDevedorAtual != null) 'saldo_devedor_atual': saldoDevedorAtual,
      if (proposito != null) 'proposito': proposito,
      if (statusEmprestimo != null) 'status_emprestimo': statusEmprestimo,
      if (dataConcessao != null) 'data_concessao': dataConcessao,
      if (dataQuitacao != null) 'data_quitacao': dataQuitacao,
      if (dataUltimoAjusteInflacao != null)
        'data_ultimo_ajuste_inflacao': dataUltimoAjusteInflacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  EmprestimosCompanion copyWith({
    Value<int>? id,
    Value<int>? usuarioId,
    Value<int>? fundoOrigemId,
    Value<double>? valorConcedido,
    Value<double>? saldoDevedorAtual,
    Value<String?>? proposito,
    Value<String>? statusEmprestimo,
    Value<DateTime>? dataConcessao,
    Value<DateTime?>? dataQuitacao,
    Value<DateTime?>? dataUltimoAjusteInflacao,
    Value<DateTime>? dataCriacao,
    Value<DateTime>? dataAtualizacao,
  }) {
    return EmprestimosCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      fundoOrigemId: fundoOrigemId ?? this.fundoOrigemId,
      valorConcedido: valorConcedido ?? this.valorConcedido,
      saldoDevedorAtual: saldoDevedorAtual ?? this.saldoDevedorAtual,
      proposito: proposito ?? this.proposito,
      statusEmprestimo: statusEmprestimo ?? this.statusEmprestimo,
      dataConcessao: dataConcessao ?? this.dataConcessao,
      dataQuitacao: dataQuitacao ?? this.dataQuitacao,
      dataUltimoAjusteInflacao:
          dataUltimoAjusteInflacao ?? this.dataUltimoAjusteInflacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fundoOrigemId.present) {
      map['fundo_origem_id'] = Variable<int>(fundoOrigemId.value);
    }
    if (valorConcedido.present) {
      map['valor_concedido'] = Variable<double>(valorConcedido.value);
    }
    if (saldoDevedorAtual.present) {
      map['saldo_devedor_atual'] = Variable<double>(saldoDevedorAtual.value);
    }
    if (proposito.present) {
      map['proposito'] = Variable<String>(proposito.value);
    }
    if (statusEmprestimo.present) {
      map['status_emprestimo'] = Variable<String>(statusEmprestimo.value);
    }
    if (dataConcessao.present) {
      map['data_concessao'] = Variable<DateTime>(dataConcessao.value);
    }
    if (dataQuitacao.present) {
      map['data_quitacao'] = Variable<DateTime>(dataQuitacao.value);
    }
    if (dataUltimoAjusteInflacao.present) {
      map['data_ultimo_ajuste_inflacao'] = Variable<DateTime>(
        dataUltimoAjusteInflacao.value,
      );
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimosCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fundoOrigemId: $fundoOrigemId, ')
          ..write('valorConcedido: $valorConcedido, ')
          ..write('saldoDevedorAtual: $saldoDevedorAtual, ')
          ..write('proposito: $proposito, ')
          ..write('statusEmprestimo: $statusEmprestimo, ')
          ..write('dataConcessao: $dataConcessao, ')
          ..write('dataQuitacao: $dataQuitacao, ')
          ..write('dataUltimoAjusteInflacao: $dataUltimoAjusteInflacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $CompromissosTable extends Compromissos
    with TableInfo<$CompromissosTable, Compromisso> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompromissosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoCompromissoMeta = const VerificationMeta(
    'tipoCompromisso',
  );
  @override
  late final GeneratedColumn<String> tipoCompromisso = GeneratedColumn<String>(
    'tipo_compromisso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorTotalComprometidoMeta =
      const VerificationMeta('valorTotalComprometido');
  @override
  late final GeneratedColumn<double> valorTotalComprometido =
      GeneratedColumn<double>(
        'valor_total_comprometido',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _valorParcelaMeta = const VerificationMeta(
    'valorParcela',
  );
  @override
  late final GeneratedColumn<double> valorParcela = GeneratedColumn<double>(
    'valor_parcela',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroTotalParcelasMeta =
      const VerificationMeta('numeroTotalParcelas');
  @override
  late final GeneratedColumn<int> numeroTotalParcelas = GeneratedColumn<int>(
    'numero_total_parcelas',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numeroParcelasPagasMeta =
      const VerificationMeta('numeroParcelasPagas');
  @override
  late final GeneratedColumn<int> numeroParcelasPagas = GeneratedColumn<int>(
    'numero_parcelas_pagas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fundoPrincipalDestinoIdMeta =
      const VerificationMeta('fundoPrincipalDestinoId');
  @override
  late final GeneratedColumn<int> fundoPrincipalDestinoId =
      GeneratedColumn<int>(
        'fundo_principal_destino_id',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES fundos_principais (id)',
        ),
      );
  static const VerificationMeta _caixinhaDestinoIdMeta = const VerificationMeta(
    'caixinhaDestinoId',
  );
  @override
  late final GeneratedColumn<int> caixinhaDestinoId = GeneratedColumn<int>(
    'caixinha_destino_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES caixinhas (id)',
    ),
  );
  static const VerificationMeta _dataInicioCompromissoMeta =
      const VerificationMeta('dataInicioCompromisso');
  @override
  late final GeneratedColumn<DateTime> dataInicioCompromisso =
      GeneratedColumn<DateTime>(
        'data_inicio_compromisso',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dataProximoVencimentoMeta =
      const VerificationMeta('dataProximoVencimento');
  @override
  late final GeneratedColumn<DateTime> dataProximoVencimento =
      GeneratedColumn<DateTime>(
        'data_proximo_vencimento',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusCompromissoMeta = const VerificationMeta(
    'statusCompromisso',
  );
  @override
  late final GeneratedColumn<String> statusCompromisso =
      GeneratedColumn<String>(
        'status_compromisso',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('ATIVO'),
      );
  static const VerificationMeta _ajusteInflacaoAplicavelMeta =
      const VerificationMeta('ajusteInflacaoAplicavel');
  @override
  late final GeneratedColumn<bool> ajusteInflacaoAplicavel =
      GeneratedColumn<bool>(
        'ajuste_inflacao_aplicavel',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("ajuste_inflacao_aplicavel" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _dataUltimoAjusteInflacaoMeta =
      const VerificationMeta('dataUltimoAjusteInflacao');
  @override
  late final GeneratedColumn<DateTime> dataUltimoAjusteInflacao =
      GeneratedColumn<DateTime>(
        'data_ultimo_ajuste_inflacao',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    descricao,
    tipoCompromisso,
    valorTotalComprometido,
    valorParcela,
    numeroTotalParcelas,
    numeroParcelasPagas,
    fundoPrincipalDestinoId,
    caixinhaDestinoId,
    dataInicioCompromisso,
    dataProximoVencimento,
    statusCompromisso,
    ajusteInflacaoAplicavel,
    dataUltimoAjusteInflacao,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compromissos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Compromisso> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('tipo_compromisso')) {
      context.handle(
        _tipoCompromissoMeta,
        tipoCompromisso.isAcceptableOrUnknown(
          data['tipo_compromisso']!,
          _tipoCompromissoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoCompromissoMeta);
    }
    if (data.containsKey('valor_total_comprometido')) {
      context.handle(
        _valorTotalComprometidoMeta,
        valorTotalComprometido.isAcceptableOrUnknown(
          data['valor_total_comprometido']!,
          _valorTotalComprometidoMeta,
        ),
      );
    }
    if (data.containsKey('valor_parcela')) {
      context.handle(
        _valorParcelaMeta,
        valorParcela.isAcceptableOrUnknown(
          data['valor_parcela']!,
          _valorParcelaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorParcelaMeta);
    }
    if (data.containsKey('numero_total_parcelas')) {
      context.handle(
        _numeroTotalParcelasMeta,
        numeroTotalParcelas.isAcceptableOrUnknown(
          data['numero_total_parcelas']!,
          _numeroTotalParcelasMeta,
        ),
      );
    }
    if (data.containsKey('numero_parcelas_pagas')) {
      context.handle(
        _numeroParcelasPagasMeta,
        numeroParcelasPagas.isAcceptableOrUnknown(
          data['numero_parcelas_pagas']!,
          _numeroParcelasPagasMeta,
        ),
      );
    }
    if (data.containsKey('fundo_principal_destino_id')) {
      context.handle(
        _fundoPrincipalDestinoIdMeta,
        fundoPrincipalDestinoId.isAcceptableOrUnknown(
          data['fundo_principal_destino_id']!,
          _fundoPrincipalDestinoIdMeta,
        ),
      );
    }
    if (data.containsKey('caixinha_destino_id')) {
      context.handle(
        _caixinhaDestinoIdMeta,
        caixinhaDestinoId.isAcceptableOrUnknown(
          data['caixinha_destino_id']!,
          _caixinhaDestinoIdMeta,
        ),
      );
    }
    if (data.containsKey('data_inicio_compromisso')) {
      context.handle(
        _dataInicioCompromissoMeta,
        dataInicioCompromisso.isAcceptableOrUnknown(
          data['data_inicio_compromisso']!,
          _dataInicioCompromissoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataInicioCompromissoMeta);
    }
    if (data.containsKey('data_proximo_vencimento')) {
      context.handle(
        _dataProximoVencimentoMeta,
        dataProximoVencimento.isAcceptableOrUnknown(
          data['data_proximo_vencimento']!,
          _dataProximoVencimentoMeta,
        ),
      );
    }
    if (data.containsKey('status_compromisso')) {
      context.handle(
        _statusCompromissoMeta,
        statusCompromisso.isAcceptableOrUnknown(
          data['status_compromisso']!,
          _statusCompromissoMeta,
        ),
      );
    }
    if (data.containsKey('ajuste_inflacao_aplicavel')) {
      context.handle(
        _ajusteInflacaoAplicavelMeta,
        ajusteInflacaoAplicavel.isAcceptableOrUnknown(
          data['ajuste_inflacao_aplicavel']!,
          _ajusteInflacaoAplicavelMeta,
        ),
      );
    }
    if (data.containsKey('data_ultimo_ajuste_inflacao')) {
      context.handle(
        _dataUltimoAjusteInflacaoMeta,
        dataUltimoAjusteInflacao.isAcceptableOrUnknown(
          data['data_ultimo_ajuste_inflacao']!,
          _dataUltimoAjusteInflacaoMeta,
        ),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataAtualizacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Compromisso map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Compromisso(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      tipoCompromisso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_compromisso'],
      )!,
      valorTotalComprometido: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_total_comprometido'],
      ),
      valorParcela: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_parcela'],
      )!,
      numeroTotalParcelas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero_total_parcelas'],
      ),
      numeroParcelasPagas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero_parcelas_pagas'],
      )!,
      fundoPrincipalDestinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fundo_principal_destino_id'],
      ),
      caixinhaDestinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caixinha_destino_id'],
      ),
      dataInicioCompromisso: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_inicio_compromisso'],
      )!,
      dataProximoVencimento: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_proximo_vencimento'],
      ),
      statusCompromisso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_compromisso'],
      )!,
      ajusteInflacaoAplicavel: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ajuste_inflacao_aplicavel'],
      )!,
      dataUltimoAjusteInflacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_ultimo_ajuste_inflacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      )!,
    );
  }

  @override
  $CompromissosTable createAlias(String alias) {
    return $CompromissosTable(attachedDatabase, alias);
  }
}

class Compromisso extends DataClass implements Insertable<Compromisso> {
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
  final String statusCompromisso;
  final bool ajusteInflacaoAplicavel;
  final DateTime? dataUltimoAjusteInflacao;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  const Compromisso({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['descricao'] = Variable<String>(descricao);
    map['tipo_compromisso'] = Variable<String>(tipoCompromisso);
    if (!nullToAbsent || valorTotalComprometido != null) {
      map['valor_total_comprometido'] = Variable<double>(
        valorTotalComprometido,
      );
    }
    map['valor_parcela'] = Variable<double>(valorParcela);
    if (!nullToAbsent || numeroTotalParcelas != null) {
      map['numero_total_parcelas'] = Variable<int>(numeroTotalParcelas);
    }
    map['numero_parcelas_pagas'] = Variable<int>(numeroParcelasPagas);
    if (!nullToAbsent || fundoPrincipalDestinoId != null) {
      map['fundo_principal_destino_id'] = Variable<int>(
        fundoPrincipalDestinoId,
      );
    }
    if (!nullToAbsent || caixinhaDestinoId != null) {
      map['caixinha_destino_id'] = Variable<int>(caixinhaDestinoId);
    }
    map['data_inicio_compromisso'] = Variable<DateTime>(dataInicioCompromisso);
    if (!nullToAbsent || dataProximoVencimento != null) {
      map['data_proximo_vencimento'] = Variable<DateTime>(
        dataProximoVencimento,
      );
    }
    map['status_compromisso'] = Variable<String>(statusCompromisso);
    map['ajuste_inflacao_aplicavel'] = Variable<bool>(ajusteInflacaoAplicavel);
    if (!nullToAbsent || dataUltimoAjusteInflacao != null) {
      map['data_ultimo_ajuste_inflacao'] = Variable<DateTime>(
        dataUltimoAjusteInflacao,
      );
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    return map;
  }

  CompromissosCompanion toCompanion(bool nullToAbsent) {
    return CompromissosCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      descricao: Value(descricao),
      tipoCompromisso: Value(tipoCompromisso),
      valorTotalComprometido: valorTotalComprometido == null && nullToAbsent
          ? const Value.absent()
          : Value(valorTotalComprometido),
      valorParcela: Value(valorParcela),
      numeroTotalParcelas: numeroTotalParcelas == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroTotalParcelas),
      numeroParcelasPagas: Value(numeroParcelasPagas),
      fundoPrincipalDestinoId: fundoPrincipalDestinoId == null && nullToAbsent
          ? const Value.absent()
          : Value(fundoPrincipalDestinoId),
      caixinhaDestinoId: caixinhaDestinoId == null && nullToAbsent
          ? const Value.absent()
          : Value(caixinhaDestinoId),
      dataInicioCompromisso: Value(dataInicioCompromisso),
      dataProximoVencimento: dataProximoVencimento == null && nullToAbsent
          ? const Value.absent()
          : Value(dataProximoVencimento),
      statusCompromisso: Value(statusCompromisso),
      ajusteInflacaoAplicavel: Value(ajusteInflacaoAplicavel),
      dataUltimoAjusteInflacao: dataUltimoAjusteInflacao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataUltimoAjusteInflacao),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: Value(dataAtualizacao),
    );
  }

  factory Compromisso.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Compromisso(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      descricao: serializer.fromJson<String>(json['descricao']),
      tipoCompromisso: serializer.fromJson<String>(json['tipoCompromisso']),
      valorTotalComprometido: serializer.fromJson<double?>(
        json['valorTotalComprometido'],
      ),
      valorParcela: serializer.fromJson<double>(json['valorParcela']),
      numeroTotalParcelas: serializer.fromJson<int?>(
        json['numeroTotalParcelas'],
      ),
      numeroParcelasPagas: serializer.fromJson<int>(
        json['numeroParcelasPagas'],
      ),
      fundoPrincipalDestinoId: serializer.fromJson<int?>(
        json['fundoPrincipalDestinoId'],
      ),
      caixinhaDestinoId: serializer.fromJson<int?>(json['caixinhaDestinoId']),
      dataInicioCompromisso: serializer.fromJson<DateTime>(
        json['dataInicioCompromisso'],
      ),
      dataProximoVencimento: serializer.fromJson<DateTime?>(
        json['dataProximoVencimento'],
      ),
      statusCompromisso: serializer.fromJson<String>(json['statusCompromisso']),
      ajusteInflacaoAplicavel: serializer.fromJson<bool>(
        json['ajusteInflacaoAplicavel'],
      ),
      dataUltimoAjusteInflacao: serializer.fromJson<DateTime?>(
        json['dataUltimoAjusteInflacao'],
      ),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'descricao': serializer.toJson<String>(descricao),
      'tipoCompromisso': serializer.toJson<String>(tipoCompromisso),
      'valorTotalComprometido': serializer.toJson<double?>(
        valorTotalComprometido,
      ),
      'valorParcela': serializer.toJson<double>(valorParcela),
      'numeroTotalParcelas': serializer.toJson<int?>(numeroTotalParcelas),
      'numeroParcelasPagas': serializer.toJson<int>(numeroParcelasPagas),
      'fundoPrincipalDestinoId': serializer.toJson<int?>(
        fundoPrincipalDestinoId,
      ),
      'caixinhaDestinoId': serializer.toJson<int?>(caixinhaDestinoId),
      'dataInicioCompromisso': serializer.toJson<DateTime>(
        dataInicioCompromisso,
      ),
      'dataProximoVencimento': serializer.toJson<DateTime?>(
        dataProximoVencimento,
      ),
      'statusCompromisso': serializer.toJson<String>(statusCompromisso),
      'ajusteInflacaoAplicavel': serializer.toJson<bool>(
        ajusteInflacaoAplicavel,
      ),
      'dataUltimoAjusteInflacao': serializer.toJson<DateTime?>(
        dataUltimoAjusteInflacao,
      ),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime>(dataAtualizacao),
    };
  }

  Compromisso copyWith({
    int? id,
    int? usuarioId,
    String? descricao,
    String? tipoCompromisso,
    Value<double?> valorTotalComprometido = const Value.absent(),
    double? valorParcela,
    Value<int?> numeroTotalParcelas = const Value.absent(),
    int? numeroParcelasPagas,
    Value<int?> fundoPrincipalDestinoId = const Value.absent(),
    Value<int?> caixinhaDestinoId = const Value.absent(),
    DateTime? dataInicioCompromisso,
    Value<DateTime?> dataProximoVencimento = const Value.absent(),
    String? statusCompromisso,
    bool? ajusteInflacaoAplicavel,
    Value<DateTime?> dataUltimoAjusteInflacao = const Value.absent(),
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) => Compromisso(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    descricao: descricao ?? this.descricao,
    tipoCompromisso: tipoCompromisso ?? this.tipoCompromisso,
    valorTotalComprometido: valorTotalComprometido.present
        ? valorTotalComprometido.value
        : this.valorTotalComprometido,
    valorParcela: valorParcela ?? this.valorParcela,
    numeroTotalParcelas: numeroTotalParcelas.present
        ? numeroTotalParcelas.value
        : this.numeroTotalParcelas,
    numeroParcelasPagas: numeroParcelasPagas ?? this.numeroParcelasPagas,
    fundoPrincipalDestinoId: fundoPrincipalDestinoId.present
        ? fundoPrincipalDestinoId.value
        : this.fundoPrincipalDestinoId,
    caixinhaDestinoId: caixinhaDestinoId.present
        ? caixinhaDestinoId.value
        : this.caixinhaDestinoId,
    dataInicioCompromisso: dataInicioCompromisso ?? this.dataInicioCompromisso,
    dataProximoVencimento: dataProximoVencimento.present
        ? dataProximoVencimento.value
        : this.dataProximoVencimento,
    statusCompromisso: statusCompromisso ?? this.statusCompromisso,
    ajusteInflacaoAplicavel:
        ajusteInflacaoAplicavel ?? this.ajusteInflacaoAplicavel,
    dataUltimoAjusteInflacao: dataUltimoAjusteInflacao.present
        ? dataUltimoAjusteInflacao.value
        : this.dataUltimoAjusteInflacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
  );
  Compromisso copyWithCompanion(CompromissosCompanion data) {
    return Compromisso(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      tipoCompromisso: data.tipoCompromisso.present
          ? data.tipoCompromisso.value
          : this.tipoCompromisso,
      valorTotalComprometido: data.valorTotalComprometido.present
          ? data.valorTotalComprometido.value
          : this.valorTotalComprometido,
      valorParcela: data.valorParcela.present
          ? data.valorParcela.value
          : this.valorParcela,
      numeroTotalParcelas: data.numeroTotalParcelas.present
          ? data.numeroTotalParcelas.value
          : this.numeroTotalParcelas,
      numeroParcelasPagas: data.numeroParcelasPagas.present
          ? data.numeroParcelasPagas.value
          : this.numeroParcelasPagas,
      fundoPrincipalDestinoId: data.fundoPrincipalDestinoId.present
          ? data.fundoPrincipalDestinoId.value
          : this.fundoPrincipalDestinoId,
      caixinhaDestinoId: data.caixinhaDestinoId.present
          ? data.caixinhaDestinoId.value
          : this.caixinhaDestinoId,
      dataInicioCompromisso: data.dataInicioCompromisso.present
          ? data.dataInicioCompromisso.value
          : this.dataInicioCompromisso,
      dataProximoVencimento: data.dataProximoVencimento.present
          ? data.dataProximoVencimento.value
          : this.dataProximoVencimento,
      statusCompromisso: data.statusCompromisso.present
          ? data.statusCompromisso.value
          : this.statusCompromisso,
      ajusteInflacaoAplicavel: data.ajusteInflacaoAplicavel.present
          ? data.ajusteInflacaoAplicavel.value
          : this.ajusteInflacaoAplicavel,
      dataUltimoAjusteInflacao: data.dataUltimoAjusteInflacao.present
          ? data.dataUltimoAjusteInflacao.value
          : this.dataUltimoAjusteInflacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Compromisso(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('descricao: $descricao, ')
          ..write('tipoCompromisso: $tipoCompromisso, ')
          ..write('valorTotalComprometido: $valorTotalComprometido, ')
          ..write('valorParcela: $valorParcela, ')
          ..write('numeroTotalParcelas: $numeroTotalParcelas, ')
          ..write('numeroParcelasPagas: $numeroParcelasPagas, ')
          ..write('fundoPrincipalDestinoId: $fundoPrincipalDestinoId, ')
          ..write('caixinhaDestinoId: $caixinhaDestinoId, ')
          ..write('dataInicioCompromisso: $dataInicioCompromisso, ')
          ..write('dataProximoVencimento: $dataProximoVencimento, ')
          ..write('statusCompromisso: $statusCompromisso, ')
          ..write('ajusteInflacaoAplicavel: $ajusteInflacaoAplicavel, ')
          ..write('dataUltimoAjusteInflacao: $dataUltimoAjusteInflacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    descricao,
    tipoCompromisso,
    valorTotalComprometido,
    valorParcela,
    numeroTotalParcelas,
    numeroParcelasPagas,
    fundoPrincipalDestinoId,
    caixinhaDestinoId,
    dataInicioCompromisso,
    dataProximoVencimento,
    statusCompromisso,
    ajusteInflacaoAplicavel,
    dataUltimoAjusteInflacao,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Compromisso &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.descricao == this.descricao &&
          other.tipoCompromisso == this.tipoCompromisso &&
          other.valorTotalComprometido == this.valorTotalComprometido &&
          other.valorParcela == this.valorParcela &&
          other.numeroTotalParcelas == this.numeroTotalParcelas &&
          other.numeroParcelasPagas == this.numeroParcelasPagas &&
          other.fundoPrincipalDestinoId == this.fundoPrincipalDestinoId &&
          other.caixinhaDestinoId == this.caixinhaDestinoId &&
          other.dataInicioCompromisso == this.dataInicioCompromisso &&
          other.dataProximoVencimento == this.dataProximoVencimento &&
          other.statusCompromisso == this.statusCompromisso &&
          other.ajusteInflacaoAplicavel == this.ajusteInflacaoAplicavel &&
          other.dataUltimoAjusteInflacao == this.dataUltimoAjusteInflacao &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class CompromissosCompanion extends UpdateCompanion<Compromisso> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<String> descricao;
  final Value<String> tipoCompromisso;
  final Value<double?> valorTotalComprometido;
  final Value<double> valorParcela;
  final Value<int?> numeroTotalParcelas;
  final Value<int> numeroParcelasPagas;
  final Value<int?> fundoPrincipalDestinoId;
  final Value<int?> caixinhaDestinoId;
  final Value<DateTime> dataInicioCompromisso;
  final Value<DateTime?> dataProximoVencimento;
  final Value<String> statusCompromisso;
  final Value<bool> ajusteInflacaoAplicavel;
  final Value<DateTime?> dataUltimoAjusteInflacao;
  final Value<DateTime> dataCriacao;
  final Value<DateTime> dataAtualizacao;
  const CompromissosCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.descricao = const Value.absent(),
    this.tipoCompromisso = const Value.absent(),
    this.valorTotalComprometido = const Value.absent(),
    this.valorParcela = const Value.absent(),
    this.numeroTotalParcelas = const Value.absent(),
    this.numeroParcelasPagas = const Value.absent(),
    this.fundoPrincipalDestinoId = const Value.absent(),
    this.caixinhaDestinoId = const Value.absent(),
    this.dataInicioCompromisso = const Value.absent(),
    this.dataProximoVencimento = const Value.absent(),
    this.statusCompromisso = const Value.absent(),
    this.ajusteInflacaoAplicavel = const Value.absent(),
    this.dataUltimoAjusteInflacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  CompromissosCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    required String descricao,
    required String tipoCompromisso,
    this.valorTotalComprometido = const Value.absent(),
    required double valorParcela,
    this.numeroTotalParcelas = const Value.absent(),
    this.numeroParcelasPagas = const Value.absent(),
    this.fundoPrincipalDestinoId = const Value.absent(),
    this.caixinhaDestinoId = const Value.absent(),
    required DateTime dataInicioCompromisso,
    this.dataProximoVencimento = const Value.absent(),
    this.statusCompromisso = const Value.absent(),
    this.ajusteInflacaoAplicavel = const Value.absent(),
    this.dataUltimoAjusteInflacao = const Value.absent(),
    required DateTime dataCriacao,
    required DateTime dataAtualizacao,
  }) : usuarioId = Value(usuarioId),
       descricao = Value(descricao),
       tipoCompromisso = Value(tipoCompromisso),
       valorParcela = Value(valorParcela),
       dataInicioCompromisso = Value(dataInicioCompromisso),
       dataCriacao = Value(dataCriacao),
       dataAtualizacao = Value(dataAtualizacao);
  static Insertable<Compromisso> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<String>? descricao,
    Expression<String>? tipoCompromisso,
    Expression<double>? valorTotalComprometido,
    Expression<double>? valorParcela,
    Expression<int>? numeroTotalParcelas,
    Expression<int>? numeroParcelasPagas,
    Expression<int>? fundoPrincipalDestinoId,
    Expression<int>? caixinhaDestinoId,
    Expression<DateTime>? dataInicioCompromisso,
    Expression<DateTime>? dataProximoVencimento,
    Expression<String>? statusCompromisso,
    Expression<bool>? ajusteInflacaoAplicavel,
    Expression<DateTime>? dataUltimoAjusteInflacao,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (descricao != null) 'descricao': descricao,
      if (tipoCompromisso != null) 'tipo_compromisso': tipoCompromisso,
      if (valorTotalComprometido != null)
        'valor_total_comprometido': valorTotalComprometido,
      if (valorParcela != null) 'valor_parcela': valorParcela,
      if (numeroTotalParcelas != null)
        'numero_total_parcelas': numeroTotalParcelas,
      if (numeroParcelasPagas != null)
        'numero_parcelas_pagas': numeroParcelasPagas,
      if (fundoPrincipalDestinoId != null)
        'fundo_principal_destino_id': fundoPrincipalDestinoId,
      if (caixinhaDestinoId != null) 'caixinha_destino_id': caixinhaDestinoId,
      if (dataInicioCompromisso != null)
        'data_inicio_compromisso': dataInicioCompromisso,
      if (dataProximoVencimento != null)
        'data_proximo_vencimento': dataProximoVencimento,
      if (statusCompromisso != null) 'status_compromisso': statusCompromisso,
      if (ajusteInflacaoAplicavel != null)
        'ajuste_inflacao_aplicavel': ajusteInflacaoAplicavel,
      if (dataUltimoAjusteInflacao != null)
        'data_ultimo_ajuste_inflacao': dataUltimoAjusteInflacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  CompromissosCompanion copyWith({
    Value<int>? id,
    Value<int>? usuarioId,
    Value<String>? descricao,
    Value<String>? tipoCompromisso,
    Value<double?>? valorTotalComprometido,
    Value<double>? valorParcela,
    Value<int?>? numeroTotalParcelas,
    Value<int>? numeroParcelasPagas,
    Value<int?>? fundoPrincipalDestinoId,
    Value<int?>? caixinhaDestinoId,
    Value<DateTime>? dataInicioCompromisso,
    Value<DateTime?>? dataProximoVencimento,
    Value<String>? statusCompromisso,
    Value<bool>? ajusteInflacaoAplicavel,
    Value<DateTime?>? dataUltimoAjusteInflacao,
    Value<DateTime>? dataCriacao,
    Value<DateTime>? dataAtualizacao,
  }) {
    return CompromissosCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      descricao: descricao ?? this.descricao,
      tipoCompromisso: tipoCompromisso ?? this.tipoCompromisso,
      valorTotalComprometido:
          valorTotalComprometido ?? this.valorTotalComprometido,
      valorParcela: valorParcela ?? this.valorParcela,
      numeroTotalParcelas: numeroTotalParcelas ?? this.numeroTotalParcelas,
      numeroParcelasPagas: numeroParcelasPagas ?? this.numeroParcelasPagas,
      fundoPrincipalDestinoId:
          fundoPrincipalDestinoId ?? this.fundoPrincipalDestinoId,
      caixinhaDestinoId: caixinhaDestinoId ?? this.caixinhaDestinoId,
      dataInicioCompromisso:
          dataInicioCompromisso ?? this.dataInicioCompromisso,
      dataProximoVencimento:
          dataProximoVencimento ?? this.dataProximoVencimento,
      statusCompromisso: statusCompromisso ?? this.statusCompromisso,
      ajusteInflacaoAplicavel:
          ajusteInflacaoAplicavel ?? this.ajusteInflacaoAplicavel,
      dataUltimoAjusteInflacao:
          dataUltimoAjusteInflacao ?? this.dataUltimoAjusteInflacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (tipoCompromisso.present) {
      map['tipo_compromisso'] = Variable<String>(tipoCompromisso.value);
    }
    if (valorTotalComprometido.present) {
      map['valor_total_comprometido'] = Variable<double>(
        valorTotalComprometido.value,
      );
    }
    if (valorParcela.present) {
      map['valor_parcela'] = Variable<double>(valorParcela.value);
    }
    if (numeroTotalParcelas.present) {
      map['numero_total_parcelas'] = Variable<int>(numeroTotalParcelas.value);
    }
    if (numeroParcelasPagas.present) {
      map['numero_parcelas_pagas'] = Variable<int>(numeroParcelasPagas.value);
    }
    if (fundoPrincipalDestinoId.present) {
      map['fundo_principal_destino_id'] = Variable<int>(
        fundoPrincipalDestinoId.value,
      );
    }
    if (caixinhaDestinoId.present) {
      map['caixinha_destino_id'] = Variable<int>(caixinhaDestinoId.value);
    }
    if (dataInicioCompromisso.present) {
      map['data_inicio_compromisso'] = Variable<DateTime>(
        dataInicioCompromisso.value,
      );
    }
    if (dataProximoVencimento.present) {
      map['data_proximo_vencimento'] = Variable<DateTime>(
        dataProximoVencimento.value,
      );
    }
    if (statusCompromisso.present) {
      map['status_compromisso'] = Variable<String>(statusCompromisso.value);
    }
    if (ajusteInflacaoAplicavel.present) {
      map['ajuste_inflacao_aplicavel'] = Variable<bool>(
        ajusteInflacaoAplicavel.value,
      );
    }
    if (dataUltimoAjusteInflacao.present) {
      map['data_ultimo_ajuste_inflacao'] = Variable<DateTime>(
        dataUltimoAjusteInflacao.value,
      );
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompromissosCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('descricao: $descricao, ')
          ..write('tipoCompromisso: $tipoCompromisso, ')
          ..write('valorTotalComprometido: $valorTotalComprometido, ')
          ..write('valorParcela: $valorParcela, ')
          ..write('numeroTotalParcelas: $numeroTotalParcelas, ')
          ..write('numeroParcelasPagas: $numeroParcelasPagas, ')
          ..write('fundoPrincipalDestinoId: $fundoPrincipalDestinoId, ')
          ..write('caixinhaDestinoId: $caixinhaDestinoId, ')
          ..write('dataInicioCompromisso: $dataInicioCompromisso, ')
          ..write('dataProximoVencimento: $dataProximoVencimento, ')
          ..write('statusCompromisso: $statusCompromisso, ')
          ..write('ajusteInflacaoAplicavel: $ajusteInflacaoAplicavel, ')
          ..write('dataUltimoAjusteInflacao: $dataUltimoAjusteInflacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $TransacoesTable extends Transacoes
    with TableInfo<$TransacoesTable, Transacoe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransacoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataTransacaoMeta = const VerificationMeta(
    'dataTransacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataTransacao =
      GeneratedColumn<DateTime>(
        'data_transacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoTransacaoMeta = const VerificationMeta(
    'tipoTransacao',
  );
  @override
  late final GeneratedColumn<String> tipoTransacao = GeneratedColumn<String>(
    'tipo_transacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fundoPrincipalOrigemIdMeta =
      const VerificationMeta('fundoPrincipalOrigemId');
  @override
  late final GeneratedColumn<int> fundoPrincipalOrigemId = GeneratedColumn<int>(
    'fundo_principal_origem_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES fundos_principais (id)',
    ),
  );
  static const VerificationMeta _caixinhaOrigemIdMeta = const VerificationMeta(
    'caixinhaOrigemId',
  );
  @override
  late final GeneratedColumn<int> caixinhaOrigemId = GeneratedColumn<int>(
    'caixinha_origem_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES caixinhas (id)',
    ),
  );
  static const VerificationMeta _fundoPrincipalDestinoIdMeta =
      const VerificationMeta('fundoPrincipalDestinoId');
  @override
  late final GeneratedColumn<int> fundoPrincipalDestinoId =
      GeneratedColumn<int>(
        'fundo_principal_destino_id',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES fundos_principais (id)',
        ),
      );
  static const VerificationMeta _caixinhaDestinoIdMeta = const VerificationMeta(
    'caixinhaDestinoId',
  );
  @override
  late final GeneratedColumn<int> caixinhaDestinoId = GeneratedColumn<int>(
    'caixinha_destino_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES caixinhas (id)',
    ),
  );
  static const VerificationMeta _emprestimoIdMeta = const VerificationMeta(
    'emprestimoId',
  );
  @override
  late final GeneratedColumn<int> emprestimoId = GeneratedColumn<int>(
    'emprestimo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES emprestimos (id)',
    ),
  );
  static const VerificationMeta _compromissoIdMeta = const VerificationMeta(
    'compromissoId',
  );
  @override
  late final GeneratedColumn<int> compromissoId = GeneratedColumn<int>(
    'compromisso_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES compromissos (id)',
    ),
  );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    valor,
    dataTransacao,
    descricao,
    tipoTransacao,
    fundoPrincipalOrigemId,
    caixinhaOrigemId,
    fundoPrincipalDestinoId,
    caixinhaDestinoId,
    emprestimoId,
    compromissoId,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transacoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transacoe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('data_transacao')) {
      context.handle(
        _dataTransacaoMeta,
        dataTransacao.isAcceptableOrUnknown(
          data['data_transacao']!,
          _dataTransacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataTransacaoMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('tipo_transacao')) {
      context.handle(
        _tipoTransacaoMeta,
        tipoTransacao.isAcceptableOrUnknown(
          data['tipo_transacao']!,
          _tipoTransacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoTransacaoMeta);
    }
    if (data.containsKey('fundo_principal_origem_id')) {
      context.handle(
        _fundoPrincipalOrigemIdMeta,
        fundoPrincipalOrigemId.isAcceptableOrUnknown(
          data['fundo_principal_origem_id']!,
          _fundoPrincipalOrigemIdMeta,
        ),
      );
    }
    if (data.containsKey('caixinha_origem_id')) {
      context.handle(
        _caixinhaOrigemIdMeta,
        caixinhaOrigemId.isAcceptableOrUnknown(
          data['caixinha_origem_id']!,
          _caixinhaOrigemIdMeta,
        ),
      );
    }
    if (data.containsKey('fundo_principal_destino_id')) {
      context.handle(
        _fundoPrincipalDestinoIdMeta,
        fundoPrincipalDestinoId.isAcceptableOrUnknown(
          data['fundo_principal_destino_id']!,
          _fundoPrincipalDestinoIdMeta,
        ),
      );
    }
    if (data.containsKey('caixinha_destino_id')) {
      context.handle(
        _caixinhaDestinoIdMeta,
        caixinhaDestinoId.isAcceptableOrUnknown(
          data['caixinha_destino_id']!,
          _caixinhaDestinoIdMeta,
        ),
      );
    }
    if (data.containsKey('emprestimo_id')) {
      context.handle(
        _emprestimoIdMeta,
        emprestimoId.isAcceptableOrUnknown(
          data['emprestimo_id']!,
          _emprestimoIdMeta,
        ),
      );
    }
    if (data.containsKey('compromisso_id')) {
      context.handle(
        _compromissoIdMeta,
        compromissoId.isAcceptableOrUnknown(
          data['compromisso_id']!,
          _compromissoIdMeta,
        ),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataAtualizacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transacoe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transacoe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      )!,
      dataTransacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_transacao'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      tipoTransacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_transacao'],
      )!,
      fundoPrincipalOrigemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fundo_principal_origem_id'],
      ),
      caixinhaOrigemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caixinha_origem_id'],
      ),
      fundoPrincipalDestinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fundo_principal_destino_id'],
      ),
      caixinhaDestinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caixinha_destino_id'],
      ),
      emprestimoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}emprestimo_id'],
      ),
      compromissoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}compromisso_id'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      )!,
    );
  }

  @override
  $TransacoesTable createAlias(String alias) {
    return $TransacoesTable(attachedDatabase, alias);
  }
}

class Transacoe extends DataClass implements Insertable<Transacoe> {
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
  const Transacoe({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['valor'] = Variable<double>(valor);
    map['data_transacao'] = Variable<DateTime>(dataTransacao);
    map['descricao'] = Variable<String>(descricao);
    map['tipo_transacao'] = Variable<String>(tipoTransacao);
    if (!nullToAbsent || fundoPrincipalOrigemId != null) {
      map['fundo_principal_origem_id'] = Variable<int>(fundoPrincipalOrigemId);
    }
    if (!nullToAbsent || caixinhaOrigemId != null) {
      map['caixinha_origem_id'] = Variable<int>(caixinhaOrigemId);
    }
    if (!nullToAbsent || fundoPrincipalDestinoId != null) {
      map['fundo_principal_destino_id'] = Variable<int>(
        fundoPrincipalDestinoId,
      );
    }
    if (!nullToAbsent || caixinhaDestinoId != null) {
      map['caixinha_destino_id'] = Variable<int>(caixinhaDestinoId);
    }
    if (!nullToAbsent || emprestimoId != null) {
      map['emprestimo_id'] = Variable<int>(emprestimoId);
    }
    if (!nullToAbsent || compromissoId != null) {
      map['compromisso_id'] = Variable<int>(compromissoId);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    return map;
  }

  TransacoesCompanion toCompanion(bool nullToAbsent) {
    return TransacoesCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      valor: Value(valor),
      dataTransacao: Value(dataTransacao),
      descricao: Value(descricao),
      tipoTransacao: Value(tipoTransacao),
      fundoPrincipalOrigemId: fundoPrincipalOrigemId == null && nullToAbsent
          ? const Value.absent()
          : Value(fundoPrincipalOrigemId),
      caixinhaOrigemId: caixinhaOrigemId == null && nullToAbsent
          ? const Value.absent()
          : Value(caixinhaOrigemId),
      fundoPrincipalDestinoId: fundoPrincipalDestinoId == null && nullToAbsent
          ? const Value.absent()
          : Value(fundoPrincipalDestinoId),
      caixinhaDestinoId: caixinhaDestinoId == null && nullToAbsent
          ? const Value.absent()
          : Value(caixinhaDestinoId),
      emprestimoId: emprestimoId == null && nullToAbsent
          ? const Value.absent()
          : Value(emprestimoId),
      compromissoId: compromissoId == null && nullToAbsent
          ? const Value.absent()
          : Value(compromissoId),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: Value(dataAtualizacao),
    );
  }

  factory Transacoe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transacoe(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      valor: serializer.fromJson<double>(json['valor']),
      dataTransacao: serializer.fromJson<DateTime>(json['dataTransacao']),
      descricao: serializer.fromJson<String>(json['descricao']),
      tipoTransacao: serializer.fromJson<String>(json['tipoTransacao']),
      fundoPrincipalOrigemId: serializer.fromJson<int?>(
        json['fundoPrincipalOrigemId'],
      ),
      caixinhaOrigemId: serializer.fromJson<int?>(json['caixinhaOrigemId']),
      fundoPrincipalDestinoId: serializer.fromJson<int?>(
        json['fundoPrincipalDestinoId'],
      ),
      caixinhaDestinoId: serializer.fromJson<int?>(json['caixinhaDestinoId']),
      emprestimoId: serializer.fromJson<int?>(json['emprestimoId']),
      compromissoId: serializer.fromJson<int?>(json['compromissoId']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'valor': serializer.toJson<double>(valor),
      'dataTransacao': serializer.toJson<DateTime>(dataTransacao),
      'descricao': serializer.toJson<String>(descricao),
      'tipoTransacao': serializer.toJson<String>(tipoTransacao),
      'fundoPrincipalOrigemId': serializer.toJson<int?>(fundoPrincipalOrigemId),
      'caixinhaOrigemId': serializer.toJson<int?>(caixinhaOrigemId),
      'fundoPrincipalDestinoId': serializer.toJson<int?>(
        fundoPrincipalDestinoId,
      ),
      'caixinhaDestinoId': serializer.toJson<int?>(caixinhaDestinoId),
      'emprestimoId': serializer.toJson<int?>(emprestimoId),
      'compromissoId': serializer.toJson<int?>(compromissoId),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime>(dataAtualizacao),
    };
  }

  Transacoe copyWith({
    int? id,
    int? usuarioId,
    double? valor,
    DateTime? dataTransacao,
    String? descricao,
    String? tipoTransacao,
    Value<int?> fundoPrincipalOrigemId = const Value.absent(),
    Value<int?> caixinhaOrigemId = const Value.absent(),
    Value<int?> fundoPrincipalDestinoId = const Value.absent(),
    Value<int?> caixinhaDestinoId = const Value.absent(),
    Value<int?> emprestimoId = const Value.absent(),
    Value<int?> compromissoId = const Value.absent(),
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) => Transacoe(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    valor: valor ?? this.valor,
    dataTransacao: dataTransacao ?? this.dataTransacao,
    descricao: descricao ?? this.descricao,
    tipoTransacao: tipoTransacao ?? this.tipoTransacao,
    fundoPrincipalOrigemId: fundoPrincipalOrigemId.present
        ? fundoPrincipalOrigemId.value
        : this.fundoPrincipalOrigemId,
    caixinhaOrigemId: caixinhaOrigemId.present
        ? caixinhaOrigemId.value
        : this.caixinhaOrigemId,
    fundoPrincipalDestinoId: fundoPrincipalDestinoId.present
        ? fundoPrincipalDestinoId.value
        : this.fundoPrincipalDestinoId,
    caixinhaDestinoId: caixinhaDestinoId.present
        ? caixinhaDestinoId.value
        : this.caixinhaDestinoId,
    emprestimoId: emprestimoId.present ? emprestimoId.value : this.emprestimoId,
    compromissoId: compromissoId.present
        ? compromissoId.value
        : this.compromissoId,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
  );
  Transacoe copyWithCompanion(TransacoesCompanion data) {
    return Transacoe(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      valor: data.valor.present ? data.valor.value : this.valor,
      dataTransacao: data.dataTransacao.present
          ? data.dataTransacao.value
          : this.dataTransacao,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      tipoTransacao: data.tipoTransacao.present
          ? data.tipoTransacao.value
          : this.tipoTransacao,
      fundoPrincipalOrigemId: data.fundoPrincipalOrigemId.present
          ? data.fundoPrincipalOrigemId.value
          : this.fundoPrincipalOrigemId,
      caixinhaOrigemId: data.caixinhaOrigemId.present
          ? data.caixinhaOrigemId.value
          : this.caixinhaOrigemId,
      fundoPrincipalDestinoId: data.fundoPrincipalDestinoId.present
          ? data.fundoPrincipalDestinoId.value
          : this.fundoPrincipalDestinoId,
      caixinhaDestinoId: data.caixinhaDestinoId.present
          ? data.caixinhaDestinoId.value
          : this.caixinhaDestinoId,
      emprestimoId: data.emprestimoId.present
          ? data.emprestimoId.value
          : this.emprestimoId,
      compromissoId: data.compromissoId.present
          ? data.compromissoId.value
          : this.compromissoId,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transacoe(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('valor: $valor, ')
          ..write('dataTransacao: $dataTransacao, ')
          ..write('descricao: $descricao, ')
          ..write('tipoTransacao: $tipoTransacao, ')
          ..write('fundoPrincipalOrigemId: $fundoPrincipalOrigemId, ')
          ..write('caixinhaOrigemId: $caixinhaOrigemId, ')
          ..write('fundoPrincipalDestinoId: $fundoPrincipalDestinoId, ')
          ..write('caixinhaDestinoId: $caixinhaDestinoId, ')
          ..write('emprestimoId: $emprestimoId, ')
          ..write('compromissoId: $compromissoId, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    valor,
    dataTransacao,
    descricao,
    tipoTransacao,
    fundoPrincipalOrigemId,
    caixinhaOrigemId,
    fundoPrincipalDestinoId,
    caixinhaDestinoId,
    emprestimoId,
    compromissoId,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transacoe &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.valor == this.valor &&
          other.dataTransacao == this.dataTransacao &&
          other.descricao == this.descricao &&
          other.tipoTransacao == this.tipoTransacao &&
          other.fundoPrincipalOrigemId == this.fundoPrincipalOrigemId &&
          other.caixinhaOrigemId == this.caixinhaOrigemId &&
          other.fundoPrincipalDestinoId == this.fundoPrincipalDestinoId &&
          other.caixinhaDestinoId == this.caixinhaDestinoId &&
          other.emprestimoId == this.emprestimoId &&
          other.compromissoId == this.compromissoId &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class TransacoesCompanion extends UpdateCompanion<Transacoe> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<double> valor;
  final Value<DateTime> dataTransacao;
  final Value<String> descricao;
  final Value<String> tipoTransacao;
  final Value<int?> fundoPrincipalOrigemId;
  final Value<int?> caixinhaOrigemId;
  final Value<int?> fundoPrincipalDestinoId;
  final Value<int?> caixinhaDestinoId;
  final Value<int?> emprestimoId;
  final Value<int?> compromissoId;
  final Value<DateTime> dataCriacao;
  final Value<DateTime> dataAtualizacao;
  const TransacoesCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.valor = const Value.absent(),
    this.dataTransacao = const Value.absent(),
    this.descricao = const Value.absent(),
    this.tipoTransacao = const Value.absent(),
    this.fundoPrincipalOrigemId = const Value.absent(),
    this.caixinhaOrigemId = const Value.absent(),
    this.fundoPrincipalDestinoId = const Value.absent(),
    this.caixinhaDestinoId = const Value.absent(),
    this.emprestimoId = const Value.absent(),
    this.compromissoId = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  TransacoesCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    required double valor,
    required DateTime dataTransacao,
    required String descricao,
    required String tipoTransacao,
    this.fundoPrincipalOrigemId = const Value.absent(),
    this.caixinhaOrigemId = const Value.absent(),
    this.fundoPrincipalDestinoId = const Value.absent(),
    this.caixinhaDestinoId = const Value.absent(),
    this.emprestimoId = const Value.absent(),
    this.compromissoId = const Value.absent(),
    required DateTime dataCriacao,
    required DateTime dataAtualizacao,
  }) : usuarioId = Value(usuarioId),
       valor = Value(valor),
       dataTransacao = Value(dataTransacao),
       descricao = Value(descricao),
       tipoTransacao = Value(tipoTransacao),
       dataCriacao = Value(dataCriacao),
       dataAtualizacao = Value(dataAtualizacao);
  static Insertable<Transacoe> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<double>? valor,
    Expression<DateTime>? dataTransacao,
    Expression<String>? descricao,
    Expression<String>? tipoTransacao,
    Expression<int>? fundoPrincipalOrigemId,
    Expression<int>? caixinhaOrigemId,
    Expression<int>? fundoPrincipalDestinoId,
    Expression<int>? caixinhaDestinoId,
    Expression<int>? emprestimoId,
    Expression<int>? compromissoId,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (valor != null) 'valor': valor,
      if (dataTransacao != null) 'data_transacao': dataTransacao,
      if (descricao != null) 'descricao': descricao,
      if (tipoTransacao != null) 'tipo_transacao': tipoTransacao,
      if (fundoPrincipalOrigemId != null)
        'fundo_principal_origem_id': fundoPrincipalOrigemId,
      if (caixinhaOrigemId != null) 'caixinha_origem_id': caixinhaOrigemId,
      if (fundoPrincipalDestinoId != null)
        'fundo_principal_destino_id': fundoPrincipalDestinoId,
      if (caixinhaDestinoId != null) 'caixinha_destino_id': caixinhaDestinoId,
      if (emprestimoId != null) 'emprestimo_id': emprestimoId,
      if (compromissoId != null) 'compromisso_id': compromissoId,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  TransacoesCompanion copyWith({
    Value<int>? id,
    Value<int>? usuarioId,
    Value<double>? valor,
    Value<DateTime>? dataTransacao,
    Value<String>? descricao,
    Value<String>? tipoTransacao,
    Value<int?>? fundoPrincipalOrigemId,
    Value<int?>? caixinhaOrigemId,
    Value<int?>? fundoPrincipalDestinoId,
    Value<int?>? caixinhaDestinoId,
    Value<int?>? emprestimoId,
    Value<int?>? compromissoId,
    Value<DateTime>? dataCriacao,
    Value<DateTime>? dataAtualizacao,
  }) {
    return TransacoesCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      valor: valor ?? this.valor,
      dataTransacao: dataTransacao ?? this.dataTransacao,
      descricao: descricao ?? this.descricao,
      tipoTransacao: tipoTransacao ?? this.tipoTransacao,
      fundoPrincipalOrigemId:
          fundoPrincipalOrigemId ?? this.fundoPrincipalOrigemId,
      caixinhaOrigemId: caixinhaOrigemId ?? this.caixinhaOrigemId,
      fundoPrincipalDestinoId:
          fundoPrincipalDestinoId ?? this.fundoPrincipalDestinoId,
      caixinhaDestinoId: caixinhaDestinoId ?? this.caixinhaDestinoId,
      emprestimoId: emprestimoId ?? this.emprestimoId,
      compromissoId: compromissoId ?? this.compromissoId,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (dataTransacao.present) {
      map['data_transacao'] = Variable<DateTime>(dataTransacao.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (tipoTransacao.present) {
      map['tipo_transacao'] = Variable<String>(tipoTransacao.value);
    }
    if (fundoPrincipalOrigemId.present) {
      map['fundo_principal_origem_id'] = Variable<int>(
        fundoPrincipalOrigemId.value,
      );
    }
    if (caixinhaOrigemId.present) {
      map['caixinha_origem_id'] = Variable<int>(caixinhaOrigemId.value);
    }
    if (fundoPrincipalDestinoId.present) {
      map['fundo_principal_destino_id'] = Variable<int>(
        fundoPrincipalDestinoId.value,
      );
    }
    if (caixinhaDestinoId.present) {
      map['caixinha_destino_id'] = Variable<int>(caixinhaDestinoId.value);
    }
    if (emprestimoId.present) {
      map['emprestimo_id'] = Variable<int>(emprestimoId.value);
    }
    if (compromissoId.present) {
      map['compromisso_id'] = Variable<int>(compromissoId.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransacoesCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('valor: $valor, ')
          ..write('dataTransacao: $dataTransacao, ')
          ..write('descricao: $descricao, ')
          ..write('tipoTransacao: $tipoTransacao, ')
          ..write('fundoPrincipalOrigemId: $fundoPrincipalOrigemId, ')
          ..write('caixinhaOrigemId: $caixinhaOrigemId, ')
          ..write('fundoPrincipalDestinoId: $fundoPrincipalDestinoId, ')
          ..write('caixinhaDestinoId: $caixinhaDestinoId, ')
          ..write('emprestimoId: $emprestimoId, ')
          ..write('compromissoId: $compromissoId, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $FundosPrincipaisTable fundosPrincipais = $FundosPrincipaisTable(
    this,
  );
  late final $CaixinhasTable caixinhas = $CaixinhasTable(this);
  late final $EmprestimosTable emprestimos = $EmprestimosTable(this);
  late final $CompromissosTable compromissos = $CompromissosTable(this);
  late final $TransacoesTable transacoes = $TransacoesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usuarios,
    fundosPrincipais,
    caixinhas,
    emprestimos,
    compromissos,
    transacoes,
  ];
}

typedef $$UsuariosTableCreateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      Value<String?> userCloudId,
      Value<String> nome,
      required double unidadePagamento,
      required int diaRevisaoMensal,
      Value<bool> inflacaoAplicarFerEmprestimos,
      Value<bool> inflacaoAplicarFerFacilitadores,
      Value<bool> inflacaoAplicarMspDepositos,
      required DateTime dataCriacao,
      required DateTime dataAtualizacao,
    });
typedef $$UsuariosTableUpdateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      Value<String?> userCloudId,
      Value<String> nome,
      Value<double> unidadePagamento,
      Value<int> diaRevisaoMensal,
      Value<bool> inflacaoAplicarFerEmprestimos,
      Value<bool> inflacaoAplicarFerFacilitadores,
      Value<bool> inflacaoAplicarMspDepositos,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
    });

final class $$UsuariosTableReferences
    extends BaseReferences<_$AppDatabase, $UsuariosTable, Usuario> {
  $$UsuariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FundosPrincipaisTable, List<FundosPrincipai>>
  _fundosPrincipaisRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fundosPrincipais,
    aliasName: $_aliasNameGenerator(
      db.usuarios.id,
      db.fundosPrincipais.usuarioId,
    ),
  );

  $$FundosPrincipaisTableProcessedTableManager get fundosPrincipaisRefs {
    final manager = $$FundosPrincipaisTableTableManager(
      $_db,
      $_db.fundosPrincipais,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _fundosPrincipaisRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CaixinhasTable, List<Caixinha>>
  _caixinhasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.caixinhas,
    aliasName: $_aliasNameGenerator(db.usuarios.id, db.caixinhas.usuarioId),
  );

  $$CaixinhasTableProcessedTableManager get caixinhasRefs {
    final manager = $$CaixinhasTableTableManager(
      $_db,
      $_db.caixinhas,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_caixinhasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EmprestimosTable, List<Emprestimo>>
  _emprestimosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emprestimos,
    aliasName: $_aliasNameGenerator(db.usuarios.id, db.emprestimos.usuarioId),
  );

  $$EmprestimosTableProcessedTableManager get emprestimosRefs {
    final manager = $$EmprestimosTableTableManager(
      $_db,
      $_db.emprestimos,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_emprestimosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CompromissosTable, List<Compromisso>>
  _compromissosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.compromissos,
    aliasName: $_aliasNameGenerator(db.usuarios.id, db.compromissos.usuarioId),
  );

  $$CompromissosTableProcessedTableManager get compromissosRefs {
    final manager = $$CompromissosTableTableManager(
      $_db,
      $_db.compromissos,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_compromissosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransacoesTable, List<Transacoe>>
  _transacoesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transacoes,
    aliasName: $_aliasNameGenerator(db.usuarios.id, db.transacoes.usuarioId),
  );

  $$TransacoesTableProcessedTableManager get transacoesRefs {
    final manager = $$TransacoesTableTableManager(
      $_db,
      $_db.transacoes,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transacoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userCloudId => $composableBuilder(
    column: $table.userCloudId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unidadePagamento => $composableBuilder(
    column: $table.unidadePagamento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaRevisaoMensal => $composableBuilder(
    column: $table.diaRevisaoMensal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inflacaoAplicarFerEmprestimos => $composableBuilder(
    column: $table.inflacaoAplicarFerEmprestimos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inflacaoAplicarFerFacilitadores => $composableBuilder(
    column: $table.inflacaoAplicarFerFacilitadores,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inflacaoAplicarMspDepositos => $composableBuilder(
    column: $table.inflacaoAplicarMspDepositos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fundosPrincipaisRefs(
    Expression<bool> Function($$FundosPrincipaisTableFilterComposer f) f,
  ) {
    final $$FundosPrincipaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableFilterComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> caixinhasRefs(
    Expression<bool> Function($$CaixinhasTableFilterComposer f) f,
  ) {
    final $$CaixinhasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableFilterComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> emprestimosRefs(
    Expression<bool> Function($$EmprestimosTableFilterComposer f) f,
  ) {
    final $$EmprestimosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableFilterComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> compromissosRefs(
    Expression<bool> Function($$CompromissosTableFilterComposer f) f,
  ) {
    final $$CompromissosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compromissos,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompromissosTableFilterComposer(
            $db: $db,
            $table: $db.compromissos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transacoesRefs(
    Expression<bool> Function($$TransacoesTableFilterComposer f) f,
  ) {
    final $$TransacoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacoes,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransacoesTableFilterComposer(
            $db: $db,
            $table: $db.transacoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userCloudId => $composableBuilder(
    column: $table.userCloudId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unidadePagamento => $composableBuilder(
    column: $table.unidadePagamento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaRevisaoMensal => $composableBuilder(
    column: $table.diaRevisaoMensal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inflacaoAplicarFerEmprestimos => $composableBuilder(
    column: $table.inflacaoAplicarFerEmprestimos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inflacaoAplicarFerFacilitadores =>
      $composableBuilder(
        column: $table.inflacaoAplicarFerFacilitadores,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get inflacaoAplicarMspDepositos => $composableBuilder(
    column: $table.inflacaoAplicarMspDepositos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userCloudId => $composableBuilder(
    column: $table.userCloudId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<double> get unidadePagamento => $composableBuilder(
    column: $table.unidadePagamento,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diaRevisaoMensal => $composableBuilder(
    column: $table.diaRevisaoMensal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get inflacaoAplicarFerEmprestimos => $composableBuilder(
    column: $table.inflacaoAplicarFerEmprestimos,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get inflacaoAplicarFerFacilitadores =>
      $composableBuilder(
        column: $table.inflacaoAplicarFerFacilitadores,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get inflacaoAplicarMspDepositos => $composableBuilder(
    column: $table.inflacaoAplicarMspDepositos,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => column,
  );

  Expression<T> fundosPrincipaisRefs<T extends Object>(
    Expression<T> Function($$FundosPrincipaisTableAnnotationComposer a) f,
  ) {
    final $$FundosPrincipaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableAnnotationComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> caixinhasRefs<T extends Object>(
    Expression<T> Function($$CaixinhasTableAnnotationComposer a) f,
  ) {
    final $$CaixinhasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableAnnotationComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> emprestimosRefs<T extends Object>(
    Expression<T> Function($$EmprestimosTableAnnotationComposer a) f,
  ) {
    final $$EmprestimosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> compromissosRefs<T extends Object>(
    Expression<T> Function($$CompromissosTableAnnotationComposer a) f,
  ) {
    final $$CompromissosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compromissos,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompromissosTableAnnotationComposer(
            $db: $db,
            $table: $db.compromissos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transacoesRefs<T extends Object>(
    Expression<T> Function($$TransacoesTableAnnotationComposer a) f,
  ) {
    final $$TransacoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacoes,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransacoesTableAnnotationComposer(
            $db: $db,
            $table: $db.transacoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTable,
          Usuario,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (Usuario, $$UsuariosTableReferences),
          Usuario,
          PrefetchHooks Function({
            bool fundosPrincipaisRefs,
            bool caixinhasRefs,
            bool emprestimosRefs,
            bool compromissosRefs,
            bool transacoesRefs,
          })
        > {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> userCloudId = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<double> unidadePagamento = const Value.absent(),
                Value<int> diaRevisaoMensal = const Value.absent(),
                Value<bool> inflacaoAplicarFerEmprestimos =
                    const Value.absent(),
                Value<bool> inflacaoAplicarFerFacilitadores =
                    const Value.absent(),
                Value<bool> inflacaoAplicarMspDepositos = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
              }) => UsuariosCompanion(
                id: id,
                userCloudId: userCloudId,
                nome: nome,
                unidadePagamento: unidadePagamento,
                diaRevisaoMensal: diaRevisaoMensal,
                inflacaoAplicarFerEmprestimos: inflacaoAplicarFerEmprestimos,
                inflacaoAplicarFerFacilitadores:
                    inflacaoAplicarFerFacilitadores,
                inflacaoAplicarMspDepositos: inflacaoAplicarMspDepositos,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> userCloudId = const Value.absent(),
                Value<String> nome = const Value.absent(),
                required double unidadePagamento,
                required int diaRevisaoMensal,
                Value<bool> inflacaoAplicarFerEmprestimos =
                    const Value.absent(),
                Value<bool> inflacaoAplicarFerFacilitadores =
                    const Value.absent(),
                Value<bool> inflacaoAplicarMspDepositos = const Value.absent(),
                required DateTime dataCriacao,
                required DateTime dataAtualizacao,
              }) => UsuariosCompanion.insert(
                id: id,
                userCloudId: userCloudId,
                nome: nome,
                unidadePagamento: unidadePagamento,
                diaRevisaoMensal: diaRevisaoMensal,
                inflacaoAplicarFerEmprestimos: inflacaoAplicarFerEmprestimos,
                inflacaoAplicarFerFacilitadores:
                    inflacaoAplicarFerFacilitadores,
                inflacaoAplicarMspDepositos: inflacaoAplicarMspDepositos,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsuariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                fundosPrincipaisRefs = false,
                caixinhasRefs = false,
                emprestimosRefs = false,
                compromissosRefs = false,
                transacoesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fundosPrincipaisRefs) db.fundosPrincipais,
                    if (caixinhasRefs) db.caixinhas,
                    if (emprestimosRefs) db.emprestimos,
                    if (compromissosRefs) db.compromissos,
                    if (transacoesRefs) db.transacoes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fundosPrincipaisRefs)
                        await $_getPrefetchedData<
                          Usuario,
                          $UsuariosTable,
                          FundosPrincipai
                        >(
                          currentTable: table,
                          referencedTable: $$UsuariosTableReferences
                              ._fundosPrincipaisRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsuariosTableReferences(
                                db,
                                table,
                                p0,
                              ).fundosPrincipaisRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (caixinhasRefs)
                        await $_getPrefetchedData<
                          Usuario,
                          $UsuariosTable,
                          Caixinha
                        >(
                          currentTable: table,
                          referencedTable: $$UsuariosTableReferences
                              ._caixinhasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsuariosTableReferences(
                                db,
                                table,
                                p0,
                              ).caixinhasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (emprestimosRefs)
                        await $_getPrefetchedData<
                          Usuario,
                          $UsuariosTable,
                          Emprestimo
                        >(
                          currentTable: table,
                          referencedTable: $$UsuariosTableReferences
                              ._emprestimosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsuariosTableReferences(
                                db,
                                table,
                                p0,
                              ).emprestimosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (compromissosRefs)
                        await $_getPrefetchedData<
                          Usuario,
                          $UsuariosTable,
                          Compromisso
                        >(
                          currentTable: table,
                          referencedTable: $$UsuariosTableReferences
                              ._compromissosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsuariosTableReferences(
                                db,
                                table,
                                p0,
                              ).compromissosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transacoesRefs)
                        await $_getPrefetchedData<
                          Usuario,
                          $UsuariosTable,
                          Transacoe
                        >(
                          currentTable: table,
                          referencedTable: $$UsuariosTableReferences
                              ._transacoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsuariosTableReferences(
                                db,
                                table,
                                p0,
                              ).transacoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTable,
      Usuario,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (Usuario, $$UsuariosTableReferences),
      Usuario,
      PrefetchHooks Function({
        bool fundosPrincipaisRefs,
        bool caixinhasRefs,
        bool emprestimosRefs,
        bool compromissosRefs,
        bool transacoesRefs,
      })
    >;
typedef $$FundosPrincipaisTableCreateCompanionBuilder =
    FundosPrincipaisCompanion Function({
      Value<int> id,
      required int usuarioId,
      required String tipoFundo,
      required String nomeFundo,
      Value<double> saldoAtual,
      Value<double> picoPatrimonioTotalAlcancado,
      required DateTime dataCriacao,
      required DateTime dataAtualizacao,
    });
typedef $$FundosPrincipaisTableUpdateCompanionBuilder =
    FundosPrincipaisCompanion Function({
      Value<int> id,
      Value<int> usuarioId,
      Value<String> tipoFundo,
      Value<String> nomeFundo,
      Value<double> saldoAtual,
      Value<double> picoPatrimonioTotalAlcancado,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
    });

final class $$FundosPrincipaisTableReferences
    extends
        BaseReferences<_$AppDatabase, $FundosPrincipaisTable, FundosPrincipai> {
  $$FundosPrincipaisTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.fundosPrincipais.usuarioId, db.usuarios.id),
      );

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EmprestimosTable, List<Emprestimo>>
  _emprestimosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emprestimos,
    aliasName: $_aliasNameGenerator(
      db.fundosPrincipais.id,
      db.emprestimos.fundoOrigemId,
    ),
  );

  $$EmprestimosTableProcessedTableManager get emprestimosRefs {
    final manager = $$EmprestimosTableTableManager(
      $_db,
      $_db.emprestimos,
    ).filter((f) => f.fundoOrigemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_emprestimosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CompromissosTable, List<Compromisso>>
  _compromissosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.compromissos,
    aliasName: $_aliasNameGenerator(
      db.fundosPrincipais.id,
      db.compromissos.fundoPrincipalDestinoId,
    ),
  );

  $$CompromissosTableProcessedTableManager get compromissosRefs {
    final manager = $$CompromissosTableTableManager($_db, $_db.compromissos)
        .filter(
          (f) =>
              f.fundoPrincipalDestinoId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_compromissosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FundosPrincipaisTableFilterComposer
    extends Composer<_$AppDatabase, $FundosPrincipaisTable> {
  $$FundosPrincipaisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoFundo => $composableBuilder(
    column: $table.tipoFundo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomeFundo => $composableBuilder(
    column: $table.nomeFundo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoAtual => $composableBuilder(
    column: $table.saldoAtual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get picoPatrimonioTotalAlcancado => $composableBuilder(
    column: $table.picoPatrimonioTotalAlcancado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> emprestimosRefs(
    Expression<bool> Function($$EmprestimosTableFilterComposer f) f,
  ) {
    final $$EmprestimosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.fundoOrigemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableFilterComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> compromissosRefs(
    Expression<bool> Function($$CompromissosTableFilterComposer f) f,
  ) {
    final $$CompromissosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compromissos,
      getReferencedColumn: (t) => t.fundoPrincipalDestinoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompromissosTableFilterComposer(
            $db: $db,
            $table: $db.compromissos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FundosPrincipaisTableOrderingComposer
    extends Composer<_$AppDatabase, $FundosPrincipaisTable> {
  $$FundosPrincipaisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoFundo => $composableBuilder(
    column: $table.tipoFundo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeFundo => $composableBuilder(
    column: $table.nomeFundo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoAtual => $composableBuilder(
    column: $table.saldoAtual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get picoPatrimonioTotalAlcancado =>
      $composableBuilder(
        column: $table.picoPatrimonioTotalAlcancado,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FundosPrincipaisTableAnnotationComposer
    extends Composer<_$AppDatabase, $FundosPrincipaisTable> {
  $$FundosPrincipaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipoFundo =>
      $composableBuilder(column: $table.tipoFundo, builder: (column) => column);

  GeneratedColumn<String> get nomeFundo =>
      $composableBuilder(column: $table.nomeFundo, builder: (column) => column);

  GeneratedColumn<double> get saldoAtual => $composableBuilder(
    column: $table.saldoAtual,
    builder: (column) => column,
  );

  GeneratedColumn<double> get picoPatrimonioTotalAlcancado =>
      $composableBuilder(
        column: $table.picoPatrimonioTotalAlcancado,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => column,
  );

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> emprestimosRefs<T extends Object>(
    Expression<T> Function($$EmprestimosTableAnnotationComposer a) f,
  ) {
    final $$EmprestimosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.fundoOrigemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> compromissosRefs<T extends Object>(
    Expression<T> Function($$CompromissosTableAnnotationComposer a) f,
  ) {
    final $$CompromissosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compromissos,
      getReferencedColumn: (t) => t.fundoPrincipalDestinoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompromissosTableAnnotationComposer(
            $db: $db,
            $table: $db.compromissos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FundosPrincipaisTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FundosPrincipaisTable,
          FundosPrincipai,
          $$FundosPrincipaisTableFilterComposer,
          $$FundosPrincipaisTableOrderingComposer,
          $$FundosPrincipaisTableAnnotationComposer,
          $$FundosPrincipaisTableCreateCompanionBuilder,
          $$FundosPrincipaisTableUpdateCompanionBuilder,
          (FundosPrincipai, $$FundosPrincipaisTableReferences),
          FundosPrincipai,
          PrefetchHooks Function({
            bool usuarioId,
            bool emprestimosRefs,
            bool compromissosRefs,
          })
        > {
  $$FundosPrincipaisTableTableManager(
    _$AppDatabase db,
    $FundosPrincipaisTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FundosPrincipaisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FundosPrincipaisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FundosPrincipaisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> tipoFundo = const Value.absent(),
                Value<String> nomeFundo = const Value.absent(),
                Value<double> saldoAtual = const Value.absent(),
                Value<double> picoPatrimonioTotalAlcancado =
                    const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
              }) => FundosPrincipaisCompanion(
                id: id,
                usuarioId: usuarioId,
                tipoFundo: tipoFundo,
                nomeFundo: nomeFundo,
                saldoAtual: saldoAtual,
                picoPatrimonioTotalAlcancado: picoPatrimonioTotalAlcancado,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int usuarioId,
                required String tipoFundo,
                required String nomeFundo,
                Value<double> saldoAtual = const Value.absent(),
                Value<double> picoPatrimonioTotalAlcancado =
                    const Value.absent(),
                required DateTime dataCriacao,
                required DateTime dataAtualizacao,
              }) => FundosPrincipaisCompanion.insert(
                id: id,
                usuarioId: usuarioId,
                tipoFundo: tipoFundo,
                nomeFundo: nomeFundo,
                saldoAtual: saldoAtual,
                picoPatrimonioTotalAlcancado: picoPatrimonioTotalAlcancado,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FundosPrincipaisTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                usuarioId = false,
                emprestimosRefs = false,
                compromissosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (emprestimosRefs) db.emprestimos,
                    if (compromissosRefs) db.compromissos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (usuarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.usuarioId,
                                    referencedTable:
                                        $$FundosPrincipaisTableReferences
                                            ._usuarioIdTable(db),
                                    referencedColumn:
                                        $$FundosPrincipaisTableReferences
                                            ._usuarioIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (emprestimosRefs)
                        await $_getPrefetchedData<
                          FundosPrincipai,
                          $FundosPrincipaisTable,
                          Emprestimo
                        >(
                          currentTable: table,
                          referencedTable: $$FundosPrincipaisTableReferences
                              ._emprestimosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FundosPrincipaisTableReferences(
                                db,
                                table,
                                p0,
                              ).emprestimosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fundoOrigemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (compromissosRefs)
                        await $_getPrefetchedData<
                          FundosPrincipai,
                          $FundosPrincipaisTable,
                          Compromisso
                        >(
                          currentTable: table,
                          referencedTable: $$FundosPrincipaisTableReferences
                              ._compromissosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FundosPrincipaisTableReferences(
                                db,
                                table,
                                p0,
                              ).compromissosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fundoPrincipalDestinoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FundosPrincipaisTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FundosPrincipaisTable,
      FundosPrincipai,
      $$FundosPrincipaisTableFilterComposer,
      $$FundosPrincipaisTableOrderingComposer,
      $$FundosPrincipaisTableAnnotationComposer,
      $$FundosPrincipaisTableCreateCompanionBuilder,
      $$FundosPrincipaisTableUpdateCompanionBuilder,
      (FundosPrincipai, $$FundosPrincipaisTableReferences),
      FundosPrincipai,
      PrefetchHooks Function({
        bool usuarioId,
        bool emprestimosRefs,
        bool compromissosRefs,
      })
    >;
typedef $$CaixinhasTableCreateCompanionBuilder =
    CaixinhasCompanion Function({
      Value<int> id,
      required int usuarioId,
      required String nomeCaixinha,
      Value<double> saldoAtual,
      Value<double?> metaValor,
      Value<bool> depositoObrigatorio,
      Value<String> statusCaixinha,
      Value<DateTime?> dataConclusao,
      required DateTime dataCriacao,
      required DateTime dataAtualizacao,
    });
typedef $$CaixinhasTableUpdateCompanionBuilder =
    CaixinhasCompanion Function({
      Value<int> id,
      Value<int> usuarioId,
      Value<String> nomeCaixinha,
      Value<double> saldoAtual,
      Value<double?> metaValor,
      Value<bool> depositoObrigatorio,
      Value<String> statusCaixinha,
      Value<DateTime?> dataConclusao,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
    });

final class $$CaixinhasTableReferences
    extends BaseReferences<_$AppDatabase, $CaixinhasTable, Caixinha> {
  $$CaixinhasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.caixinhas.usuarioId, db.usuarios.id),
      );

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CompromissosTable, List<Compromisso>>
  _compromissosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.compromissos,
    aliasName: $_aliasNameGenerator(
      db.caixinhas.id,
      db.compromissos.caixinhaDestinoId,
    ),
  );

  $$CompromissosTableProcessedTableManager get compromissosRefs {
    final manager = $$CompromissosTableTableManager(
      $_db,
      $_db.compromissos,
    ).filter((f) => f.caixinhaDestinoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_compromissosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CaixinhasTableFilterComposer
    extends Composer<_$AppDatabase, $CaixinhasTable> {
  $$CaixinhasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomeCaixinha => $composableBuilder(
    column: $table.nomeCaixinha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoAtual => $composableBuilder(
    column: $table.saldoAtual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get metaValor => $composableBuilder(
    column: $table.metaValor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get depositoObrigatorio => $composableBuilder(
    column: $table.depositoObrigatorio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusCaixinha => $composableBuilder(
    column: $table.statusCaixinha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataConclusao => $composableBuilder(
    column: $table.dataConclusao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> compromissosRefs(
    Expression<bool> Function($$CompromissosTableFilterComposer f) f,
  ) {
    final $$CompromissosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compromissos,
      getReferencedColumn: (t) => t.caixinhaDestinoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompromissosTableFilterComposer(
            $db: $db,
            $table: $db.compromissos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CaixinhasTableOrderingComposer
    extends Composer<_$AppDatabase, $CaixinhasTable> {
  $$CaixinhasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeCaixinha => $composableBuilder(
    column: $table.nomeCaixinha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoAtual => $composableBuilder(
    column: $table.saldoAtual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get metaValor => $composableBuilder(
    column: $table.metaValor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get depositoObrigatorio => $composableBuilder(
    column: $table.depositoObrigatorio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusCaixinha => $composableBuilder(
    column: $table.statusCaixinha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataConclusao => $composableBuilder(
    column: $table.dataConclusao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CaixinhasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaixinhasTable> {
  $$CaixinhasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomeCaixinha => $composableBuilder(
    column: $table.nomeCaixinha,
    builder: (column) => column,
  );

  GeneratedColumn<double> get saldoAtual => $composableBuilder(
    column: $table.saldoAtual,
    builder: (column) => column,
  );

  GeneratedColumn<double> get metaValor =>
      $composableBuilder(column: $table.metaValor, builder: (column) => column);

  GeneratedColumn<bool> get depositoObrigatorio => $composableBuilder(
    column: $table.depositoObrigatorio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statusCaixinha => $composableBuilder(
    column: $table.statusCaixinha,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataConclusao => $composableBuilder(
    column: $table.dataConclusao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => column,
  );

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> compromissosRefs<T extends Object>(
    Expression<T> Function($$CompromissosTableAnnotationComposer a) f,
  ) {
    final $$CompromissosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compromissos,
      getReferencedColumn: (t) => t.caixinhaDestinoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompromissosTableAnnotationComposer(
            $db: $db,
            $table: $db.compromissos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CaixinhasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CaixinhasTable,
          Caixinha,
          $$CaixinhasTableFilterComposer,
          $$CaixinhasTableOrderingComposer,
          $$CaixinhasTableAnnotationComposer,
          $$CaixinhasTableCreateCompanionBuilder,
          $$CaixinhasTableUpdateCompanionBuilder,
          (Caixinha, $$CaixinhasTableReferences),
          Caixinha,
          PrefetchHooks Function({bool usuarioId, bool compromissosRefs})
        > {
  $$CaixinhasTableTableManager(_$AppDatabase db, $CaixinhasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaixinhasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaixinhasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaixinhasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> nomeCaixinha = const Value.absent(),
                Value<double> saldoAtual = const Value.absent(),
                Value<double?> metaValor = const Value.absent(),
                Value<bool> depositoObrigatorio = const Value.absent(),
                Value<String> statusCaixinha = const Value.absent(),
                Value<DateTime?> dataConclusao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
              }) => CaixinhasCompanion(
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
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int usuarioId,
                required String nomeCaixinha,
                Value<double> saldoAtual = const Value.absent(),
                Value<double?> metaValor = const Value.absent(),
                Value<bool> depositoObrigatorio = const Value.absent(),
                Value<String> statusCaixinha = const Value.absent(),
                Value<DateTime?> dataConclusao = const Value.absent(),
                required DateTime dataCriacao,
                required DateTime dataAtualizacao,
              }) => CaixinhasCompanion.insert(
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
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CaixinhasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({usuarioId = false, compromissosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (compromissosRefs) db.compromissos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (usuarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.usuarioId,
                                    referencedTable: $$CaixinhasTableReferences
                                        ._usuarioIdTable(db),
                                    referencedColumn: $$CaixinhasTableReferences
                                        ._usuarioIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (compromissosRefs)
                        await $_getPrefetchedData<
                          Caixinha,
                          $CaixinhasTable,
                          Compromisso
                        >(
                          currentTable: table,
                          referencedTable: $$CaixinhasTableReferences
                              ._compromissosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CaixinhasTableReferences(
                                db,
                                table,
                                p0,
                              ).compromissosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caixinhaDestinoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CaixinhasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CaixinhasTable,
      Caixinha,
      $$CaixinhasTableFilterComposer,
      $$CaixinhasTableOrderingComposer,
      $$CaixinhasTableAnnotationComposer,
      $$CaixinhasTableCreateCompanionBuilder,
      $$CaixinhasTableUpdateCompanionBuilder,
      (Caixinha, $$CaixinhasTableReferences),
      Caixinha,
      PrefetchHooks Function({bool usuarioId, bool compromissosRefs})
    >;
typedef $$EmprestimosTableCreateCompanionBuilder =
    EmprestimosCompanion Function({
      Value<int> id,
      required int usuarioId,
      required int fundoOrigemId,
      required double valorConcedido,
      required double saldoDevedorAtual,
      Value<String?> proposito,
      required String statusEmprestimo,
      required DateTime dataConcessao,
      Value<DateTime?> dataQuitacao,
      Value<DateTime?> dataUltimoAjusteInflacao,
      required DateTime dataCriacao,
      required DateTime dataAtualizacao,
    });
typedef $$EmprestimosTableUpdateCompanionBuilder =
    EmprestimosCompanion Function({
      Value<int> id,
      Value<int> usuarioId,
      Value<int> fundoOrigemId,
      Value<double> valorConcedido,
      Value<double> saldoDevedorAtual,
      Value<String?> proposito,
      Value<String> statusEmprestimo,
      Value<DateTime> dataConcessao,
      Value<DateTime?> dataQuitacao,
      Value<DateTime?> dataUltimoAjusteInflacao,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
    });

final class $$EmprestimosTableReferences
    extends BaseReferences<_$AppDatabase, $EmprestimosTable, Emprestimo> {
  $$EmprestimosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.emprestimos.usuarioId, db.usuarios.id),
      );

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FundosPrincipaisTable _fundoOrigemIdTable(_$AppDatabase db) =>
      db.fundosPrincipais.createAlias(
        $_aliasNameGenerator(
          db.emprestimos.fundoOrigemId,
          db.fundosPrincipais.id,
        ),
      );

  $$FundosPrincipaisTableProcessedTableManager get fundoOrigemId {
    final $_column = $_itemColumn<int>('fundo_origem_id')!;

    final manager = $$FundosPrincipaisTableTableManager(
      $_db,
      $_db.fundosPrincipais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fundoOrigemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransacoesTable, List<Transacoe>>
  _transacoesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transacoes,
    aliasName: $_aliasNameGenerator(
      db.emprestimos.id,
      db.transacoes.emprestimoId,
    ),
  );

  $$TransacoesTableProcessedTableManager get transacoesRefs {
    final manager = $$TransacoesTableTableManager(
      $_db,
      $_db.transacoes,
    ).filter((f) => f.emprestimoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transacoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmprestimosTableFilterComposer
    extends Composer<_$AppDatabase, $EmprestimosTable> {
  $$EmprestimosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorConcedido => $composableBuilder(
    column: $table.valorConcedido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoDevedorAtual => $composableBuilder(
    column: $table.saldoDevedorAtual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proposito => $composableBuilder(
    column: $table.proposito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusEmprestimo => $composableBuilder(
    column: $table.statusEmprestimo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataConcessao => $composableBuilder(
    column: $table.dataConcessao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataQuitacao => $composableBuilder(
    column: $table.dataQuitacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataUltimoAjusteInflacao => $composableBuilder(
    column: $table.dataUltimoAjusteInflacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableFilterComposer get fundoOrigemId {
    final $$FundosPrincipaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoOrigemId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableFilterComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transacoesRefs(
    Expression<bool> Function($$TransacoesTableFilterComposer f) f,
  ) {
    final $$TransacoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacoes,
      getReferencedColumn: (t) => t.emprestimoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransacoesTableFilterComposer(
            $db: $db,
            $table: $db.transacoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmprestimosTableOrderingComposer
    extends Composer<_$AppDatabase, $EmprestimosTable> {
  $$EmprestimosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorConcedido => $composableBuilder(
    column: $table.valorConcedido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoDevedorAtual => $composableBuilder(
    column: $table.saldoDevedorAtual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proposito => $composableBuilder(
    column: $table.proposito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusEmprestimo => $composableBuilder(
    column: $table.statusEmprestimo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataConcessao => $composableBuilder(
    column: $table.dataConcessao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataQuitacao => $composableBuilder(
    column: $table.dataQuitacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataUltimoAjusteInflacao => $composableBuilder(
    column: $table.dataUltimoAjusteInflacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableOrderingComposer get fundoOrigemId {
    final $$FundosPrincipaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoOrigemId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableOrderingComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmprestimosTable> {
  $$EmprestimosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get valorConcedido => $composableBuilder(
    column: $table.valorConcedido,
    builder: (column) => column,
  );

  GeneratedColumn<double> get saldoDevedorAtual => $composableBuilder(
    column: $table.saldoDevedorAtual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proposito =>
      $composableBuilder(column: $table.proposito, builder: (column) => column);

  GeneratedColumn<String> get statusEmprestimo => $composableBuilder(
    column: $table.statusEmprestimo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataConcessao => $composableBuilder(
    column: $table.dataConcessao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataQuitacao => $composableBuilder(
    column: $table.dataQuitacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataUltimoAjusteInflacao => $composableBuilder(
    column: $table.dataUltimoAjusteInflacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => column,
  );

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableAnnotationComposer get fundoOrigemId {
    final $$FundosPrincipaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoOrigemId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableAnnotationComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transacoesRefs<T extends Object>(
    Expression<T> Function($$TransacoesTableAnnotationComposer a) f,
  ) {
    final $$TransacoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacoes,
      getReferencedColumn: (t) => t.emprestimoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransacoesTableAnnotationComposer(
            $db: $db,
            $table: $db.transacoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmprestimosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmprestimosTable,
          Emprestimo,
          $$EmprestimosTableFilterComposer,
          $$EmprestimosTableOrderingComposer,
          $$EmprestimosTableAnnotationComposer,
          $$EmprestimosTableCreateCompanionBuilder,
          $$EmprestimosTableUpdateCompanionBuilder,
          (Emprestimo, $$EmprestimosTableReferences),
          Emprestimo,
          PrefetchHooks Function({
            bool usuarioId,
            bool fundoOrigemId,
            bool transacoesRefs,
          })
        > {
  $$EmprestimosTableTableManager(_$AppDatabase db, $EmprestimosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmprestimosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmprestimosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmprestimosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<int> fundoOrigemId = const Value.absent(),
                Value<double> valorConcedido = const Value.absent(),
                Value<double> saldoDevedorAtual = const Value.absent(),
                Value<String?> proposito = const Value.absent(),
                Value<String> statusEmprestimo = const Value.absent(),
                Value<DateTime> dataConcessao = const Value.absent(),
                Value<DateTime?> dataQuitacao = const Value.absent(),
                Value<DateTime?> dataUltimoAjusteInflacao =
                    const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
              }) => EmprestimosCompanion(
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
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int usuarioId,
                required int fundoOrigemId,
                required double valorConcedido,
                required double saldoDevedorAtual,
                Value<String?> proposito = const Value.absent(),
                required String statusEmprestimo,
                required DateTime dataConcessao,
                Value<DateTime?> dataQuitacao = const Value.absent(),
                Value<DateTime?> dataUltimoAjusteInflacao =
                    const Value.absent(),
                required DateTime dataCriacao,
                required DateTime dataAtualizacao,
              }) => EmprestimosCompanion.insert(
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
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmprestimosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                usuarioId = false,
                fundoOrigemId = false,
                transacoesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (transacoesRefs) db.transacoes],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (usuarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.usuarioId,
                                    referencedTable:
                                        $$EmprestimosTableReferences
                                            ._usuarioIdTable(db),
                                    referencedColumn:
                                        $$EmprestimosTableReferences
                                            ._usuarioIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (fundoOrigemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fundoOrigemId,
                                    referencedTable:
                                        $$EmprestimosTableReferences
                                            ._fundoOrigemIdTable(db),
                                    referencedColumn:
                                        $$EmprestimosTableReferences
                                            ._fundoOrigemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transacoesRefs)
                        await $_getPrefetchedData<
                          Emprestimo,
                          $EmprestimosTable,
                          Transacoe
                        >(
                          currentTable: table,
                          referencedTable: $$EmprestimosTableReferences
                              ._transacoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmprestimosTableReferences(
                                db,
                                table,
                                p0,
                              ).transacoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.emprestimoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmprestimosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmprestimosTable,
      Emprestimo,
      $$EmprestimosTableFilterComposer,
      $$EmprestimosTableOrderingComposer,
      $$EmprestimosTableAnnotationComposer,
      $$EmprestimosTableCreateCompanionBuilder,
      $$EmprestimosTableUpdateCompanionBuilder,
      (Emprestimo, $$EmprestimosTableReferences),
      Emprestimo,
      PrefetchHooks Function({
        bool usuarioId,
        bool fundoOrigemId,
        bool transacoesRefs,
      })
    >;
typedef $$CompromissosTableCreateCompanionBuilder =
    CompromissosCompanion Function({
      Value<int> id,
      required int usuarioId,
      required String descricao,
      required String tipoCompromisso,
      Value<double?> valorTotalComprometido,
      required double valorParcela,
      Value<int?> numeroTotalParcelas,
      Value<int> numeroParcelasPagas,
      Value<int?> fundoPrincipalDestinoId,
      Value<int?> caixinhaDestinoId,
      required DateTime dataInicioCompromisso,
      Value<DateTime?> dataProximoVencimento,
      Value<String> statusCompromisso,
      Value<bool> ajusteInflacaoAplicavel,
      Value<DateTime?> dataUltimoAjusteInflacao,
      required DateTime dataCriacao,
      required DateTime dataAtualizacao,
    });
typedef $$CompromissosTableUpdateCompanionBuilder =
    CompromissosCompanion Function({
      Value<int> id,
      Value<int> usuarioId,
      Value<String> descricao,
      Value<String> tipoCompromisso,
      Value<double?> valorTotalComprometido,
      Value<double> valorParcela,
      Value<int?> numeroTotalParcelas,
      Value<int> numeroParcelasPagas,
      Value<int?> fundoPrincipalDestinoId,
      Value<int?> caixinhaDestinoId,
      Value<DateTime> dataInicioCompromisso,
      Value<DateTime?> dataProximoVencimento,
      Value<String> statusCompromisso,
      Value<bool> ajusteInflacaoAplicavel,
      Value<DateTime?> dataUltimoAjusteInflacao,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
    });

final class $$CompromissosTableReferences
    extends BaseReferences<_$AppDatabase, $CompromissosTable, Compromisso> {
  $$CompromissosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.compromissos.usuarioId, db.usuarios.id),
      );

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FundosPrincipaisTable _fundoPrincipalDestinoIdTable(
    _$AppDatabase db,
  ) => db.fundosPrincipais.createAlias(
    $_aliasNameGenerator(
      db.compromissos.fundoPrincipalDestinoId,
      db.fundosPrincipais.id,
    ),
  );

  $$FundosPrincipaisTableProcessedTableManager? get fundoPrincipalDestinoId {
    final $_column = $_itemColumn<int>('fundo_principal_destino_id');
    if ($_column == null) return null;
    final manager = $$FundosPrincipaisTableTableManager(
      $_db,
      $_db.fundosPrincipais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _fundoPrincipalDestinoIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CaixinhasTable _caixinhaDestinoIdTable(_$AppDatabase db) =>
      db.caixinhas.createAlias(
        $_aliasNameGenerator(
          db.compromissos.caixinhaDestinoId,
          db.caixinhas.id,
        ),
      );

  $$CaixinhasTableProcessedTableManager? get caixinhaDestinoId {
    final $_column = $_itemColumn<int>('caixinha_destino_id');
    if ($_column == null) return null;
    final manager = $$CaixinhasTableTableManager(
      $_db,
      $_db.caixinhas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caixinhaDestinoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransacoesTable, List<Transacoe>>
  _transacoesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transacoes,
    aliasName: $_aliasNameGenerator(
      db.compromissos.id,
      db.transacoes.compromissoId,
    ),
  );

  $$TransacoesTableProcessedTableManager get transacoesRefs {
    final manager = $$TransacoesTableTableManager(
      $_db,
      $_db.transacoes,
    ).filter((f) => f.compromissoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transacoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CompromissosTableFilterComposer
    extends Composer<_$AppDatabase, $CompromissosTable> {
  $$CompromissosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoCompromisso => $composableBuilder(
    column: $table.tipoCompromisso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorTotalComprometido => $composableBuilder(
    column: $table.valorTotalComprometido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorParcela => $composableBuilder(
    column: $table.valorParcela,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numeroTotalParcelas => $composableBuilder(
    column: $table.numeroTotalParcelas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numeroParcelasPagas => $composableBuilder(
    column: $table.numeroParcelasPagas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataInicioCompromisso => $composableBuilder(
    column: $table.dataInicioCompromisso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataProximoVencimento => $composableBuilder(
    column: $table.dataProximoVencimento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusCompromisso => $composableBuilder(
    column: $table.statusCompromisso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ajusteInflacaoAplicavel => $composableBuilder(
    column: $table.ajusteInflacaoAplicavel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataUltimoAjusteInflacao => $composableBuilder(
    column: $table.dataUltimoAjusteInflacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableFilterComposer get fundoPrincipalDestinoId {
    final $$FundosPrincipaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoPrincipalDestinoId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableFilterComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaixinhasTableFilterComposer get caixinhaDestinoId {
    final $$CaixinhasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caixinhaDestinoId,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableFilterComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transacoesRefs(
    Expression<bool> Function($$TransacoesTableFilterComposer f) f,
  ) {
    final $$TransacoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacoes,
      getReferencedColumn: (t) => t.compromissoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransacoesTableFilterComposer(
            $db: $db,
            $table: $db.transacoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompromissosTableOrderingComposer
    extends Composer<_$AppDatabase, $CompromissosTable> {
  $$CompromissosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoCompromisso => $composableBuilder(
    column: $table.tipoCompromisso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorTotalComprometido => $composableBuilder(
    column: $table.valorTotalComprometido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorParcela => $composableBuilder(
    column: $table.valorParcela,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numeroTotalParcelas => $composableBuilder(
    column: $table.numeroTotalParcelas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numeroParcelasPagas => $composableBuilder(
    column: $table.numeroParcelasPagas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataInicioCompromisso => $composableBuilder(
    column: $table.dataInicioCompromisso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataProximoVencimento => $composableBuilder(
    column: $table.dataProximoVencimento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusCompromisso => $composableBuilder(
    column: $table.statusCompromisso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ajusteInflacaoAplicavel => $composableBuilder(
    column: $table.ajusteInflacaoAplicavel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataUltimoAjusteInflacao => $composableBuilder(
    column: $table.dataUltimoAjusteInflacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableOrderingComposer get fundoPrincipalDestinoId {
    final $$FundosPrincipaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoPrincipalDestinoId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableOrderingComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaixinhasTableOrderingComposer get caixinhaDestinoId {
    final $$CaixinhasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caixinhaDestinoId,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableOrderingComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompromissosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompromissosTable> {
  $$CompromissosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<String> get tipoCompromisso => $composableBuilder(
    column: $table.tipoCompromisso,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valorTotalComprometido => $composableBuilder(
    column: $table.valorTotalComprometido,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valorParcela => $composableBuilder(
    column: $table.valorParcela,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numeroTotalParcelas => $composableBuilder(
    column: $table.numeroTotalParcelas,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numeroParcelasPagas => $composableBuilder(
    column: $table.numeroParcelasPagas,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataInicioCompromisso => $composableBuilder(
    column: $table.dataInicioCompromisso,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataProximoVencimento => $composableBuilder(
    column: $table.dataProximoVencimento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statusCompromisso => $composableBuilder(
    column: $table.statusCompromisso,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ajusteInflacaoAplicavel => $composableBuilder(
    column: $table.ajusteInflacaoAplicavel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataUltimoAjusteInflacao => $composableBuilder(
    column: $table.dataUltimoAjusteInflacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => column,
  );

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableAnnotationComposer get fundoPrincipalDestinoId {
    final $$FundosPrincipaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoPrincipalDestinoId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableAnnotationComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaixinhasTableAnnotationComposer get caixinhaDestinoId {
    final $$CaixinhasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caixinhaDestinoId,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableAnnotationComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transacoesRefs<T extends Object>(
    Expression<T> Function($$TransacoesTableAnnotationComposer a) f,
  ) {
    final $$TransacoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transacoes,
      getReferencedColumn: (t) => t.compromissoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransacoesTableAnnotationComposer(
            $db: $db,
            $table: $db.transacoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompromissosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompromissosTable,
          Compromisso,
          $$CompromissosTableFilterComposer,
          $$CompromissosTableOrderingComposer,
          $$CompromissosTableAnnotationComposer,
          $$CompromissosTableCreateCompanionBuilder,
          $$CompromissosTableUpdateCompanionBuilder,
          (Compromisso, $$CompromissosTableReferences),
          Compromisso,
          PrefetchHooks Function({
            bool usuarioId,
            bool fundoPrincipalDestinoId,
            bool caixinhaDestinoId,
            bool transacoesRefs,
          })
        > {
  $$CompromissosTableTableManager(_$AppDatabase db, $CompromissosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompromissosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompromissosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompromissosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<String> tipoCompromisso = const Value.absent(),
                Value<double?> valorTotalComprometido = const Value.absent(),
                Value<double> valorParcela = const Value.absent(),
                Value<int?> numeroTotalParcelas = const Value.absent(),
                Value<int> numeroParcelasPagas = const Value.absent(),
                Value<int?> fundoPrincipalDestinoId = const Value.absent(),
                Value<int?> caixinhaDestinoId = const Value.absent(),
                Value<DateTime> dataInicioCompromisso = const Value.absent(),
                Value<DateTime?> dataProximoVencimento = const Value.absent(),
                Value<String> statusCompromisso = const Value.absent(),
                Value<bool> ajusteInflacaoAplicavel = const Value.absent(),
                Value<DateTime?> dataUltimoAjusteInflacao =
                    const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
              }) => CompromissosCompanion(
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
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int usuarioId,
                required String descricao,
                required String tipoCompromisso,
                Value<double?> valorTotalComprometido = const Value.absent(),
                required double valorParcela,
                Value<int?> numeroTotalParcelas = const Value.absent(),
                Value<int> numeroParcelasPagas = const Value.absent(),
                Value<int?> fundoPrincipalDestinoId = const Value.absent(),
                Value<int?> caixinhaDestinoId = const Value.absent(),
                required DateTime dataInicioCompromisso,
                Value<DateTime?> dataProximoVencimento = const Value.absent(),
                Value<String> statusCompromisso = const Value.absent(),
                Value<bool> ajusteInflacaoAplicavel = const Value.absent(),
                Value<DateTime?> dataUltimoAjusteInflacao =
                    const Value.absent(),
                required DateTime dataCriacao,
                required DateTime dataAtualizacao,
              }) => CompromissosCompanion.insert(
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
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompromissosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                usuarioId = false,
                fundoPrincipalDestinoId = false,
                caixinhaDestinoId = false,
                transacoesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (transacoesRefs) db.transacoes],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (usuarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.usuarioId,
                                    referencedTable:
                                        $$CompromissosTableReferences
                                            ._usuarioIdTable(db),
                                    referencedColumn:
                                        $$CompromissosTableReferences
                                            ._usuarioIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (fundoPrincipalDestinoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn:
                                        table.fundoPrincipalDestinoId,
                                    referencedTable:
                                        $$CompromissosTableReferences
                                            ._fundoPrincipalDestinoIdTable(db),
                                    referencedColumn:
                                        $$CompromissosTableReferences
                                            ._fundoPrincipalDestinoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (caixinhaDestinoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.caixinhaDestinoId,
                                    referencedTable:
                                        $$CompromissosTableReferences
                                            ._caixinhaDestinoIdTable(db),
                                    referencedColumn:
                                        $$CompromissosTableReferences
                                            ._caixinhaDestinoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transacoesRefs)
                        await $_getPrefetchedData<
                          Compromisso,
                          $CompromissosTable,
                          Transacoe
                        >(
                          currentTable: table,
                          referencedTable: $$CompromissosTableReferences
                              ._transacoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompromissosTableReferences(
                                db,
                                table,
                                p0,
                              ).transacoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.compromissoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CompromissosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompromissosTable,
      Compromisso,
      $$CompromissosTableFilterComposer,
      $$CompromissosTableOrderingComposer,
      $$CompromissosTableAnnotationComposer,
      $$CompromissosTableCreateCompanionBuilder,
      $$CompromissosTableUpdateCompanionBuilder,
      (Compromisso, $$CompromissosTableReferences),
      Compromisso,
      PrefetchHooks Function({
        bool usuarioId,
        bool fundoPrincipalDestinoId,
        bool caixinhaDestinoId,
        bool transacoesRefs,
      })
    >;
typedef $$TransacoesTableCreateCompanionBuilder =
    TransacoesCompanion Function({
      Value<int> id,
      required int usuarioId,
      required double valor,
      required DateTime dataTransacao,
      required String descricao,
      required String tipoTransacao,
      Value<int?> fundoPrincipalOrigemId,
      Value<int?> caixinhaOrigemId,
      Value<int?> fundoPrincipalDestinoId,
      Value<int?> caixinhaDestinoId,
      Value<int?> emprestimoId,
      Value<int?> compromissoId,
      required DateTime dataCriacao,
      required DateTime dataAtualizacao,
    });
typedef $$TransacoesTableUpdateCompanionBuilder =
    TransacoesCompanion Function({
      Value<int> id,
      Value<int> usuarioId,
      Value<double> valor,
      Value<DateTime> dataTransacao,
      Value<String> descricao,
      Value<String> tipoTransacao,
      Value<int?> fundoPrincipalOrigemId,
      Value<int?> caixinhaOrigemId,
      Value<int?> fundoPrincipalDestinoId,
      Value<int?> caixinhaDestinoId,
      Value<int?> emprestimoId,
      Value<int?> compromissoId,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
    });

final class $$TransacoesTableReferences
    extends BaseReferences<_$AppDatabase, $TransacoesTable, Transacoe> {
  $$TransacoesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
        $_aliasNameGenerator(db.transacoes.usuarioId, db.usuarios.id),
      );

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FundosPrincipaisTable _fundoPrincipalOrigemIdTable(
    _$AppDatabase db,
  ) => db.fundosPrincipais.createAlias(
    $_aliasNameGenerator(
      db.transacoes.fundoPrincipalOrigemId,
      db.fundosPrincipais.id,
    ),
  );

  $$FundosPrincipaisTableProcessedTableManager? get fundoPrincipalOrigemId {
    final $_column = $_itemColumn<int>('fundo_principal_origem_id');
    if ($_column == null) return null;
    final manager = $$FundosPrincipaisTableTableManager(
      $_db,
      $_db.fundosPrincipais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _fundoPrincipalOrigemIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CaixinhasTable _caixinhaOrigemIdTable(_$AppDatabase db) =>
      db.caixinhas.createAlias(
        $_aliasNameGenerator(db.transacoes.caixinhaOrigemId, db.caixinhas.id),
      );

  $$CaixinhasTableProcessedTableManager? get caixinhaOrigemId {
    final $_column = $_itemColumn<int>('caixinha_origem_id');
    if ($_column == null) return null;
    final manager = $$CaixinhasTableTableManager(
      $_db,
      $_db.caixinhas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caixinhaOrigemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FundosPrincipaisTable _fundoPrincipalDestinoIdTable(
    _$AppDatabase db,
  ) => db.fundosPrincipais.createAlias(
    $_aliasNameGenerator(
      db.transacoes.fundoPrincipalDestinoId,
      db.fundosPrincipais.id,
    ),
  );

  $$FundosPrincipaisTableProcessedTableManager? get fundoPrincipalDestinoId {
    final $_column = $_itemColumn<int>('fundo_principal_destino_id');
    if ($_column == null) return null;
    final manager = $$FundosPrincipaisTableTableManager(
      $_db,
      $_db.fundosPrincipais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _fundoPrincipalDestinoIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CaixinhasTable _caixinhaDestinoIdTable(_$AppDatabase db) =>
      db.caixinhas.createAlias(
        $_aliasNameGenerator(db.transacoes.caixinhaDestinoId, db.caixinhas.id),
      );

  $$CaixinhasTableProcessedTableManager? get caixinhaDestinoId {
    final $_column = $_itemColumn<int>('caixinha_destino_id');
    if ($_column == null) return null;
    final manager = $$CaixinhasTableTableManager(
      $_db,
      $_db.caixinhas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caixinhaDestinoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmprestimosTable _emprestimoIdTable(_$AppDatabase db) =>
      db.emprestimos.createAlias(
        $_aliasNameGenerator(db.transacoes.emprestimoId, db.emprestimos.id),
      );

  $$EmprestimosTableProcessedTableManager? get emprestimoId {
    final $_column = $_itemColumn<int>('emprestimo_id');
    if ($_column == null) return null;
    final manager = $$EmprestimosTableTableManager(
      $_db,
      $_db.emprestimos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_emprestimoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CompromissosTable _compromissoIdTable(_$AppDatabase db) =>
      db.compromissos.createAlias(
        $_aliasNameGenerator(db.transacoes.compromissoId, db.compromissos.id),
      );

  $$CompromissosTableProcessedTableManager? get compromissoId {
    final $_column = $_itemColumn<int>('compromisso_id');
    if ($_column == null) return null;
    final manager = $$CompromissosTableTableManager(
      $_db,
      $_db.compromissos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_compromissoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransacoesTableFilterComposer
    extends Composer<_$AppDatabase, $TransacoesTable> {
  $$TransacoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataTransacao => $composableBuilder(
    column: $table.dataTransacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoTransacao => $composableBuilder(
    column: $table.tipoTransacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableFilterComposer get fundoPrincipalOrigemId {
    final $$FundosPrincipaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoPrincipalOrigemId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableFilterComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaixinhasTableFilterComposer get caixinhaOrigemId {
    final $$CaixinhasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caixinhaOrigemId,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableFilterComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableFilterComposer get fundoPrincipalDestinoId {
    final $$FundosPrincipaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoPrincipalDestinoId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableFilterComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaixinhasTableFilterComposer get caixinhaDestinoId {
    final $$CaixinhasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caixinhaDestinoId,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableFilterComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmprestimosTableFilterComposer get emprestimoId {
    final $$EmprestimosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emprestimoId,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableFilterComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompromissosTableFilterComposer get compromissoId {
    final $$CompromissosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compromissoId,
      referencedTable: $db.compromissos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompromissosTableFilterComposer(
            $db: $db,
            $table: $db.compromissos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransacoesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransacoesTable> {
  $$TransacoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataTransacao => $composableBuilder(
    column: $table.dataTransacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoTransacao => $composableBuilder(
    column: $table.tipoTransacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableOrderingComposer get fundoPrincipalOrigemId {
    final $$FundosPrincipaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoPrincipalOrigemId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableOrderingComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaixinhasTableOrderingComposer get caixinhaOrigemId {
    final $$CaixinhasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caixinhaOrigemId,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableOrderingComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableOrderingComposer get fundoPrincipalDestinoId {
    final $$FundosPrincipaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoPrincipalDestinoId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableOrderingComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaixinhasTableOrderingComposer get caixinhaDestinoId {
    final $$CaixinhasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caixinhaDestinoId,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableOrderingComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmprestimosTableOrderingComposer get emprestimoId {
    final $$EmprestimosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emprestimoId,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableOrderingComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompromissosTableOrderingComposer get compromissoId {
    final $$CompromissosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compromissoId,
      referencedTable: $db.compromissos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompromissosTableOrderingComposer(
            $db: $db,
            $table: $db.compromissos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransacoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransacoesTable> {
  $$TransacoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<DateTime> get dataTransacao => $composableBuilder(
    column: $table.dataTransacao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<String> get tipoTransacao => $composableBuilder(
    column: $table.tipoTransacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => column,
  );

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableAnnotationComposer get fundoPrincipalOrigemId {
    final $$FundosPrincipaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoPrincipalOrigemId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableAnnotationComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaixinhasTableAnnotationComposer get caixinhaOrigemId {
    final $$CaixinhasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caixinhaOrigemId,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableAnnotationComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FundosPrincipaisTableAnnotationComposer get fundoPrincipalDestinoId {
    final $$FundosPrincipaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fundoPrincipalDestinoId,
      referencedTable: $db.fundosPrincipais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FundosPrincipaisTableAnnotationComposer(
            $db: $db,
            $table: $db.fundosPrincipais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaixinhasTableAnnotationComposer get caixinhaDestinoId {
    final $$CaixinhasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caixinhaDestinoId,
      referencedTable: $db.caixinhas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaixinhasTableAnnotationComposer(
            $db: $db,
            $table: $db.caixinhas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmprestimosTableAnnotationComposer get emprestimoId {
    final $$EmprestimosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emprestimoId,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CompromissosTableAnnotationComposer get compromissoId {
    final $$CompromissosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compromissoId,
      referencedTable: $db.compromissos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompromissosTableAnnotationComposer(
            $db: $db,
            $table: $db.compromissos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransacoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransacoesTable,
          Transacoe,
          $$TransacoesTableFilterComposer,
          $$TransacoesTableOrderingComposer,
          $$TransacoesTableAnnotationComposer,
          $$TransacoesTableCreateCompanionBuilder,
          $$TransacoesTableUpdateCompanionBuilder,
          (Transacoe, $$TransacoesTableReferences),
          Transacoe,
          PrefetchHooks Function({
            bool usuarioId,
            bool fundoPrincipalOrigemId,
            bool caixinhaOrigemId,
            bool fundoPrincipalDestinoId,
            bool caixinhaDestinoId,
            bool emprestimoId,
            bool compromissoId,
          })
        > {
  $$TransacoesTableTableManager(_$AppDatabase db, $TransacoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransacoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransacoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransacoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<double> valor = const Value.absent(),
                Value<DateTime> dataTransacao = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<String> tipoTransacao = const Value.absent(),
                Value<int?> fundoPrincipalOrigemId = const Value.absent(),
                Value<int?> caixinhaOrigemId = const Value.absent(),
                Value<int?> fundoPrincipalDestinoId = const Value.absent(),
                Value<int?> caixinhaDestinoId = const Value.absent(),
                Value<int?> emprestimoId = const Value.absent(),
                Value<int?> compromissoId = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
              }) => TransacoesCompanion(
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
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int usuarioId,
                required double valor,
                required DateTime dataTransacao,
                required String descricao,
                required String tipoTransacao,
                Value<int?> fundoPrincipalOrigemId = const Value.absent(),
                Value<int?> caixinhaOrigemId = const Value.absent(),
                Value<int?> fundoPrincipalDestinoId = const Value.absent(),
                Value<int?> caixinhaDestinoId = const Value.absent(),
                Value<int?> emprestimoId = const Value.absent(),
                Value<int?> compromissoId = const Value.absent(),
                required DateTime dataCriacao,
                required DateTime dataAtualizacao,
              }) => TransacoesCompanion.insert(
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
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransacoesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                usuarioId = false,
                fundoPrincipalOrigemId = false,
                caixinhaOrigemId = false,
                fundoPrincipalDestinoId = false,
                caixinhaDestinoId = false,
                emprestimoId = false,
                compromissoId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (usuarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.usuarioId,
                                    referencedTable: $$TransacoesTableReferences
                                        ._usuarioIdTable(db),
                                    referencedColumn:
                                        $$TransacoesTableReferences
                                            ._usuarioIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (fundoPrincipalOrigemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fundoPrincipalOrigemId,
                                    referencedTable: $$TransacoesTableReferences
                                        ._fundoPrincipalOrigemIdTable(db),
                                    referencedColumn:
                                        $$TransacoesTableReferences
                                            ._fundoPrincipalOrigemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (caixinhaOrigemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.caixinhaOrigemId,
                                    referencedTable: $$TransacoesTableReferences
                                        ._caixinhaOrigemIdTable(db),
                                    referencedColumn:
                                        $$TransacoesTableReferences
                                            ._caixinhaOrigemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (fundoPrincipalDestinoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn:
                                        table.fundoPrincipalDestinoId,
                                    referencedTable: $$TransacoesTableReferences
                                        ._fundoPrincipalDestinoIdTable(db),
                                    referencedColumn:
                                        $$TransacoesTableReferences
                                            ._fundoPrincipalDestinoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (caixinhaDestinoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.caixinhaDestinoId,
                                    referencedTable: $$TransacoesTableReferences
                                        ._caixinhaDestinoIdTable(db),
                                    referencedColumn:
                                        $$TransacoesTableReferences
                                            ._caixinhaDestinoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (emprestimoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.emprestimoId,
                                    referencedTable: $$TransacoesTableReferences
                                        ._emprestimoIdTable(db),
                                    referencedColumn:
                                        $$TransacoesTableReferences
                                            ._emprestimoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (compromissoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.compromissoId,
                                    referencedTable: $$TransacoesTableReferences
                                        ._compromissoIdTable(db),
                                    referencedColumn:
                                        $$TransacoesTableReferences
                                            ._compromissoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransacoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransacoesTable,
      Transacoe,
      $$TransacoesTableFilterComposer,
      $$TransacoesTableOrderingComposer,
      $$TransacoesTableAnnotationComposer,
      $$TransacoesTableCreateCompanionBuilder,
      $$TransacoesTableUpdateCompanionBuilder,
      (Transacoe, $$TransacoesTableReferences),
      Transacoe,
      PrefetchHooks Function({
        bool usuarioId,
        bool fundoPrincipalOrigemId,
        bool caixinhaOrigemId,
        bool fundoPrincipalDestinoId,
        bool caixinhaDestinoId,
        bool emprestimoId,
        bool compromissoId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$FundosPrincipaisTableTableManager get fundosPrincipais =>
      $$FundosPrincipaisTableTableManager(_db, _db.fundosPrincipais);
  $$CaixinhasTableTableManager get caixinhas =>
      $$CaixinhasTableTableManager(_db, _db.caixinhas);
  $$EmprestimosTableTableManager get emprestimos =>
      $$EmprestimosTableTableManager(_db, _db.emprestimos);
  $$CompromissosTableTableManager get compromissos =>
      $$CompromissosTableTableManager(_db, _db.compromissos);
  $$TransacoesTableTableManager get transacoes =>
      $$TransacoesTableTableManager(_db, _db.transacoes);
}
