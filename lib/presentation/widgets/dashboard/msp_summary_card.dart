import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/dashboard_providers.dart';

class MspSummaryCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const MspSummaryCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(mspSummaryStateProvider);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    
    // Calculate percentages
    final double saldoGeralPct = summary.totalMsp == 0 ? 0 : (summary.saldoGeral / summary.totalMsp);
    final double caixinhasPct = summary.totalMsp == 0 ? 0 : (summary.totalCaixinhas / summary.totalMsp);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color(0xFF1C1C1E), // Dark Gray, slightly lighter than background
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text(
                    'Meu Saldo Pessoal (MSP)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.savings_outlined, color: Color(0xFF9DF425), size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
                      text: _formatValue(summary.totalMsp),
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ',${_formatCents(summary.totalMsp)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Custom Progress Bar
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white10, // Track color
                ),
                child: Row(
                  children: [
                    if (summary.totalMsp > 0)
                      Flexible(
                        flex: (saldoGeralPct * 100).toInt(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF9DF425),
                            // If caixinhas is 0, this needs right radius too.
                            borderRadius: BorderRadius.horizontal(
                              left: const Radius.circular(6),
                              right: caixinhasPct == 0 ? const Radius.circular(6) : Radius.zero,
                            ),
                          ),
                        ),
                      ),
                    if (summary.totalMsp > 0 && caixinhasPct > 0)
                      Flexible(
                        flex: (caixinhasPct * 100).toInt(),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white24, // Darker/Dimmed color for Caixinhas
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(6)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   _buildLegendItem(
                    color: const Color(0xFF9DF425),
                    label: 'Saldo Geral (${(saldoGeralPct * 100).toStringAsFixed(0)}%)',
                  ),
                  _buildLegendItem(
                    color: Colors.white24,
                    label: 'Caixinhas (${(caixinhasPct * 100).toStringAsFixed(0)}%)',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatValue(double value) {
    final fmt = NumberFormat.decimalPattern('pt_BR');
    return fmt.format(value.floor());
  }

  String _formatCents(double value) {
    return (value * 100).remainder(100).toInt().toString().padLeft(2, '0');
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
