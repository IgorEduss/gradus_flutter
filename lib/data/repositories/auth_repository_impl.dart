import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart' as la;
import '../../domain/repositories/i_auth_repository.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final FlutterSecureStorage _storage;
  final la.LocalAuthentication _localAuth;

  AuthRepositoryImpl(this._storage, this._localAuth);

  static const _pinKey = 'user_pin';
  static const _recoveryEmailKey = 'recovery_email';

  @override
  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  @override
  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  @override
  Future<String?> getRecoveryEmail() async {
    return await _storage.read(key: _recoveryEmailKey);
  }

  @override
  Future<void> saveRecoveryEmail(String email) async {
    await _storage.write(key: _recoveryEmailKey, value: email);
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Autentique-se para acessar o Gradus',
        options: const la.AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> canAuthenticateWithBiometrics() async {
    try {
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
