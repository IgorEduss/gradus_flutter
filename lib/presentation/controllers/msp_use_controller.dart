import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/emprestimo.dart';
import '../../domain/entities/caixinha.dart';
import '../../domain/usecases/realizar_uso_msp_usecase.dart';
import '../../domain/usecases/realizar_deposito_msp_usecase.dart';
import '../providers/repositories_providers.dart';
import '../providers/usecases_providers.dart';
import 'msp_detail_controller.dart'; // Import this for invalidation
import 'package:gradus/domain/entities/compromisso.dart';
import 'package:gradus/domain/entities/transacao.dart';
import '../../domain/repositories/i_emprestimo_repository.dart';
import '../../domain/repositories/i_compromisso_repository.dart';
import '../../domain/repositories/i_fundo_repository.dart';
import '../../domain/repositories/i_transacao_repository.dart';

part 'msp_use_controller.g.dart';

@riverpod
class MspUseController extends _$MspUseController {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  Future<void> realizarUso({
    required int usuarioId,
    required double valor,
    required String descricao,
    required TipoUsoMsp tipoUso,
    int? emprestimoId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(realizarUsoMspUseCaseProvider);
      await useCase(
        usuarioId: usuarioId,
        valor: valor,
        descricao: descricao,
        tipoUso: tipoUso,
        emprestimoId: emprestimoId,
      );
      // Refresh Statement
      ref.invalidate(mspDetailControllerProvider);
      // Refresh Loans if amortization?
      if (tipoUso == TipoUsoMsp.amortizacaoEmprestimo) {
         ref.invalidate(activeLoansProvider);
      }
    });
  }

  Future<void> realizarDeposito({
    required int usuarioId,
    required double valor,
    required String descricao,
    int? caixinhaId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(realizarDepositoMspUseCaseProvider);
      await useCase(
        usuarioId: usuarioId,
        valor: valor,
        descricao: descricao,
        caixinhaId: caixinhaId,
      );
      // Refresh Statement and Caixinhas
      ref.invalidate(mspDetailControllerProvider);
      if (caixinhaId != null) {
        ref.invalidate(activeCaixinhasProvider);
      }
    });
  }
  Future<void> realizarUsoComEmprestimoAutomatico({
    required int usuarioId,
    required double valorTotalSaque,
    required double saldoAtualMsp,
    required String descricao,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // 1. Calculate Loan Amount Needed (Withdrawal - Current Balance)
      // Actually, user wants to withdraw X. Have Y. 
      // Loan = X - Y? Or Loan = X to cover everything?
      // "Valor do saque... maior que quantia disponível... valor fica negativado."
      // "O MSP não fica negativo... empréstimo gerado automaticamente."
      // Typically: Use all MSP + Loan for difference.
      
      // But simpler implementation:
      // Loan Amount = Difference.
      final loanAmount = valorTotalSaque - saldoAtualMsp;
      
      if (loanAmount <= 0) return; // Should have been caught by UI check
      
      final emprestimoRepo = ref.read(emprestimoRepositoryProvider);
      final compromissoRepo = ref.read(compromissoRepositoryProvider);
      final transacaoRepo = ref.read(transacaoRepositoryProvider);
      final fundoRepo = ref.read(fundoRepositoryProvider);

      final now = DateTime.now();

      // 2. Identify FER Fund
      final ferFundo = await fundoRepo.getFundo('FER');
      if (ferFundo == null) throw Exception('Fundo FER não encontrado');

      // 3. Create Loan (Emprestimo)
      final novoEmprestimo = Emprestimo(
        id: 0,
        usuarioId: usuarioId,
        fundoOrigemId: ferFundo.id,
        valorConcedido: loanAmount,
        saldoDevedorAtual: loanAmount,
        proposito: 'Cob. Saque: $descricao',
        statusEmprestimo: 'ATIVO',
        dataConcessao: now,
        dataCriacao: now,
        dataAtualizacao: now,
      );
      
      final emprestimoId = await emprestimoRepo.createEmprestimo(novoEmprestimo);

      // 4. Create Transactions
      // 4a. Inflow from FER to MSP (Loan Disbursement)
      await transacaoRepo.addTransacao(Transacao(
        id: 0,
        usuarioId: usuarioId,
        descricao: 'Empréstimo FER (Cob. Saque)',
        tipoTransacao: 'ENTRADA',
        valor: loanAmount,
        dataTransacao: now,
        fundoPrincipalOrigemId: ferFundo.id,
        fundoPrincipalDestinoId: await _getMspId(fundoRepo),
        emprestimoId: emprestimoId, 
        dataCriacao: now,
        dataAtualizacao: now,
      ));

      // 4b. Outflow from MSP (The actual Expense)
      // Total amount = Existing Balance + Loan.
      // E.g. Want 100. Have 20. Loan 80.
      // Balance becomes 20 + 80 = 100.
      // Spend 100. Balance = 0.
      // Wait, we need to spend 'valorTotalSaque'.
      
      final mspId = await _getMspId(fundoRepo);

      await transacaoRepo.addTransacao(Transacao(
         id: 0,
         usuarioId: usuarioId,
         descricao: descricao,
         tipoTransacao: 'SAIDA', // Gasto
         valor: valorTotalSaque, 
         dataTransacao: now,
         fundoPrincipalOrigemId: mspId,
         // No destination fund for expense
         dataCriacao: now,
         dataAtualizacao: now,
      ));

      // 5. Update Balances (Funds)
      // FER decreases by loanAmount
      await fundoRepo.updateSaldo(ferFundo.id, ferFundo.saldoAtual - loanAmount);
      
      // MSP increases by loanAmount (Refill) AND decreases by valorTotalSaque (Spend)
      // Net change = loanAmount - valorTotalSaque = (X-Y) - X = -Y.
      // Wait. MSP Balance was Y.
      // New Balance = Y + (X-Y) - X = X - X = 0.
      // So set MSP balance to 0 (or close to it if float math).
      await fundoRepo.updateSaldo(mspId, 0.0); 

      // 6. Create Commitment (Compromisso) to pay back
      // Default: 10 months? Or 10%? 
      // User said "generated automatically". Let's assume 10 installments for now or $50 min?
      // Let's use a reasonable default: 10 installments.
      // 6. Create Commitment (Compromisso) to pay back
      // Calculate installments based on User's Payment Unit (unidadePagamento)
      // e.g. Loan = 100, Unit = 25 -> 4 Installments of ~25.
      
      final usuarioRepo = ref.read(usuarioRepositoryProvider);
      final user = await usuarioRepo.getUsuario();
      final double paymentUnit = user?.unidadePagamento ?? 50.0; // Default to 50 if null

      // Set installment value to Payment Unit (or total loan if smaller)
      // Rule: "Use payment unit as minimum installment" (interpreted as standard installment value)
      final double valorParcela = (loanAmount < paymentUnit) ? loanAmount : paymentUnit;

      // Calculate number of installments needed to cover the loan
      final int parcelas = (loanAmount / valorParcela).ceil();
      final int finalParcelas = parcelas > 0 ? parcelas : 1; 

      final novoCompromisso = Compromisso(
        id: 0,
        usuarioId: usuarioId,
        descricao: 'Pgto. Empréstimo: $descricao',
        tipoCompromisso: 'RESSARCIMENTO_EMPRESTIMO',
        valorParcela: valorParcela,
        numeroTotalParcelas: finalParcelas,
        valorTotalComprometido: loanAmount, // Should match loan
        numeroParcelasPagas: 0,
        fundoPrincipalDestinoId: ferFundo.id, // Pay back to FER
        dataInicioCompromisso: now, // Start NOW so it appears NEXT month
        dataProximoVencimento: DateTime(now.year, now.month + 1, 1),
        statusCompromisso: 'ATIVO',
        ajusteInflacaoAplicavel: true, // Loans usually adjust?
        dataCriacao: now,
        dataAtualizacao: now,
      );

      await compromissoRepo.createCompromisso(novoCompromisso);

      // Refresh UI
      ref.invalidate(mspDetailControllerProvider);
      ref.invalidate(activeLoansProvider);
      ref.invalidate(activeCaixinhasProvider);
    });
  }

  Future<int> _getMspId(IFundoRepository repo) async {
    final f = await repo.getFundo('MSP');
    return f?.id ?? 0;
  }
}

// Provider to fetch active loans for the dropdown
@riverpod
Future<List<Emprestimo>> activeLoans(ActiveLoansRef ref) async {
  final repository = ref.watch(emprestimoRepositoryProvider);
  return repository.getEmprestimosAtivos();
}

// Provider to fetch Caixinhas for the dropdown
@riverpod
Future<List<Caixinha>> activeCaixinhas(ActiveCaixinhasRef ref) async {
  final repository = ref.watch(caixinhaRepositoryProvider);
  return repository.getCaixinhasAtivas();
}

@riverpod
Future<double> mspBalance(MspBalanceRef ref) async {
  final fundoRepository = ref.watch(fundoRepositoryProvider);
  final fundo = await fundoRepository.getFundo('MSP');
  return fundo?.saldoAtual ?? 0.0;
}
