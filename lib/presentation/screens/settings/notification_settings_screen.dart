import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/notification_service.dart';
import '../../providers/user_provider.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  // Simple local state for now, ideally strictly checking permission status
  bool _remindersEnabled = true;

  @override
  void initState() {
    super.initState();
    // In a real app we would check SharedPreferences or SecureStorage
    // For now, default true
  }

  @override
  Widget build(BuildContext context) {
    // Watch user provider to get review day
    final userAsync = ref.watch(usuarioProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: Text('Notificações', style: GoogleFonts.spaceGrotesk(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
            const Text(
              'Fique no controle da sua Escada Rolante recebendo lembretes importantes.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Lembretes de Revisão', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                userAsync.value != null 
                  ? 'Seja avisado todo dia ${userAsync.value!.diaRevisaoMensal}' 
                  : 'Seja avisado no dia da sua revisão mensal',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              value: _remindersEnabled,
              activeColor: const Color(0xFF9DF425),
              onChanged: (val) async {
                 setState(() => _remindersEnabled = val);
                 if (val) {
                   await NotificationService().requestPermissions();
                   
                   final user = userAsync.value;
                   if (user != null) {
                     await NotificationService().scheduleMonthlyReminder(
                       dayOfMonth: user.diaRevisaoMensal,
                       hour: 9, // Default to 9 AM
                       title: 'Hora de Subir de Nível! 🚀',
                       body: 'Hoje é o dia da sua Revisão Mensal. Dedique alguns minutos ao seu futuro.'
                     );
                     if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lembrete agendado!')));
                     }
                   }
                 } else {
                   await NotificationService().cancelAll();
                   if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lembretes desativados.')));
                   }
                 }
              },
            ),
            
            // We could add Time Picker here later
        ],
      ),
    );
  }
}
