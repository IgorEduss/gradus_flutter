import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:gradus/domain/entities/transacao.dart';
import 'package:gradus/domain/repositories/i_transacao_repository.dart';
import 'package:gradus/domain/repositories/i_fundo_repository.dart';
import 'package:gradus/domain/repositories/i_emprestimo_repository.dart';
import 'package:gradus/domain/entities/emprestimo.dart';
import 'package:gradus/presentation/providers/user_provider.dart';

part 'analysis_controller.g.dart';

@riverpod
class AnalysisController extends _$AnalysisController {
  @override
  FutureOr<AnalysisState> build() async {
    return _fetchData();
  }

  Future<AnalysisState> _fetchData() async {
    final transacaoRepo = GetIt.I<ITransacaoRepository>();
    final fundoRepo = GetIt.I<IFundoRepository>();
    final user = await ref.watch(usuarioProvider.future);

    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    // 1. Fetch Current Balances
    final fer = await fundoRepo.getFundo('FER');
    final msp = await fundoRepo.getFundo('MSP');

    if (fer == null || msp == null) {
      throw Exception('Fundos não encontrados');
    }

    // 2. Fetch Transactions
    final dateRange = ref.watch(analysisDateRangeProvider);
    final type = ref.watch(analysisTypeProvider);
    final fundId = ref.watch(analysisFundProvider);

    final now = DateTime.now();
    // Default to All Time (2020) if no range, otherwise range start
    // Note: Provider initializes with 180 days. Null means explicitly cleared -> All Time.
    final start = dateRange?.start ?? DateTime(2020, 1, 1);
    final end = dateRange?.end ?? now;
    
    // We fetch a bit more/all to ensure we can go back?
    // Let's rely on repository logic.
    final transacoes = await transacaoRepo.getExtrato(
      inicio: start, 
      fim: end,
      tipoTransacao: type,
      fundoId: fundId,
    );
    
    // Sort transactions by date descending for backward calculation
    transacoes.sort((a, b) => b.dataTransacao.compareTo(a.dataTransacao));

    // 3. Calculate Evolution Points
    final evolutionPoints = _calculatePoints(transacoes, fer.saldoAtual, msp.saldoAtual, start, now, ferId: fer.id, mspId: msp.id);
    
    // 4. Fetch Active Loans
    final emprestimoRepo = GetIt.I<IEmprestimoRepository>();
    final activeLoans = await emprestimoRepo.getEmprestimosAtivos();
    
    // 5. Calculate MSP Usage Stats (from the fetched transactions)
    double mspSpent = 0;
    double mspAmortized = 0;
    
    // We iterate over the fetched transactions (which respect date filter)
    for (final t in transacoes) {
        // Only count SAIDA from MSP
        if (t.tipoTransacao == 'SAIDA' && t.fundoPrincipalOrigemId == msp.id) {
            if (t.emprestimoId != null || t.tipoTransacao == 'RESSARCIMENTO_EMPRESTIMO') { 
                // Note: SAIDA + EmprestimoId or explicit type implies amortization.
                // In generic usage, simple SAIDA from MSP with loan ID attached is amortization.
                mspAmortized += t.valor;
            } else {
                mspSpent += t.valor;
            }
        }
    }

    return AnalysisState(
      currentFerBalance: fer.saldoAtual,
      currentMspBalance: msp.saldoAtual,
      transactions: transacoes,
      evolutionPoints: evolutionPoints,
      activeLoans: activeLoans,
      mspStats: MspUsageStats(totalSpent: mspSpent, totalAmortized: mspAmortized),
    );
  }

  List<BalancePoint> _calculatePoints(
    List<Transacao> transactions, 
    double currentFer, 
    double currentMsp, 
    DateTime start, 
    DateTime end,
    {required int ferId, required int mspId}
  ) {
      List<BalancePoint> points = [];
      double runningFer = currentFer;
      double runningMsp = currentMsp;
      
      DateTime currentDay = DateTime(end.year, end.month, end.day);
      final stopDay = DateTime(start.year, start.month, start.day);
      
      int transIdx = 0;
      
      points.add(BalancePoint(currentDay, runningFer, runningMsp));

      while (currentDay.isAfter(stopDay) || currentDay.isAtSameMomentAs(stopDay)) {
          if (currentDay.difference(stopDay).inDays < 0) break; // Safety

          while (transIdx < transactions.length) {
              final t = transactions[transIdx];
              final tDate = DateTime(t.dataTransacao.year, t.dataTransacao.month, t.dataTransacao.day);
              
              if (tDate.isAfter(currentDay)) {
                  transIdx++; // Skip future transactions (shouldn't happen with sorted DESC but safe)
                  continue;
              }
              
              if (tDate.isBefore(currentDay)) {
                  break; // Belongs to next day iteration
              }
              
              // Same Day: Reverse it
              _reverseTransaction(t, ferId, mspId, (diff) => runningFer += diff, (diff) => runningMsp += diff);
              transIdx++;
          }
          
          currentDay = currentDay.subtract(const Duration(days: 1));
          points.add(BalancePoint(currentDay, runningFer, runningMsp));
      }
      
      return points.reversed.toList();
  }

  void _reverseTransaction(Transacao t, int ferId, int mspId, Function(double) adjustFer, Function(double) adjustMsp) {
      // Logic:
      // ENTRADA (+Val): Reverse is (-Val)
      // SAIDA (-Val): Reverse is (+Val)
      
      double val = t.valor;
      
      if (t.tipoTransacao == 'ENTRADA') {
          // Money entered Destino. Reverse: Remove from Destino.
          if (t.fundoPrincipalDestinoId == ferId) adjustFer(-val);
          else if (t.fundoPrincipalDestinoId == mspId) adjustMsp(-val);
          // Also check for transfer logic? "Transferencia" means Out from Orig, In to Dest?
          // If pure Entrada, Orig might be null.
      } else if (t.tipoTransacao == 'SAIDA') {
          // Money left Origem. Reverse: Add back to Origem.
          if (t.fundoPrincipalOrigemId == ferId) adjustFer(val);
          else if (t.fundoPrincipalOrigemId == mspId) adjustMsp(val);
      }
      // If TRANSFERENCIA, handle both sides?
      // Usually Transacao table rows are atomic or paired?
      // Current system seems to use simpler types.
      // Assuming straightforward for now.
  }
}

class AnalysisState {
  final double currentFerBalance;
  final double currentMspBalance;
  final List<Transacao> transactions;
  final List<BalancePoint> evolutionPoints;
  final List<Emprestimo> activeLoans;
  final MspUsageStats mspStats;

  AnalysisState({
    required this.currentFerBalance,
    required this.currentMspBalance,
    required this.transactions,
    required this.evolutionPoints,
    required this.activeLoans,
    required this.mspStats,
  });
}

class MspUsageStats {
  final double totalSpent;
  final double totalAmortized; // Paid towards loans
  
  MspUsageStats({required this.totalSpent, required this.totalAmortized});
}

class BalancePoint {
    final DateTime date;
    final double fer;
    final double msp;
    
    BalancePoint(this.date, this.fer, this.msp);
}

// Filter Providers
final analysisDateRangeProvider = StateProvider<DateTimeRange?>((ref) {
  final now = DateTime.now();
  return DateTimeRange(start: now.subtract(const Duration(days: 180)), end: now);
});

final analysisTypeProvider = StateProvider<String?>((ref) => null);

final analysisFundProvider = StateProvider<int?>((ref) => null); // null = All, otherwise ID
