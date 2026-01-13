import 'dart:io';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../data/local/db/app_database.dart';

@lazySingleton
class BackupService {
  final GoogleSignIn _googleSignIn;
  final AppDatabase _db;

  BackupService(this._googleSignIn, this._db);

  /// Authenticates and gets the Drive API client
  Future<drive.DriveApi?> _getDriveApi({bool interactive = false}) async {
    // 1. Try to get authenticated client from current session
    var authClient = await _googleSignIn.authenticatedClient();
    
    if (authClient == null) {
        // 2. Not authenticated? Try silent sign-in
        final account = await _googleSignIn.signInSilently();
        
        if (account == null) {
           // 3. Silent failed. If interactive, force sign-in UI
           if (interactive) {
             final newAccount = await _googleSignIn.signIn();
             if (newAccount == null) return null; // User aborted
           } else {
             return null;
           }
        }
        
        // 4. Retry getting client after sign-in (silent or interactive)
        authClient = await _googleSignIn.authenticatedClient();
    }
    
    // 5. If still null, we can't proceed
    if (authClient == null) return null;

    return drive.DriveApi(authClient);
  }

  /// Uploads the local database to Google Drive AppData folder
  Future<String> backup() async {
    final driveApi = await _getDriveApi(interactive: true);
    if (driveApi == null) throw Exception('É necessário fazer login com o Google para realizar o backup.');

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (!file.existsSync()) throw Exception('Banco de dados local não encontrado.');

    // 1. Check if backup already exists
    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = 'db_backup.sqlite'",
    );

    final files = fileList.files;
    final fileObj = drive.File();
    fileObj.name = 'db_backup.sqlite';
    fileObj.parents = ['appDataFolder']; // Hidden folder

    final media = drive.Media(file.openRead(), file.lengthSync());

    if (files != null && files.isNotEmpty) {
      // Update existing file
      final fileId = files.first.id!;
      await driveApi.files.update(fileObj, fileId, uploadMedia: media);
      return 'Backup atualizado com sucesso!';
    } else {
      // Create new file
      await driveApi.files.create(fileObj, uploadMedia: media);
      return 'Backup criado com sucesso!';
    }
  }

  /// Restores the database from Google Drive
  Future<void> restore() async {
    final driveApi = await _getDriveApi(interactive: true);
    if (driveApi == null) throw Exception('É necessário fazer login com o Google para restaurar o backup.');

    // 1. Find backup
    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = 'db_backup.sqlite'",
    );

    final files = fileList.files;
    if (files == null || files.isEmpty) {
      throw Exception('Nenhum backup encontrado no Google Drive.');
    }

    final fileId = files.first.id!;
    final drive.Media fileMedia = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    // 2. Download to temp file
    final dbFolder = await getApplicationDocumentsDirectory();
    final tempPath = p.join(dbFolder.path, 'db_restore_temp.sqlite');
    final tempFile = File(tempPath);

    final List<int> dataStore = [];
    await fileMedia.stream.forEach((data) {
      dataStore.addAll(data);
    });
    
    await tempFile.writeAsBytes(dataStore);

    // 3. Close current DB Connection
    await _db.close();

    // 4. Verification Check? (Start/End of file header?)
    
    // 5. Replace 'db.sqlite'
    final dbPath = p.join(dbFolder.path, 'db.sqlite');
    await tempFile.copy(dbPath);
    await tempFile.delete();

    // 6. Must restart app or re-open DB?
    // Since AppDatabase is a singleton, it is now closed.
    // The app usually crashes or needs restart.
    // We should throw a specific exception "RestartRequired" or handle it in UI.
  }

  Future<DateTime?> getLastBackupTime() async {
     try {
       final driveApi = await _getDriveApi();
       if (driveApi == null) return null;

       final fileList = await driveApi.files.list(
          spaces: 'appDataFolder',
          q: "name = 'db_backup.sqlite'",
          $fields: 'files(modifiedTime)',
        );
        
       if (fileList.files?.isNotEmpty == true) {
         return fileList.files!.first.modifiedTime;
       }
       return null;
     } catch (e) {
       return null;
     }
  }
}
