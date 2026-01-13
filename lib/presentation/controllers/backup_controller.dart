import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/injection.dart';
import '../../core/services/backup_service.dart';

part 'backup_controller.g.dart';

@riverpod
class BackupController extends _$BackupController {
  late final BackupService _service;

  @override
  Future<DateTime?> build() async {
    _service = getIt<BackupService>();
    return _service.getLastBackupTime();
  }

  Future<void> backup() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.backup();
      return _service.getLastBackupTime();
    });
  }

  Future<void> restore() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.restore();
      // After restore, we might need to reload app state generally.
      // But for this controller, we just want the timestamp.
      return _service.getLastBackupTime();
    });
  }
}
