import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/security_controller.dart';
import '../../widgets/auth/pin_screen.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(securityControllerProvider);
    final controller = ref.read(securityControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: Text('Segurança', style: GoogleFonts.spaceGrotesk(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
            _buildSectionTitle('Acesso'),
            const SizedBox(height: 16),
            
            // Biometrics Toggle
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Entrar com Biometria', style: TextStyle(color: Colors.white)),
              subtitle: const Text('FaceID, TouchID ou Impressão Digital', style: TextStyle(color: Colors.grey, fontSize: 12)),
              trailing: Switch(
                value: state.isBiometricsEnabled,
                activeColor: const Color(0xFF9DF425),
                onChanged: state.canCheckBiometrics 
                  ? (val) => controller.toggleBiometrics(val)
                  : null, // Disabled if device doesn't support
              ),
            ),
            
            Divider(color: Colors.grey.withOpacity(0.2)),

            // Change PIN
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Alterar PIN', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PinScreen(mode: PinMode.change))
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF9DF425),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}
