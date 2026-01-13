import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gradus/domain/entities/transacao.dart';

class TransactionHistoryList extends StatelessWidget {
  final List<Transacao> transactions;

  const TransactionHistoryList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text('Nenhuma transação no período', style: TextStyle(color: Colors.white54))),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final t = transactions[index];
          final isEntrada = t.tipoTransacao == 'ENTRADA';
          final color = isEntrada ? const Color(0xFF9AFF1A) : Colors.redAccent;
          final icon = isEntrada ? Icons.arrow_downward : Icons.arrow_upward;
          
          return Container( 
             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
             decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
             ),
             child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                title: Text(t.descricao, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(t.dataTransacao),
                  style: const TextStyle(color: Colors.white30, fontSize: 12),
                ),
                trailing: Text(
                  '${isEntrada ? "+" : "-"} ${NumberFormat.currency(symbol: "R\$", locale: 'pt_BR').format(t.valor)}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
             )
          );
        },
        childCount: transactions.length,
      ),
    );
  }
}
