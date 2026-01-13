import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:gradus/presentation/controllers/analysis_controller.dart'; 
import 'package:google_fonts/google_fonts.dart';

class EvolutionChart extends StatelessWidget {
  final List<BalancePoint> points;

  const EvolutionChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Container(
        height: 250,
        alignment: Alignment.center,
        child: const Text('Sem dados suficientes', style: TextStyle(color: Colors.white54)),
      );
    }
    
    // Determine min/max Y for scaling
    double minY = points.map((e) => e.fer).reduce((a, b) => a < b ? a : b);
    double minMsp = points.map((e) => e.msp).reduce((a, b) => a < b ? a : b);
    if (minMsp < minY) minY = minMsp;
    
    double maxY = points.map((e) => e.fer).reduce((a, b) => a > b ? a : b);
    double maxMsp = points.map((e) => e.msp).reduce((a, b) => a > b ? a : b);
    if (maxMsp > maxY) maxY = maxMsp;
    
    // Add padding
    minY = (minY * 0.9).floorToDouble();
    maxY = (maxY * 1.1).ceilToDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('Evolução do Patrimônio', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, left: 12, top: 24, bottom: 12),
            child: LineChart(
               LineChartData(
                 gridData: FlGridData(
                   show: true,
                   drawVerticalLine: false,
                   getDrawingHorizontalLine: (value) => const FlLine(color: Colors.white10, strokeWidth: 1),
                 ),
                 titlesData: FlTitlesData(
                   show: true,
                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   leftTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       reservedSize: 40,
                       getTitlesWidget: (value, meta) {
                         if (value == minY || value == maxY) return const SizedBox.shrink();
                         return Text(
                           NumberFormat.compact().format(value),
                           style: const TextStyle(color: Colors.white30, fontSize: 10),
                         );
                       },
                     ),
                   ),
                   bottomTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       interval: (points.length / 4).ceilToDouble(), // Show ~4 labels
                       getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx < 0 || idx >= points.length) return const SizedBox.shrink();
                          final date = points[idx].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('dd/MM').format(date),
                              style: const TextStyle(color: Colors.white30, fontSize: 10),
                            ),
                          );
                       },
                     ),
                   ),
                 ),
                 borderData: FlBorderData(show: false),
                 minX: 0,
                 maxX: (points.length - 1).toDouble(),
                 minY: minY,
                 maxY: maxY,
                 lineTouchData: LineTouchData(
                   touchTooltipData: LineTouchTooltipData(
                     getTooltipColor: (touchedSpot) => const Color(0xFF1C1C1E),
                     getTooltipItems: (touchedSpots) {
                       return touchedSpots.map((spot) {
                          final isFer = spot.barIndex == 0;
                          return LineTooltipItem(
                            '${isFer ? "FER: " : "MSP: "}${NumberFormat.currency(symbol: "R\$").format(spot.y)}',
                             TextStyle(
                               color: isFer ? const Color(0xFF9AFF1A) : Colors.blueAccent,
                               fontWeight: FontWeight.bold,
                             ),
                          );
                       }).toList();
                     },
                   ),
                 ),
                 lineBarsData: [
                   // FER Line (Green)
                   LineChartBarData(
                     spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.fer)).toList(),
                     isCurved: true,
                     color: const Color(0xFF9AFF1A),
                     gradient: const LinearGradient(colors: [Color(0xFF9AFF1A), Color(0xFF6FBA10)]),
                     barWidth: 3,
                     dotData: const FlDotData(show: false),
                     belowBarData: BarAreaData(
                       show: true,
                       gradient: LinearGradient(
                         colors: [const Color(0xFF9AFF1A).withOpacity(0.2), Colors.transparent],
                         begin: Alignment.topCenter,
                         end: Alignment.bottomCenter,
                       ),
                     ),
                   ),
                   // MSP Line (Blue)
                   LineChartBarData(
                     spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.msp)).toList(),
                     isCurved: true,
                     color: Colors.blueAccent,
                     barWidth: 3,
                     dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                       show: true,
                       gradient: LinearGradient(
                         colors: [Colors.blueAccent.withOpacity(0.2), Colors.transparent],
                         begin: Alignment.topCenter,
                         end: Alignment.bottomCenter,
                       ),
                     ),
                   ),
                 ],
               ),
            ),
          ),
        ),
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               _LegendItem(color: const Color(0xFF9AFF1A), label: 'FER'),
               const SizedBox(width: 16),
               _LegendItem(color: Colors.blueAccent, label: 'MSP'),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
