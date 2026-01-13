import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../../domain/repositories/i_usuario_repository.dart';
import '../../../domain/entities/usuario.dart';
import '../settings/conciliation_screen.dart';
import 'edit_profile_screen.dart';
import '../settings/security_settings_screen.dart';
import '../settings/notification_settings_screen.dart';
import '../settings/inflation_settings_screen.dart';
import '../settings/backup_settings_screen.dart';
import '../../providers/auth_provider.dart';
import '../../controllers/security_controller.dart';
import '../../widgets/auth/pin_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Usuario? _usuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final repo = GetIt.I<IUsuarioRepository>();
      final user = await repo.getUsuario(); // Default ID (Single User)
      if (mounted) {
        setState(() {
          _usuario = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   // Profile Header
                     Container(
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: const Color(0xFF1C1C1E),
                       borderRadius: BorderRadius.circular(20),
                       border: Border.all(color: Colors.white10),
                     ),
                     child: Row(
                       children: [
                         Container(
                           width: 60,
                           height: 60,
                           decoration: BoxDecoration(
                             color: const Color(0xFF9DF425).withOpacity(0.2),
                             shape: BoxShape.circle,
                           ),
                           child: const Icon(Icons.person, color: Color(0xFF9DF425), size: 30),
                         ),
                         const SizedBox(width: 16),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 _usuario?.nome ?? 'Usuário',
                                 style: const TextStyle(
                                   color: Colors.white,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                               const SizedBox(height: 4),
                                 _usuario == null 
                                   ? const SizedBox.shrink() 
                                   : InkWell(
                                     onTap: () async {
                                        final bool? result = await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => EditProfileScreen(usuario: _usuario!)
                                          )
                                        );
                                        if (result == true) {
                                          _loadUser(); // Refresh UI
                                        }
                                     },
                                     child: const Row(
                                       children: [
                                         Text(
                                           'Editar Perfil',
                                           style: TextStyle(color: Color(0xFF9DF425), fontSize: 14, fontWeight: FontWeight.bold),
                                         ),
                                         SizedBox(width: 4),
                                         Icon(Icons.edit, size: 14, color: Color(0xFF9DF425)),
                                       ],
                                     ),
                                   ),
                             ],
                           ),
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height: 32),
                   
                   // Menu Section
                   _buildSectionHeader('Configurações'),
                   _buildMenuItem(
                     icon: Icons.sync_alt,
                     title: 'Conciliar Saldos',
                     subtitle: 'Ajuste divergências entre saldo real e virtual',
                     onTap: () {
                       Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ConciliationScreen()),
                       );
                     },
                   ),
                   _buildMenuItem(
              icon: Icons.notifications_none,
              title: 'Notificações',
              subtitle: 'Gerencie seus alertas',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())
                );
              },
            ),

            _buildMenuItem(
              icon: Icons.cloud_upload,
              title: 'Backup em Nuvem',
              subtitle: 'Salvar/Restaurar do Google Drive',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BackupSettingsScreen())
                );
              },
            ),
             _buildMenuItem(
              icon: Icons.trending_up,
              title: 'Ajuste de Inflação',
              subtitle: 'Entrada manual de IPCA',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InflationSettingsScreen())
                );
              },
            ),

                   const SizedBox(height: 24),
                   _buildSectionHeader('Suporte'),
                   _buildMenuItem(
                     icon: Icons.help_outline,
                     title: 'Ajuda e FAQ',
                     onTap: () {},
                   ),
                   _buildMenuItem(
                     icon: Icons.info_outline,
                     title: 'Sobre o Gradus',
                      onTap: () {
                         showAboutDialog(
                           context: context, 
                           applicationName: 'Gradus', 
                           applicationVersion: '1.0.0',
                           applicationLegalese: 'Copyright © 2025 Gradus'
                         );
                      },
                   ),

                   const SizedBox(height: 24),
                   _buildSectionHeader('Dados'),
                   _buildMenuItem(
                     icon: Icons.delete_forever,
                     title: 'Apagar Todos os Dados',
                     subtitle: 'Ação irreversível',
                     onTap: () async {
                        final controller = ref.read(securityControllerProvider.notifier);
                        
                        final confirmed = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => const PinScreen(mode: PinMode.verify)
                          )
                        );
                        
                        if (confirmed == true && context.mounted) {
                           final doubleCheck = await showDialog<bool>(
                             context: context,
                             builder: (context) => AlertDialog(
                               backgroundColor: const Color(0xFF1C1C1E),
                               title: const Text('Tem certeza absoluta?', style: TextStyle(color: Colors.white)),
                               content: const Text(
                                 'Isso apagará permanentemente todo o seu histórico financeiro, configurações e cadastro. Não há como recuperar.',
                                 style: TextStyle(color: Colors.white70),
                               ),
                               actions: [
                                 TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context, false)),
                                 TextButton(
                                   child: const Text('APAGAR TUDO', style: TextStyle(color: Colors.red)), 
                                   onPressed: () => Navigator.pop(context, true)
                                 ),
                               ],
                             )
                           );

                           if (doubleCheck == true) {
                              await controller.wipeAllData(ref);
                              await ref.read(authNotifierProvider.notifier).resetApp();
                           }
                        }
                     },
                   ),

                   const SizedBox(height: 40),
                   SizedBox(
                     width: double.infinity,
                     child: TextButton.icon(
                       onPressed: () {
                         ref.read(authNotifierProvider.notifier).logout();
                       },
                       icon: const Icon(Icons.logout, color: Colors.redAccent),
                       label: const Text('Sair do Aplicativo', style: TextStyle(color: Colors.redAccent)),
                       style: TextButton.styleFrom(
                         padding: const EdgeInsets.symmetric(vertical: 16),
                         backgroundColor: Colors.redAccent.withOpacity(0.1),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                       ),
                     ),
                   ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white70),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null 
          ? Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12))
          : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      ),
    );
  }
}
