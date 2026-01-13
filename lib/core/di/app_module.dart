import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart' as la;

@module
abstract class AppModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  la.LocalAuthentication get localAuth => la.LocalAuthentication();

  @lazySingleton
  gsi.GoogleSignIn get googleSignIn => gsi.GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.appdata',
    ],
  );
}
