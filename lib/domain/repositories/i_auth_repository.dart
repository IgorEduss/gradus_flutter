abstract class IAuthRepository {
  Future<String?> getPin();
  Future<void> savePin(String pin);
  Future<String?> getRecoveryEmail();
  Future<void> saveRecoveryEmail(String email);
  Future<void> clearAll();
  Future<bool> authenticateWithBiometrics();
  Future<bool> canAuthenticateWithBiometrics();
}
