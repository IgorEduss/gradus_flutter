import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gradus/presentation/controllers/analysis_controller.dart'; // For MspUsageStats

class MspUsageCard extends StatelessWidget {
  final MspUsageStats stats;

  const MspUsageCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // If no spending at all, don't show (or show empty state?)
    if (stats.totalSpent == 0 && stats.totalAmortized == 0) return const SizedBox.shrink();

    final total = stats.totalSpent + stats.totalAmortized;
    final amortizationPercent = total > 0 ? (stats.totalAmortized / total) : 0.0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            const Text('Análise de Uso do MSP', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
               children: [
                   Expanded(
                       child: _StatColumn(
                           label: 'Amortização', 
                           amount: stats.totalAmortized, 
                           color: const Color(0xFF9AFF1A), // Green
                       )
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                       child: _StatColumn(
                           label: 'Gastos Gerais', 
                           amount: stats.totalSpent, 
                           color: Colors.orangeAccent,
                       )
                   ),
               ],
            ),
            const SizedBox(height: 16),
            Container(
               height: 8,
               decoration: BoxDecoration(
                   color: Colors.grey[800],
                   borderRadius: BorderRadius.circular(4),
               ),
               child: Row(
                   children: [
                       Flexible(
                           flex: (amortizationPercent * 100).toInt(),
                           child: Container(
                               decoration: const BoxDecoration(
                                   color: Color(0xFF9AFF1A),
                                   borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
                               ),
                           ),
                       ),
                        Flexible(
                           flex: ((1.0 - amortizationPercent) * 100).toInt(),
                           child: Container(
                               decoration: const BoxDecoration(
                                   color: Colors.orangeAccent,
                                   borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                               ),
                           ),
                       ),
                   ],
               ),
            ),
            const SizedBox(height: 8),
            Text(
                '${(amortizationPercent * 100).toStringAsFixed(0)}% do uso foi estratégico (pagamento de dívidas).',
                style: const TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic),
            ),
         ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
    final String label;
    final double amount;
    final Color color;
    
    const _StatColumn({required this.label, required this.amount, required this.color});
    
    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                    NumberFormat.compactSimpleCurrency(locale: 'pt_BR').format(amount),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
            ],
        );
    }
}
