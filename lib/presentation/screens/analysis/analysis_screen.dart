import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:gradus/presentation/controllers/analysis_controller.dart';
import '../../widgets/analysis/evolution_chart.dart';
import '../../widgets/analysis/transaction_history_list.dart';
import '../../widgets/analysis/loan_report_card.dart';
import '../../widgets/analysis/loan_report_card.dart';
import '../../widgets/analysis/msp_usage_card.dart';
import '../../widgets/analysis/analysis_date_filter_modal.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Análise e Relatórios',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
         color: const Color(0xFF141414),
         child: analysisState.when(
            data: (state) => CustomScrollView(
               slivers: [
                  SliverToBoxAdapter(
                     child: Padding(
                       padding: const EdgeInsets.only(bottom: 24),
                       child: Column(
                         children: [
                           EvolutionChart(points: state.evolutionPoints),
                           if (state.activeLoans.isNotEmpty)
                             LoanReportCard(loans: state.activeLoans),
                           MspUsageCard(stats: state.mspStats),
                         ],
                       ),
                     ),
                  ),
                  SliverToBoxAdapter(
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                       child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                  const Text('Extrato', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.filter_list, color: Colors.white),
                                    onPressed: () {
                                       // Toggle filter visibility or show modal
                                    },
                                  ),
                               ],
                             ),
                             const SizedBox(height: 8),
                             SingleChildScrollView(
                               scrollDirection: Axis.horizontal,
                               child: Row(
                                 children: [
                                    Consumer(
                                      builder: (context, ref, _) {
                                        final range = ref.watch(analysisDateRangeProvider);
                                        final label = range == null ? 'Todo o Período' : '${DateFormat('dd/MM').format(range.start)} - ${DateFormat('dd/MM').format(range.end)}';
                                        return _FilterChip(
                                          label: label, 
                                          isSelected: range != null, // If null, it's "All", so maybe not visually "selected" in green? OR maybe "Todo o Periodo" is a state? 
                                          // Let's say if it IS null (All), it is NOT selected (grey). If range is set, it is green.
                                          onTap: () {
                                             showModalBottomSheet(
                                               context: context,
                                               backgroundColor: Colors.transparent,
                                               builder: (context) => const AnalysisDateFilterModal(),
                                             );
                                          },
                                          onClear: range != null ? () {
                                            ref.read(analysisDateRangeProvider.notifier).state = null;
                                          } : null,
                                        );
                                      }
                                    ),
                                    const SizedBox(width: 8),
                                    Consumer(
                                      builder: (context, ref, _) {
                                        final type = ref.watch(analysisTypeProvider);
                                        return _FilterChip(
                                          label: type ?? 'Todos os Tipos', 
                                          isSelected: type != null, 
                                          onTap: () {
                                            // Mockup: Cycle types or show sheet
                                            if (type == null) ref.read(analysisTypeProvider.notifier).state = 'ENTRADA';
                                            else if (type == 'ENTRADA') ref.read(analysisTypeProvider.notifier).state = 'SAIDA';
                                            else ref.read(analysisTypeProvider.notifier).state = null;
                                          }
                                        );
                                      }
                                    ),
                                    const SizedBox(width: 8),
                                    Consumer(
                                      builder: (context, ref, _) {
                                        final fundId = ref.watch(analysisFundProvider);
                                        // We need to know which fund is which ID. For now assuming rigid IDs or just label.
                                        // Ideally fetch funds to get names.
                                        String label = 'Todas as Contas';
                                        // Quick hack: we don't have fund names here easily without fetching.
                                        // Let's just cycle for demo: All -> FER -> MSP -> All
                                        return _FilterChip(
                                          label: fundId == null ? 'Todas as Contas' : (fundId == 1 ? 'FER' : 'MSP'), // Assumption on IDs
                                          isSelected: fundId != null, 
                                          onTap: () {
                                             // Hacky cycle for now until we have proper lookup
                                             // Assuming FER=1, MSP=2 based on seed data usually.
                                             // Providing a proper selector is better.
                                             // For now: Toggle
                                             if (fundId == null) ref.read(analysisFundProvider.notifier).state = 1; // FER
                                             else if (fundId == 1) ref.read(analysisFundProvider.notifier).state = 2; // MSP
                                             else ref.read(analysisFundProvider.notifier).state = null;
                                          }
                                        );
                                      }
                                    ),
                                 ],
                               ),
                             ),
                          ],
                       ),
                     ),
                  ),
                  TransactionHistoryList(transactions: state.transactions),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
               ],
            ),
            loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF9AFF1A))),
            error: (err, stack) => Center(child: Text('Erro: $err', style: const TextStyle(color: Colors.red))),
         ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  
  const _FilterChip({required this.label, required this.isSelected, required this.onTap, this.onClear});
  
  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
           decoration: BoxDecoration(
             color: isSelected ? const Color(0xFF9AFF1A) : Colors.white10,
             borderRadius: BorderRadius.circular(20),
             border: Border.all(color: isSelected ? Colors.transparent : Colors.white24),
           ),
           child: Row(
             mainAxisSize: MainAxisSize.min,
             children: [
               Text(
                 label,
                 style: TextStyle(
                   color: isSelected ? Colors.black : Colors.white70,
                   fontSize: 12,
                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                 ),
               ),
               if (isSelected && onClear != null) ...[
                 const SizedBox(width: 4),
                 GestureDetector(
                   onTap: onClear,
                   child: const Icon(Icons.close, size: 14, color: Colors.black),
                 ),
               ],
             ],
           ),
        ),
      );
  }
}
