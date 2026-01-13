import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradus/presentation/controllers/analysis_controller.dart';
import 'package:intl/intl.dart';

class AnalysisDateFilterModal extends ConsumerWidget {
  const AnalysisDateFilterModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrar por Período',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildOption(context, ref, 'Último Mês (30 dias)', 30),
          _buildOption(context, ref, 'Último Trimestre (90 dias)', 90),
          _buildOption(context, ref, 'Último Semestre (180 dias)', 180),
          _buildOption(context, ref, 'Último Ano (365 dias)', 365),
          const Divider(color: Colors.white10),
          _buildOption(context, ref, 'Todo o Período (Desde 2020)', null), // Null = All Time
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Color(0xFF9AFF1A)),
            title: const Text('Intervalo Personalizado...', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pop(context); // Close sheet first
              final initialRange = ref.read(analysisDateRangeProvider) ?? 
                                   DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), end: DateTime.now());
              
              final newRange = await showDateRangePicker(
                 context: context, 
                 initialDateRange: initialRange,
                 firstDate: DateTime(2020), 
                 lastDate: DateTime.now(),
                 builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
              );
              
              if (newRange != null) {
                 ref.read(analysisDateRangeProvider.notifier).state = newRange;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, WidgetRef ref, String label, int? days) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white70)),
      onTap: () {
        if (days == null) {
          // All Time -> Set to Null (Controller handles as All Time)
          ref.read(analysisDateRangeProvider.notifier).state = null;
        } else {
          final now = DateTime.now();
          ref.read(analysisDateRangeProvider.notifier).state = DateTimeRange(
            start: now.subtract(Duration(days: days)),
            end: now,
          );
        }
        Navigator.pop(context);
      },
    );
  }
}
