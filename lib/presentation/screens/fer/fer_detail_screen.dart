import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../controllers/fer_detail_controller.dart';
import '../../controllers/commitment_controller.dart'; // For formatting utilities if needed
import '../../../domain/entities/transacao.dart';
import '../../../domain/entities/emprestimo.dart';

class FerDetailScreen extends ConsumerStatefulWidget {
  const FerDetailScreen({super.key});

  @override
  ConsumerState<FerDetailScreen> createState() => _FerDetailScreenState();
}

class _FerDetailScreenState extends ConsumerState<FerDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(ferDetailControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do FER'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: stateAsync.when(
        data: (state) => Column(
          children: [
            _buildChartSection(state.chartData),
            Expanded(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF9DF425),
                    labelColor: const Color(0xFF9DF425),
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Extrato'),
                      Tab(text: 'Empréstimos'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildExtratoTab(state.transacoes),
                        _buildEmprestimosTab(state.emprestimosAtivos),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
      ),
    );
  }

  Widget _buildChartSection(List<FlSpot> data) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // Slightly lighter detail card bg
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Evolução do Patrimônio',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          // Filter Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildFilterButton('1M', true),
              const SizedBox(width: 8),
              _buildFilterButton('6M', false),
              const SizedBox(width: 8),
              _buildFilterButton('1A', false),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    color: const Color(0xFF9DF425), // Primary Green
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF9DF425).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF9DF425) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade800),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF121212) : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildExtratoTab(List<Transacao> transacoes) {
    if (transacoes.isEmpty) {
      return const Center(child: Text('Nenhuma transação registrada.', style: TextStyle(color: Colors.grey)));
    }
    
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transacoes.length,
      itemBuilder: (context, index) {
        final t = transacoes[index];
        final isEntry = t.tipoTransacao == 'ENTRADA' || t.tipoTransacao == 'APORTE_INICIAL'; // Simplify logic
        
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isEntry ? const Color(0xFF1E4D25) : const Color(0xFF4D251E),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEntry ? Icons.arrow_upward : Icons.arrow_downward,
              color: isEntry ? const Color(0xFF9DF425) : Colors.orangeAccent,
              size: 20,
            ),
          ),
          title: Text(t.descricao, style: const TextStyle(color: Colors.white)),
          subtitle: Text(dateFormat.format(t.dataTransacao), style: const TextStyle(color: Colors.grey)),
          trailing: Text(
            currencyFormat.format(t.valor),
            style: TextStyle(
              color: isEntry ? const Color(0xFF9DF425) : Colors.orangeAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmprestimosTab(List<Emprestimo> emprestimos) {
    if (emprestimos.isEmpty) {
      return const Center(child: Text('Nenhum empréstimo ativo.', style: TextStyle(color: Colors.grey)));
    }

    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: emprestimos.length,
      itemBuilder: (context, index) {
        final e = emprestimos[index];
        return Card(
           margin: const EdgeInsets.only(bottom: 12),
           color: const Color(0xFF2C2C2C),
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
           child: Padding(
             padding: const EdgeInsets.all(16.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Expanded(child: Text(e.proposito ?? 'Empréstimo', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                       decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                       child: const Text('ATIVO', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                     )
                   ],
                 ),
                 const SizedBox(height: 12),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text('Valor Original', style: TextStyle(color: Colors.grey, fontSize: 12)),
                         Text(currencyFormat.format(e.valorConcedido), style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                       ],
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         const Text('Saldo Devedor', style: TextStyle(color: Colors.grey, fontSize: 12)),
                         Text(currencyFormat.format(e.saldoDevedorAtual), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                       ],
                     ),
                   ],
                 )
               ],
             ),
           ),
        );
      },
    );
  }
}
