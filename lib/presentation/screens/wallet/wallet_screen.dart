import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/wallet_controller.dart';
import '../../../domain/entities/transacao.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletStateAsync = ref.watch(walletControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Minha Carteira',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: walletStateAsync.when(
        data: (walletData) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNetWorthCard(walletData),
                const SizedBox(height: 24),
                _buildAssetAllocationSection(walletData),
                const SizedBox(height: 24),
                _buildTransactionHistorySection(walletData.transactions),
                const SizedBox(height: 80), // For Fab/Nav
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildNetWorthCard(WalletData data) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patrimônio Líquido Total',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(data.totalNetWorth),
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetAllocationSection(WalletData data) {
    // Avoid division by zero
    final total = data.totalNetWorth == 0 ? 1.0 : data.totalNetWorth;

    final ferPercentage = (data.ferBalance / total) * 100;
    final mspPercentage = (data.mspAvailableBalance / total) * 100; // Only General MSP
    final caixinhasPercentage = (data.caixinhasBalance / total) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alocação de Ativos',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF9DF425), // FER (Green)
                        value: data.ferBalance,
                        title: '${ferPercentage.toStringAsFixed(0)}%',
                        radius: 40,
                        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                        showTitle: data.ferBalance > 0,
                      ),
                      PieChartSectionData(
                        color: Colors.blueAccent, // MSP (Blue)
                        value: data.mspAvailableBalance,
                        title: '${mspPercentage.toStringAsFixed(0)}%',
                        radius: 35,
                        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        showTitle: data.mspAvailableBalance > 0,
                      ),
                      PieChartSectionData(
                        color: Colors.purpleAccent, // Caixinhas (Purple)
                        value: data.caixinhasBalance,
                        title: '${caixinhasPercentage.toStringAsFixed(0)}%',
                        radius: 35,
                        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        showTitle: data.caixinhasBalance > 0,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(const Color(0xFF9DF425), 'Fundo (FER)', data.ferBalance),
                    const SizedBox(height: 12),
                    _buildLegendItem(Colors.blueAccent, 'MSP (Disponível)', data.mspAvailableBalance),
                    const SizedBox(height: 12),
                    _buildLegendItem(Colors.purpleAccent, 'Caixinhas (Metas)', data.caixinhasBalance),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, double value) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
                currencyFormat.format(value),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHistorySection(List<Transacao> transactions) {
     final dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');
     final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Extrato Geral',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
             TextButton(
              onPressed: () {}, // Could open full screen filter later
              child: const Text('Ver Filtros', style: TextStyle(color: Colors.white54)),
             )
          ],
        ),
        const SizedBox(height: 8),
        if (transactions.isEmpty)
           const Center(
             child: Padding(
               padding: EdgeInsets.all(32.0),
               child: Text('Nenhuma movimentação registrada', style: TextStyle(color: Colors.white38)),
             ),
           )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              // Determine visual style based on type
              // Assuming standard types or checking sign
              // A simple heuristic: standard entry types or just assume context.
              // Actually, Transacao usually doesn't have a rigid 'sign' field, depends on context (origem -> destino)
              // But typically Dashboard shows everything.
              // Let's rely on type checks or names.
              
              bool isPositive = t.tipoTransacao.contains('ENTRADA') || t.tipoTransacao.contains('APORTE') || t.tipoTransacao.contains('DEPOSITO') || t.tipoTransacao.contains('PAGAMENTO');
              // Loans are negative for FER? No, loans are assets for FER but money leaving.
              // Let's simpler:
              // Green for 'Good' things (Deposits, Payments), Red for 'Spending' or 'Loan outflow'
              
              Color iconColor = const Color(0xFF9DF425);
              IconData icon = Icons.arrow_downward;
              
              if (t.tipoTransacao == 'CONCESSAO_EMPRESTIMO') {
                 iconColor = Colors.orange;
                 icon = Icons.arrow_outward;
              } else if (t.tipoTransacao.contains('USO')) {
                 iconColor = Colors.redAccent;
                 icon = Icons.shopping_bag_outlined;
              } else if (t.tipoTransacao.contains('AJUSTE')) {
                 iconColor = Colors.blueAccent;
                 icon = Icons.tune;
              }
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  title: Text(
                    t.descricao,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '${dateFormat.format(t.dataTransacao)} • ${t.tipoTransacao.replaceAll('_', ' ')}',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  trailing: Text(
                    currencyFormat.format(t.valor),
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white, // Keep neutral or colorize? Neutral is cleaner for ledger.
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
