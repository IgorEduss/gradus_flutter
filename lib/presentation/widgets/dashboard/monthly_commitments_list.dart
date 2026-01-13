import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/dashboard_providers.dart';

class MonthlyCommitmentsList extends ConsumerWidget {
  final VoidCallback? onViewAll;

  const MonthlyCommitmentsList({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commitmentsAsync = ref.watch(monthlyCommitmentsProvider);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Compromissos do Mês',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              InkWell(
                onTap: onViewAll,
                child: const Text(
                  'Ver todos',
                  style: TextStyle(color: Color(0xFF9DF425), fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        commitmentsAsync.when(
          data: (commitments) {
            if (commitments.isEmpty) {
              return Card(
                color: const Color(0xFF1C1C1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Nenhum compromisso para este mês.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: commitments.length > 3 ? 3 : commitments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final commitment = commitments[index];
                return _buildCommitmentItem(commitment, currencyFormat);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.limeAccent)),
          error: (err, stack) => Text('Erro: $err', style: TextStyle(color: Colors.redAccent)),
        ),
      ],
    );
  }

  Widget _buildCommitmentItem(dynamic commitment, NumberFormat currencyFormat) {
    // Determine visuals based on type
    // Assuming commitment structure from provider
    String title = commitment.descricao;
    String subtitle = _mapTypeToSubtitle(commitment.tipoCompromisso);
    IconData iconData = Icons.receipt_long;
    Color iconColor = Colors.white;
    Color iconBgColor = Colors.white10;

    if (commitment.tipoCompromisso == 'FACILITADOR_FER') {
      iconData = Icons.wifi; // Example from screenshot (Internet)
      iconColor = Colors.blueAccent;
      iconBgColor = Colors.blueAccent.withOpacity(0.2);
    } else if (commitment.tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO' || 
               title.toLowerCase().contains('netflix')) {
      iconData = Icons.movie; // Example from screenshot
      iconColor = Colors.redAccent;
      iconBgColor = Colors.redAccent.withOpacity(0.2);
    } else {
      iconData = Icons.savings;
      iconColor = Colors.greenAccent;
      iconBgColor = Colors.greenAccent.withOpacity(0.2);
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "- ${currencyFormat.format(commitment.valorParcela)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _mapTypeToSubtitle(String type) {
    switch (type) {
      case 'FACILITADOR_FER':
        return 'Escada Rolante';
      case 'DEPOSITO_MSP':
        return 'Meu Saldo Pessoal';
      case 'RESSARCIMENTO_EMPRESTIMO':
        return 'Ressarcimento';
      default:
        return 'Compromisso';
    }
  }
}
