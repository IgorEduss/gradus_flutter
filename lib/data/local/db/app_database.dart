import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:gradus/data/local/tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Usuarios,
  FundosPrincipais,
  Caixinhas,
  Emprestimos,
  Compromissos,
  Transacoes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add dataUltimoAjusteInflacao to Compromissos
          await m.addColumn(compromissos, compromissos.dataUltimoAjusteInflacao);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    print('📂 BANCO DE DADOS LOCALIZADO EM: ${file.path}'); // DEBUG: Print DB Path
    return NativeDatabase(file); // Run on main isolate to avoid Completer race conditions
  });
}
