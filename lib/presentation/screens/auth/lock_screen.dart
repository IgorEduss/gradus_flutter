import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/numeric_keyboard.dart';
import '../../widgets/auth/pin_dots.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  String _currentPin = '';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    // Check biometrics when screen opens (only if locked)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometricsAuto();
    });
  }

  Future<void> _checkBiometricsAuto() async {
    final authState = ref.read(authNotifierProvider);
    if (authState.value == AuthStatus.locked) {
      // Small delay to allow UI to render
      await Future.delayed(const Duration(milliseconds: 500));
      final canBio = await ref.read(authNotifierProvider.notifier).canUseBiometrics();
      if (canBio) {
        _onBiometricsPressed();
      }
    }
  }

  void _onNumberPressed(String number) {
    if (_currentPin.length < 4) {
      setState(() {
        _isError = false;
        _currentPin += number;
      });

      if (_currentPin.length == 4) {
        _onPinComplete();
      }
    }
  }

  void _onBackspacePressed() {
    if (_currentPin.isNotEmpty) {
      setState(() {
        _isError = false;
        _currentPin = _currentPin.substring(0, _currentPin.length - 1);
      });
    }
  }

  Future<void> _onBiometricsPressed() async {
    final success = await ref.read(authNotifierProvider.notifier).unlockWithBiometrics();
    if (success) {
      // Navigation handled by router redirect usually, but good to be explicit or let router allow it
      // With our new router logic, state change triggers redirect to '/'
    }
  }

  Future<void> _onPinComplete() async {
    // Only Unlock Flow remains
    final success = await ref.read(authNotifierProvider.notifier).unlock(_currentPin);
    if (!success) {
      _triggerError();
    }
  }

  void _triggerError() async {
    setState(() {
      _isError = true;
    });
    
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate();
    }

    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _currentPin = '';
        _isError = false;
      });
    }
  }

  String _getTitle() {
    return 'Digite seu código';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF141915), // Dark background
      body: authState.when(
        data: (status) {
          if (status == AuthStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // If already authenticated, should have redirected, but safe check
          if (status == AuthStatus.authenticated) {
             // context.go('/'); // Handled in listener usually
             return const SizedBox.shrink();
          }

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 48),
                // Logo
                Image.asset(
                  'assets/images/logo_fundo_transparente.png',
                  height: 60,
                ),
                const SizedBox(height: 24),
                // Welcome Message (Static for now, can come from User repo later)
                Text(
                  'Bem-vindo ao Gradus',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  _getTitle(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                // Pin Dots
                PinDots(
                  pinLength: 4,
                  currentLength: _currentPin.length,
                  isError: _isError,
                ),
                const Spacer(),
                // Keyboard
                FutureBuilder<bool>(
                  future: ref.read(authNotifierProvider.notifier).canUseBiometrics(),
                  builder: (context, snapshot) {
                    final canBio = snapshot.data ?? false;
                    // Only show bio button in Unlock mode
                    final showBio = status == AuthStatus.locked && canBio;
                    
                    return NumericKeyboard(
                      onNumberPressed: _onNumberPressed,
                      onBackspacePressed: _onBackspacePressed,
                      onBiometricsPressed: showBio ? _onBiometricsPressed : null,
                      showBiometrics: showBio,
                    );
                  }
                ),
                const SizedBox(height: 24),
                // Forgot Code (Only for locked)
                if (status == AuthStatus.locked)
                  TextButton(
                    onPressed: () async {
                      final success = await ref.read(authNotifierProvider.notifier).recoverWithGoogle();
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Identidade confirmada. Crie seu novo PIN.')),
                        );
                      } else {
                        // Show Critical Alert
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF1E1E1E),
                            title: Text(
                              'Conta incorreta',
                              style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              'A conta autenticada não corresponde à conta original ou ocorreu um erro. Para acessar, será necessário resetar o aplicativo e perder os dados locais.',
                              style: GoogleFonts.spaceGrotesk(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Cancel
                                },
                                child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await ref.read(authNotifierProvider.notifier).resetApp();
                                },
                                child: const Text('Resetar App', style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Esqueci meu código',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        color: Colors.white54,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                else
                   // Space to balance layout
                   const SizedBox(height: 48),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err', style: const TextStyle(color: Colors.white))),
      ),
    );
  }
}
