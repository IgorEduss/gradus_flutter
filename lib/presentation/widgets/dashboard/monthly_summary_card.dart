import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/dashboard_providers.dart';
import '../../screens/monthly_cycle/monthly_cycle_screen.dart';

class MonthlySummaryCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const MonthlySummaryCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commitmentsAsync = ref.watch(monthlyCommitmentsProvider);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return commitmentsAsync.when(
      data: (commitments) {
        double totalAmount = 0;
        double totalFerFacilitador = 0;
        double totalFerEmprestimo = 0;
        double totalMsp = 0;

        for (var commitment in commitments) {
          totalAmount += commitment.valorParcela;
          if (commitment.tipoCompromisso == 'FACILITADOR_FER') {
            totalFerFacilitador += commitment.valorParcela;
          } else if (commitment.tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO') {
             totalFerEmprestimo += commitment.valorParcela;
          } else if (commitment.tipoCompromisso == 'DEPOSITO_MSP') {
             totalMsp += commitment.valorParcela;
          }
        }
        
        // Colors
        const colorFerFacilitador = Color(0xFF9DF425); // Lime
        const colorFerEmprestimo = Color(0xFF4CAF50); // Green
        const colorMsp = Colors.blueGrey;

        // Prepare Legend Data
        final legendItems = [
          _LegendItemData(
            label: 'FER (Facilitador)',
            value: currencyFormat.format(totalFerFacilitador),
            color: colorFerFacilitador,
          ),
          if (totalFerEmprestimo > 0)
            _LegendItemData(
              label: 'FER (Empréstimo)',
              value: currencyFormat.format(totalFerEmprestimo),
              color: colorFerEmprestimo,
            ),
          _LegendItemData(
            label: 'MSP',
            value: currencyFormat.format(totalMsp),
            color: colorMsp,
          ),
        ];

        return Card(
          color: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Colors.white10)),
          child: InkWell(
            onTap: onTap ?? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const MonthlyCycleScreen()),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Compromissos do Mês',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: Colors.white10, shape: BoxShape.circle),
                        child: const Icon(Icons.calendar_today_outlined,
                            color: Color(0xFF9DF425), size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currencyFormat.format(totalAmount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 8,
                      child: Row(
                        children: [
                          if (totalFerFacilitador > 0)
                            Expanded(
                              flex: (totalFerFacilitador * 100).toInt(),
                              child: Container(color: colorFerFacilitador),
                            ),
                          if (totalFerEmprestimo > 0)
                            Expanded(
                              flex: (totalFerEmprestimo * 100).toInt(),
                              child: Container(color: colorFerEmprestimo),
                            ),
                          if (totalMsp > 0)
                            Expanded(
                              flex: (totalMsp * 100).toInt(),
                              child: Container(color: colorMsp),
                            ),
                          // Handle unclassified but counted in total (safety)
                          if (totalAmount > (totalFerFacilitador + totalFerEmprestimo + totalMsp))
                            Expanded(
                              flex: ((totalAmount - totalFerFacilitador - totalFerEmprestimo - totalMsp) * 100).toInt(),
                              child: Container(color: Colors.grey),
                            ),
                           if (totalAmount == 0)
                            Expanded(child: Container(color: Colors.white10)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Legend UI
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1), 
                    },
                    children: [
                      // Row 1: Headers
                      TableRow(
                        children: legendItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0, right: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0), // Center align with first line text (size 11)
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: item.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      // Row 2: Values
                      TableRow(
                        children: legendItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 14.0, right: 8.0),
                            child: Text(
                              item.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SizedBox(
        height: 120,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ERRO DETALHADO: $err\nStack: $stack',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent, fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }

}

class _LegendItemData {
  final String label;
  final String value;
  final Color color;

  _LegendItemData({
    required this.label,
    required this.value,
    required this.color,
  });
}
