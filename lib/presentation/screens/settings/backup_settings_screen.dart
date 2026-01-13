import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import '../../controllers/backup_controller.dart';

class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backupControllerProvider);
    final controller = ref.read(backupControllerProvider.notifier);

    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: Text('Backup em Nuvem', style: GoogleFonts.spaceGrotesk(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Status'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF323232),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.cloud_done, color: Color(0xFF9DF425)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Último Backup',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        state.when(
                          data: (date) => Text(
                            date != null ? dateFormatter.format(date) : 'Nunca realizado',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          loading: () => const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF9DF425)),
                          ),
                          error: (e, stack) => Text(
                            'Erro: $e',
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Ações'),
            const SizedBox(height: 16),

            // Backup Button
            ElevatedButton(
              onPressed: state.isLoading 
                ? null 
                : () async {
                  await controller.backup();
                  if (context.mounted) {
                    if (ref.read(backupControllerProvider).hasError) {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Falha ao realizar backup. Verifique o erro.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Backup realizado com sucesso!')),
                      );
                    }
                  }
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9DF425),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: state.isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : const Text('Fazer Backup Agora', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            
            const SizedBox(height: 16),

            // Restore Button
            OutlinedButton(
              onPressed: state.isLoading 
                ? null 
                : () => _showRestoreConfirmation(context, controller),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Restaurar Backup'),
            ),

            const SizedBox(height: 16),
            const Text(
              'A restauração substituirá todos os dados atuais do aplicativo pela versão salva no Google Drive. Essa ação é irreversível.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showRestoreConfirmation(BuildContext context, dynamic controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Restaurar Backup?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Deseja realmente restaurar os dados? Todos os dados atuais serão PERDIDOS e substituídos pela versão da nuvem.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close confirm dialog
              
              // Perform restore
              await controller.restore();
              
              if (context.mounted) {
                 // Show Blocking Success Dialog
                 showDialog(
                   context: context,
                   barrierDismissible: false,
                   builder: (context) => AlertDialog(
                     backgroundColor: const Color(0xFF1E1E1E),
                     title: const Text('Restauração Concluída', style: TextStyle(color: Color(0xFF9DF425))),
                     content: const Text(
                       'O banco de dados foi recuperado com sucesso.\n\nPara aplicar as alterações e evitar erros, é necessário REINICIAR o aplicativo agora.',
                       style: TextStyle(color: Colors.white),
                     ),
                     actions: [
                       TextButton(
                         onPressed: () async {
                           // Soft Restart App
                           await RestartWidget.restartApp(context);
                         },
                         child: const Text('REINICIAR AGORA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                       ),
                     ],
                   ),
                 );
              }
            },
            child: const Text('Confirmar', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
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
