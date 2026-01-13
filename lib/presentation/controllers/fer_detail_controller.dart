import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/transacao.dart';
import '../../domain/entities/emprestimo.dart';
import '../../domain/repositories/i_transacao_repository.dart';
import '../../domain/repositories/i_emprestimo_repository.dart';
import '../../domain/repositories/i_fundo_repository.dart';
import '../../core/di/injection.dart';

part 'fer_detail_controller.g.dart';

class FerDetailState {
  final List<Transacao> transacoes;
  final List<Emprestimo> emprestimosAtivos;
  final List<FlSpot> chartData;
  final String activeFilter; // '1M', '6M', '1A'

  FerDetailState({
    required this.transacoes,
    required this.emprestimosAtivos,
    required this.chartData,
    this.activeFilter = '1M',
  });

  FerDetailState copyWith({
    List<Transacao>? transacoes,
    List<Emprestimo>? emprestimosAtivos,
    List<FlSpot>? chartData,
    String? activeFilter,
  }) {
    return FerDetailState(
      transacoes: transacoes ?? this.transacoes,
      emprestimosAtivos: emprestimosAtivos ?? this.emprestimosAtivos,
      chartData: chartData ?? this.chartData,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

@riverpod
class FerDetailController extends _$FerDetailController {
  late final ITransacaoRepository _transacaoRepository;
  late final IEmprestimoRepository _emprestimoRepository;
  late final IFundoRepository _fundoRepository;
  
  @override
  Stream<FerDetailState> build() async* {
    _transacaoRepository = getIt<ITransacaoRepository>();
    _emprestimoRepository = getIt<IEmprestimoRepository>();
    _fundoRepository = getIt<IFundoRepository>();

    // 1. Fetch Transactions
    final allTransacoes = await _transacaoRepository.getExtrato(); 
    
    // 2. Identify FER ID properly
    final ferFundo = await _fundoRepository.getFundo('FER');
    final int ferId = ferFundo?.id ?? 1; // Fallback to 1 if not found (should be found)
    
    final ferTransacoes = allTransacoes.where((t) {
       return t.fundoPrincipalDestinoId == ferId || t.fundoPrincipalOrigemId == ferId || 
              // Include Real Payment Transactions
              t.tipoTransacao == 'PAGAMENTO_COMPROMISSO' ||
              // Keep Rendimentos
              t.tipoTransacao == 'RENDIMENTO_FER';
              // Exclude AJUSTE_INFLACAO_EMPRESTIMO (Simulated)
    }).toList();

    // 3. Fetch Active Loans
    final loans = await _emprestimoRepository.getEmprestimosAtivos();

    // 4. Generate Chart Data
    final chartData = _generateChartData(ferTransacoes);

    yield FerDetailState(
      transacoes: ferTransacoes, 
      emprestimosAtivos: loans,
      chartData: chartData,
    );
  }

  List<FlSpot> _generateChartData(List<Transacao> transacoes) {
    if (transacoes.isEmpty) return [];

    // Sort by date ASC
    final sorted = List<Transacao>.from(transacoes)..sort((a, b) => a.dataTransacao.compareTo(b.dataTransacao));
    
    // Group by Day
    Map<String, double> dailyBalance = {};
    double currentBalance = 0;
    
    for (var t in sorted) {
       double effect = 0;
       
       if (t.tipoTransacao == 'PAGAMENTO_COMPROMISSO' || t.tipoTransacao == 'APORTE_INICIAL' || 
           t.tipoTransacao == 'RENDIMENTO_FER') {
           effect = t.valor;
       }
       
       currentBalance += effect;
       
       // Key format: YYYY-MM-DD to group same-day events accurately
       final dayKey = "${t.dataTransacao.year}-${t.dataTransacao.month}-${t.dataTransacao.day}";
       dailyBalance[dayKey] = currentBalance;
    }

    if (dailyBalance.isEmpty) return [];

    List<FlSpot> result = [];
    
    // If we only have 1 day of data (e.g. Today), the chart will be a single dot.
    // To make a nice "Evolution" line, we assume it started from 0 previously.
    if (dailyBalance.length == 1) {
       result.add(const FlSpot(0, 0)); // Start at 0
       result.add(FlSpot(1, dailyBalance.values.first)); // End at current
       return result;
    }

    // Normal multi-day logic
    int index = 0;
    final sortedKeys = dailyBalance.keys.toList(); 
    // We should probably sort these keys chronologically, they are strings YYYY-MM-DD so lex sort works?
    // Better to parse back? "sorted" list was already chronological.
    // Map iteration order is preserving insertion in Dart, so it should remain sorted.
    
    // Add implicit start point (index 0 = 0) if the first data point isn't 0?
    // Let's just plot the days we have.
    for (var key in sortedKeys) {
       result.add(FlSpot(index.toDouble(), dailyBalance[key]!));
       index++;
    }
    
    return result;
  }
}
