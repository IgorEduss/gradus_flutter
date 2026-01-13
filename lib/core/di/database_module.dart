import 'package:injectable/injectable.dart';
import '../../data/local/db/app_database.dart';

@module
abstract class DatabaseModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();
}
