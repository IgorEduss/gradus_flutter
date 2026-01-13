import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import '../../core/di/injection.dart';
import '../../domain/repositories/i_auth_repository.dart';

part 'auth_provider.g.dart';

enum AuthStatus {
  loading,
  unauthenticated, // No PIN set
  locked, // PIN set, but locked
  authenticated, // Unlocked
  settingPin, // In process of setting PIN (handled by UI state usually, but can be here)
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final IAuthRepository _repository;

  @override
  Future<AuthStatus> build() async {
    _repository = getIt<IAuthRepository>();
    return _checkAuthStatus();
  }

  Future<AuthStatus> _checkAuthStatus() async {
    final pin = await _repository.getPin();
    if (pin == null || pin.isEmpty) {
      return AuthStatus.unauthenticated;
    }
    return AuthStatus.locked;
  }

  Future<void> setPin(String pin) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.savePin(pin);
      return AuthStatus.authenticated;
    });
  }

  Future<bool> unlock(String pin) async {
    final storedPin = await _repository.getPin();
    if (storedPin == pin) {
      state = const AsyncValue.data(AuthStatus.authenticated);
      return true;
    }
    return false;
  }

  Future<bool> unlockWithBiometrics() async {
    final success = await _repository.authenticateWithBiometrics();
    if (success) {
      state = const AsyncValue.data(AuthStatus.authenticated);
      return true;
    }
    return false;
  }

  Future<bool> canUseBiometrics() async {
    return await _repository.canAuthenticateWithBiometrics();
  }

  Future<bool> recoverWithGoogle() async {
     try {
       final googleSignIn = getIt<gsi.GoogleSignIn>();
       final account = await googleSignIn.signIn();
       if (account == null) return false; // User cancelled

       final storedEmail = await _repository.getRecoveryEmail();
       
       // If no email stored, we can't verify, so valid recovery is impossible.
       // Treat as failure unless we want to allow setting it now (but that's insecure).
       if (storedEmail == null) {
          return false;
       }

       if (account.email == storedEmail) {
         // Success: Allow reset
         // Logic: Clear PIN but keep email? Or just go to unauthenticated mode.
         // If we go to unauthenticated, the UI shows "Create PIN".
         // We should clear the PIN first.
         await _repository.savePin(''); // Clear PIN
         // Or dedicated clearPin method. saving empty string works if I check isEmpty.
         // My checkAuthStatus uses: if (pin == null).
         // So I should remove the key.
         // I'll add removePin to repo or just use null if storage allows deleting via write null? No.
         // _repository.savePin might not support deleting.
         // Let's rely on resetApp for full wipe, but here we just want to reset PIN.
         
         // Actually, if I set state to unauthenticated, the UI asks to create pin.
         // When user creates pin, it calls setPin -> savePin.
         // But checkAuthStatus needs to return unauthenticated next time.
         // So I must physically remove the old PIN.
         // I'll assume savePin with empty string is not null.
         // I should fix checkAuthStatus to: if (pin == null || pin.isEmpty)
         
         // Let's fix checkAuthStatus first? No, let's just use clearAll() but restore email?
         // Safest: set state to unauthenticated.
         // But persistency matters. I'll implement a `resetPin()` method in repo later?
         // For now, I'll assume `savePin('RESET')` marks it as invalid?
         // No, easiest is `_repository.clearAll()` but that wipes the email too.
         // The requirement says: "Crie seu novo PIN."
         
         // I'll modify checkAuthStatus to treat empty string as unauthenticated.
         // And savePin('') here.
         await _repository.savePin('');
         state = const AsyncValue.data(AuthStatus.unauthenticated);
         return true;
       }
       
       return false; // Email mismatch
     } catch (e) {
       return false;
     }
  }

  Future<void> resetApp() async {
    state = const AsyncValue.loading();
    await _repository.clearAll(); 
    // TODO: Clear SQLite database as well via dedicated repository or helper
    // final db = getIt<AppDatabase>();
    // await db.close(); 
    // Delete file? Or truncate tables.
    // Ideally inject Database and call a clear method.
    state = const AsyncValue.data(AuthStatus.unauthenticated);
  }

  Future<void> logout() async {
    state = const AsyncValue.data(AuthStatus.locked);
  }
}
