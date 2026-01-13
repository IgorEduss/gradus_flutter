import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/bootstrap_controller.dart';
import '../../widgets/transaction_modal.dart';
import '../../widgets/commitment_modal.dart';
import '../../widgets/msp_transaction_modal.dart';
import '../../widgets/loan_request_modal.dart';
import '../../widgets/dashboard/fer_summary_card.dart';
import '../../widgets/dashboard/msp_summary_card.dart';
import '../../widgets/dashboard/monthly_summary_card.dart';
import '../monthly_cycle/monthly_cycle_screen.dart';
import '../msp/msp_management_screen.dart';
import '../settings/conciliation_screen.dart';
import '../analysis/analysis_screen.dart';
import '../profile/profile_screen.dart';
import '../../../core/di/injection.dart';
import '../../../domain/repositories/i_compromisso_repository.dart';
import '../../../domain/entities/compromisso.dart';
import '../wallet/wallet_screen.dart';
// ... (rest of imports are fine) ...

// ... (skipping to replacement of methods) ...

  void _showMspTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MspTransactionModal(),
    );
  }

  void _showLoanRequestModal(BuildContext context) {
      showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LoanRequestModal(),
    );
  }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final exists = await ref.read(bootstrapControllerProvider.notifier).checkUserExists();
      if (!exists && mounted) {
        context.go('/onboarding');
      }
    });
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Allow custom container
      builder: (context) {
        return Container(
           decoration: const BoxDecoration(
            color: Color(0xFF1C1C1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Registrar Facilitador (Destaque)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9AFF1A).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_circle, color: Color(0xFF9AFF1A)),
                  ),
                  title: const Text(
                    'Registrar Facilitador',
                    style: TextStyle(
                      color: Color(0xFF9AFF1A), 
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: const Text('Novo compromisso para o FER', style: TextStyle(color: Colors.white54)),
                  onTap: () {
                    Navigator.pop(context);
                    // Open with Facilitador type pre-selected
                    _showCommitmentModal(context, type: 'FACILITADOR_FER');
                  },
                ),
                const Divider(color: Colors.white10),
                
                // 2. Solicitar Empréstimo
                ListTile(
                  leading: const Icon(Icons.handshake, color: Colors.orangeAccent),
                  title: const Text('Solicitar Empréstimo', style: TextStyle(color: Colors.white, fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    // Open Modal for Loan
                    _showCommitmentModal(context, type: 'RESSARCIMENTO_EMPRESTIMO');
                  },
                ),
                
                const Divider(color: Colors.white10),

                // 3. Movimentar Saldo Pessoal (MSP)
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet, color: Colors.blueAccent),
                  title: const Text('Movimentar Saldo Pessoal (MSP)', style: TextStyle(color: Colors.white, fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    _showMspTransactionModal(context);
                  },
                ),

                const Divider(color: Colors.white10),

                // 4. Conciliar Saldos
                ListTile(
                  leading: const Icon(Icons.sync_alt, color: Colors.purpleAccent),
                  title: const Text('Conciliar Saldos', style: TextStyle(color: Colors.white, fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ConciliationScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMspTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MspTransactionModal(),
    );
  }

  void _showLoanRequestModal(BuildContext context) {
      showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LoanRequestModal(),
    );
  }

  void _showTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Custom modal handles background
      builder: (context) => const TransactionModal(),
    );
  }

  void _showCommitmentModal(BuildContext context, {String? type}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommitmentModal(initialType: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: Text(
          'Meu Painel',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white, 
            fontSize: 28, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () => _showActionMenu(context),
          backgroundColor: const Color(0xFF9DF425),
          shape: const CircleBorder(),
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.black, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FerSummaryCard(),
            const SizedBox(height: 20),
            MspSummaryCard(
              onTap: () => context.go('/msp-management'),
            ),
            const SizedBox(height: 24),
            MonthlySummaryCard(
               onTap: () => context.go('/monthly-cycle'),
            ),
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }
}
