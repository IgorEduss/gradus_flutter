import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:drift/drift.dart';
import 'dart:io';
import '../../../data/local/db/app_database.dart';
import 'package:get_it/get_it.dart';

// State for Security
class SecurityState {
  final bool hasPin;
  final bool isBiometricsEnabled;
  final bool canCheckBiometrics;

  SecurityState({
    required this.hasPin,
    required this.isBiometricsEnabled,
    required this.canCheckBiometrics,
  });

  SecurityState copyWith({
    bool? hasPin,
    bool? isBiometricsEnabled,
    bool? canCheckBiometrics,
  }) {
    return SecurityState(
      hasPin: hasPin ?? this.hasPin,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
    );
  }
}

class SecurityController extends StateNotifier<SecurityState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final LocalAuthentication _auth = LocalAuthentication();
  
  static const String _pinKey = 'user_pin';
  static const String _bioKey = 'biometrics_enabled';

  SecurityController() : super(SecurityState(hasPin: false, isBiometricsEnabled: false, canCheckBiometrics: false)) {
    _init();
  }

  Future<void> _init() async {
    final hasPin = await _storage.containsKey(key: _pinKey);
    final bioEnabled = await _storage.read(key: _bioKey) == 'true';
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } catch (e) {
      // Handle error
    }

    state = SecurityState(
      hasPin: hasPin,
      isBiometricsEnabled: bioEnabled,
      canCheckBiometrics: canCheckBiometrics,
    );
  }

  Future<bool> verifyPin(String pin) async {
    final storedPin = await _storage.read(key: _pinKey);
    return storedPin == pin;
  }

  Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    state = state.copyWith(hasPin: true);
  }

  Future<void> toggleBiometrics(bool enabled) async {
    if (enabled) {
      // Verify bio first before enabling
      try {
        final authenticated = await _auth.authenticate(
          localizedReason: 'Autentique para habilitar a biometria',
          options: const AuthenticationOptions(stickyAuth: true),
        );
        if (!authenticated) return;
      } catch (e) {
        return;
      }
    }
    await _storage.write(key: _bioKey, value: enabled.toString());
    state = state.copyWith(isBiometricsEnabled: enabled);
  }
  
  Future<bool> authenticateBiometrics() async {
    if (!state.isBiometricsEnabled || !state.canCheckBiometrics) return false;
    try {
      return await _auth.authenticate(
        localizedReason: 'Autentique para acessar',
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } catch (e) {
      return false;
    }
  }

  // WIPE DATA Logic
  Future<void> wipeAllData(WidgetRef ref) async {
    // 1. Clear Secure Storage
    await _storage.deleteAll();
    
    // 2. Clear Database (Truncate Tables)
    try {
        final db = GetIt.I<AppDatabase>();
        // Do NOT close the DB connection, just clear data.
        await db.transaction(() async {
            // Delete content from all tables
            // Order matters if foreign keys are enforced, but we are deleting all.
            await db.customStatement('DELETE FROM transacoes');
            await db.customStatement('DELETE FROM compromissos');
            await db.customStatement('DELETE FROM emprestimos');
            await db.customStatement('DELETE FROM caixinhas');
            await db.customStatement('DELETE FROM fundos_principais');
            await db.customStatement('DELETE FROM usuarios');
        });
        
    } catch (e) {
        print("Error wiping DB: $e");
        // Even if DB wipe fails, we reset UI state
    }
    
    // 3. Reset State
    state = SecurityState(hasPin: false, isBiometricsEnabled: false, canCheckBiometrics: state.canCheckBiometrics);
    
    // 4. Force Redirect to Onboarding via AuthNotifier
    // We must pass ref to this method or use a callback mechanism.
    // Since this is a Controller, we usually don't have access to excessive refs unless passed.
    // Changing signature of wipeAllData to accept WidgetRef ref.
    
    // Alternatively, if we cannot pass ref easily, we can assume the UI listening to this state changes or AuthStatus changes.
    // But AuthNotifier is separate.
    // Let's rely on the caller passing the ref, or simpler:
    // The caller (Settings Screen) should call `ref.read(authNotifierProvider.notifier).resetApp()` 
    // AFTER this completes?
    
    // Better: Calls to this controller should be:
    // ref.read(securityControllerProvider.notifier).wipeAllData();
    // ref.read(authNotifierProvider.notifier).resetApp();
    
    // But wait, resetApp() in auth_provider also does _repository.clearAll().
    // We should consolidate.
  }
}

final securityControllerProvider = StateNotifierProvider<SecurityController, SecurityState>((ref) {
  return SecurityController();
});
