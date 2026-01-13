import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gradus/domain/entities/emprestimo.dart';

class LoanReportCard extends StatelessWidget {
  final List<Emprestimo> loans;

  const LoanReportCard({super.key, required this.loans});

  @override
  Widget build(BuildContext context) {
    if (loans.isEmpty) return const SizedBox.shrink();

    final totalDebt = loans.fold(0.0, (sum, item) => sum + item.saldoDevedorAtual);
    final totalOriginal = loans.fold(0.0, (sum, item) => sum + item.valorConcedido);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ExpansionTile(
        shape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: const Text(
          'Total em Empréstimos',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        subtitle: Text(
          NumberFormat.currency(symbol: 'R\$', locale: 'pt_BR').format(totalDebt),
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GlobalStatRow(
                  label: 'Valor Original Concedido', 
                  value: NumberFormat.currency(symbol: 'R\$', locale: 'pt_BR').format(totalOriginal)
                ),
                const SizedBox(height: 4),
                _GlobalStatRow(
                  label: 'Já Quitado',
                  value: NumberFormat.currency(symbol: 'R\$', locale: 'pt_BR').format(totalOriginal - totalDebt), // Simplistic calc
                  valueColor: const Color(0xFF9AFF1A),
                ),
                const Divider(color: Colors.white10, height: 24),
                const Text('Empréstimos Ativos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...loans.map((loan) => _LoanItem(loan: loan)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobalStatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _GlobalStatRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        Text(value, style: TextStyle(color: valueColor ?? Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _LoanItem extends StatelessWidget {
  final Emprestimo loan;

  const _LoanItem({required this.loan});

  @override
  Widget build(BuildContext context) {
    final percentPaid = 1.0 - (loan.saldoDevedorAtual / loan.valorConcedido);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loan.proposito ?? 'Empréstimo #${loan.id}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(loan.dataConcessao),
                style: const TextStyle(color: Colors.white30, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Devedor: ${NumberFormat.currency(symbol: 'R\$').format(loan.saldoDevedorAtual)}',
                 style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
               Text(
                'Original: ${NumberFormat.compactSimpleCurrency(locale: 'pt_BR').format(loan.valorConcedido)}',
                 style: const TextStyle(color: Colors.white30, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentPaid.clamp(0.0, 1.0),
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF9AFF1A)),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
}
