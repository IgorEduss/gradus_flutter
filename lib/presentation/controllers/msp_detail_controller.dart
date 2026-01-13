import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/transacao.dart';
import '../../domain/repositories/i_transacao_repository.dart';
import '../../domain/repositories/i_fundo_repository.dart';
import '../../core/di/injection.dart';

part 'msp_detail_controller.g.dart';

class MspDetailState {
  final List<Transacao> transacoes;
  final List<FlSpot> chartData;
  final String activeFilter; // '1M', '6M', '1A'

  MspDetailState({
    required this.transacoes,
    required this.chartData,
    this.activeFilter = '1M',
  });

  MspDetailState copyWith({
    List<Transacao>? transacoes,
    List<FlSpot>? chartData,
    String? activeFilter,
  }) {
    return MspDetailState(
      transacoes: transacoes ?? this.transacoes,
      chartData: chartData ?? this.chartData,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

@riverpod
class MspDetailController extends _$MspDetailController {
  @override
  Stream<MspDetailState> build() async* {
    final transacaoRepository = getIt<ITransacaoRepository>();
    final fundoRepository = getIt<IFundoRepository>();

    // 1. Fetch Transactions
    final allTransacoes = await transacaoRepository.getExtrato(); 
    
    // 2. Identify MSP Fund ID
    final mspFundo = await fundoRepository.getFundo('MSP');
    final int mspId = mspFundo?.id ?? 2; // Fallback ID if not found, usually 2 for MSP
    
    final mspTransacoes = allTransacoes.where((t) {
        // Filter logic for MSP:
        // - Inflow to MSP (fundoDestino == MSP)
        // - Outflow from MSP (fundoOrigem == MSP, fundos might serve as source for payments too?)
        // - Check specific transaction types if needed, but ID matching is safer for 'Extrato'.
        
        final isDestino = t.fundoPrincipalDestinoId == mspId;
        final isOrigem = t.fundoPrincipalOrigemId == mspId;
        
        // Exclude internal system movements if necessary, but 'Extrato' usually shows everything relevant to balance.
        // For MSP, we care about:
        // - ENTRADA (Deposit)
        // - SAIDA (Spend)
        // - APORTE_CAIXINHA (Outflow to Caixinha? Or acts as sub-balance? Caixinhas are technically separate in 'Caixinha' table, but money moves out of MSP main balance.)
        // - RESGATE_CAIXINHA (Inflow from Caixinha deletion)
        
        return isDestino || isOrigem;
    }).toList();

    // 3. Generate Chart Data
    final chartData = _generateChartData(mspTransacoes, mspId);

    yield MspDetailState(
      transacoes: mspTransacoes, 
      chartData: chartData,
    );
  }

  List<FlSpot> _generateChartData(List<Transacao> transacoes, int mspId) {
    if (transacoes.isEmpty) return [];

    // Sort by date ASC
    final sorted = List<Transacao>.from(transacoes)..sort((a, b) => a.dataTransacao.compareTo(b.dataTransacao));
    
    // Group by Day
    Map<String, double> dailyBalance = {};
    double currentBalance = 0;
    
    for (var t in sorted) {
       double effect = 0;
       
       if (t.fundoPrincipalDestinoId == mspId) {
         effect += t.valor;
       }
       if (t.fundoPrincipalOrigemId == mspId) {
         effect -= t.valor;
       }
       
       currentBalance += effect;
       
       final dayKey = "${t.dataTransacao.year}-${t.dataTransacao.month}-${t.dataTransacao.day}";
       dailyBalance[dayKey] = currentBalance;
    }

    if (dailyBalance.isEmpty) return [];
    
    List<FlSpot> result = [];
    if (dailyBalance.length == 1) {
       result.add(const FlSpot(0, 0));
       result.add(FlSpot(1, dailyBalance.values.first));
       return result;
    }

    int index = 0;
    final sortedKeys = dailyBalance.keys.toList(); 
    for (var key in sortedKeys) {
       result.add(FlSpot(index.toDouble(), dailyBalance[key]!));
       index++;
    }
    
    return result;
  }
}
