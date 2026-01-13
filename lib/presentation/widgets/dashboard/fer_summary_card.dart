import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/dashboard_providers.dart';
import '../../controllers/commitment_controller.dart';

class FerSummaryCard extends ConsumerWidget {
  const FerSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(ferSummaryStateProvider);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color(0xFF1E4D25), // Updated background color
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          // Navigate to FER Detail Screen
          final GoRouter router = GoRouter.of(context);
          router.push('/fer-detail');
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fundo Escada Rolante (FER)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.trending_up, color: Color(0xFF9DF425), size: 20),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Disponível',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: currencyFormat.currencySymbol,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: _formatValue(summary.saldoDisponivel),
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ',${_formatCents(summary.saldoDisponivel)}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0), // Move down slightly
                  child: _buildHealthIndicator(summary.saudeFundo),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildInfoColumn(
                  context, ref,
                  'Patrimônio Total',
                  currencyFormat.format(summary.patrimonioTotal),
                  false,
                ),
                const SizedBox(width: 40),
                _buildInfoColumn(
                  context, ref,
                  'Emprestado',
                  currencyFormat.format(summary.totalEmprestado),
                  true, // Enable debug on this column
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  String _formatValue(double value) {
    final fmt = NumberFormat.decimalPattern('pt_BR');
    return fmt.format(value.floor());
  }

  String _formatCents(double value) {
    return (value * 100).remainder(100).toInt().toString().padLeft(2, '0');
  }

  Widget _buildInfoColumn(BuildContext context, WidgetRef ref, String label, String value, bool isDebugTarget) {
    return InkWell(
      onLongPress: isDebugTarget ? () async {
        // Debug Action: List and Clean Ghost Loans
        final controller = ref.read(commitmentControllerProvider.notifier);
        final activeLoans = await controller.debugFetchActiveLoans();
        
        if (context.mounted) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Debug: Empréstimos Ativos', style: TextStyle(color: Colors.red)),
                content: SizedBox(
                   width: double.maxFinite,
                   child: activeLoans.isEmpty 
                      ? const Text('Nenhum empréstimo encontrado no banco de dados.')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: activeLoans.length,
                          itemBuilder: (c, i) {
                             final l = activeLoans[i];
                             return ListTile(
                                title: Text(l.proposito ?? 'Sem descrição'),
                                subtitle: Text('Saldo Devedor: R\$ ${l.saldoDevedorAtual.toStringAsFixed(2)}'),
                                trailing: IconButton(
                                   icon: const Icon(Icons.delete, color: Colors.red),
                                   onPressed: () async {
                                      Navigator.pop(ctx); // Close dialog to refresh (simple way)
                                      await controller.debugForceDeleteLoan(l.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                         const SnackBar(content: Text('Empréstimo (Fantasma) excluído e saldo estornado!'))
                                      );
                                   },
                                ),
                             );
                          },
                        ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('FECHAR')),
                ],
              ),
            );
        }
      } : null,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ));
  }

  Widget _buildHealthIndicator(double health) {
    final percentage = (health * 100).toInt();
    // Updated color from request
    const color = Color(0xFF9DF425); 

    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        children: [
          // Background track
           SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: 1.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white10),
              strokeWidth: 6,
            ),
          ),
          // Progress
          SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: health,
              valueColor: const AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
            ),
          ),
           Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   '$percentage%',
                   style: const TextStyle(
                     color: Colors.white,
                     fontWeight: FontWeight.bold,
                     fontSize: 14,
                   ),
                 ),
                 const Text(
                   'Saúde',
                   style: TextStyle(
                     color: Colors.white54,
                     fontSize: 10,
                   ),
                 ),
               ],
             ),
           )
        ],
      ),
    );
  }



}
