import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:gradus/presentation/controllers/monthly_cycle_controller.dart';
import 'package:gradus/core/utils/currency_input_formatter.dart';
import 'package:gradus/domain/entities/compromisso.dart';
import '../../widgets/objectives/commitment_card.dart';
import '../../widgets/monthly/deposit_modal.dart';
import '../../widgets/commitment_modal.dart'; // Import Modal
import '../../controllers/commitment_controller.dart'; // Import Controller

import 'package:gradus/presentation/providers/selected_month_provider.dart';
import 'package:gradus/presentation/providers/user_provider.dart';

class MonthlyCycleScreen extends ConsumerStatefulWidget {
  const MonthlyCycleScreen({super.key});

  @override
  ConsumerState<MonthlyCycleScreen> createState() => _MonthlyCycleScreenState();
}

class _MonthlyCycleScreenState extends ConsumerState<MonthlyCycleScreen> {
  final _paymentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _totalDevido = 0;
  List<Compromisso> _compromissos = [];
  double _lastKnownTotal = -1; // Track for auto-update

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compromissosAsync = ref.watch(compromissosDoMesProvider);
    final cycleState = ref.watch(monthlyCycleControllerProvider);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    // Listen for success
    ref.listen(monthlyCycleControllerProvider, (previous, next) {
      // Check for successful transition from Loading to Data
      if (next is AsyncData && (previous is AsyncLoading)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ciclo mensal processado com sucesso!')),
        );
        context.pop(); // Return to dashboard
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${next.error}')),
        );
      }
    });

    final userAsync = ref.watch(usuarioProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ciclo Mensal'),
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('Usuário não encontrado'));
          
          return compromissosAsync.when(
            data: (compromissos) {
              _compromissos = compromissos;
              
              // Calculate totals
              double totalFer = 0;
              double totalMsp = 0;
              double _totalPendente = 0; // Remaining to Pay (Bottom Field)
              
              final selectedDate = ref.watch(selectedMonthProvider);

              for (var c in compromissos) {
                // Top Card Calculation (All Commitments)
                if (c.tipoCompromisso == 'FACILITADOR_FER' || c.tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO') {
                  totalFer += c.valorParcela;
                } else {
                  totalMsp += c.valorParcela;
                }
                
                // Bottom Field Calculation (Only Unpaid)
                if (!_isPaid(c, user.diaRevisaoMensal, selectedDate)) {
                    _totalPendente += c.valorParcela;
                }
              }
              _totalDevido = totalFer + totalMsp;

              // Pre-fill payment controller:
              // Only update if it hasn't been edited by user yet? 
              // Or always sync with current state? 
              // Given the reactive nature, syncing is better for "refresh" behavior.
              // Logic: If user hasn't typed anything (or it matches old total), update it.
              // Simpler: Just set it. The user scenario implies they want to see what's left.
              
              // Auto-fill payment controller if total changes (e.g. navigation)
              if (_totalPendente != _lastKnownTotal) {
                  _lastKnownTotal = _totalPendente;
                   // Use a post-frame callback to avoid build-phase errors if strictly enforced
                   // But straightforward text setting is usually fine here if not focused.
                   // To be safe, we only update text.
                   _paymentController.text = currencyFormat.format(_totalPendente);
              }

              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildMonthSelector(ref),
                    ),
                    Expanded(
                      child: compromissos.isEmpty
                          ? const Center(
                              child: Text('Nenhum compromisso pendente para este mês.'),
                            )
                          : ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              children: [
                                _buildSummaryCard(totalFer, totalMsp, currencyFormat),
                                const SizedBox(height: 24),
                                const Text(
                                  'Compromissos',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ...compromissos.map((c) => CommitmentCard(
                                      compromisso: c,
                                      diaRevisaoMensal: user.diaRevisaoMensal,
                                      referenceDate: ref.read(selectedMonthProvider),
                                      onDeposit: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: const Color(0xFF1E1E1E), // Match dialog/card color
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(24),
                                              topRight: Radius.circular(24),
                                            ),
                                          ),
                                          builder: (context) => DepositModal(
                                            compromisso: c,
                                            onConfirm: (valor) {
                                              Navigator.pop(context);
                                              ref.read(monthlyCycleControllerProvider.notifier)
                                                  .realizarDeposito(c, valorDepositado: valor);
                                            },
                                          ),
                                        );
                                      },
                                      onEdit: () {
                                         // Open Modal in Edit Mode
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent, 
                                            builder: (context) => Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                                              child: CommitmentModal(compromisso: c), // Pass commitment
                                            ),
                                          );
                                      },
                                      onHistory: () {
                                         ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Histórico de pagamentos em breve')),
                                        );
                                      },
                                      onDelete: () {
                                         // Show Confirmation Dialog
                                         showDialog(
                                           context: context,
                                           builder: (ctx) => AlertDialog(
                                             title: const Text('Excluir Compromisso'),
                                             content: Text('Tem certeza que deseja excluir "${c.descricao}"?'),
                                             actions: [
                                               TextButton(
                                                 onPressed: () => Navigator.pop(ctx),
                                                 child: const Text('CANCELAR'),
                                               ),
                                               TextButton(
                                                 onPressed: () {
                                                   Navigator.pop(ctx);
                                                   ref.read(commitmentControllerProvider.notifier).deleteCommitment(c);
                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                     const SnackBar(content: Text('Compromisso excluído')),
                                                   );
                                                 },
                                                 child: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
                                               ),
                                             ],
                                           ),
                                         );
                                      },
                                    )),
                              ],
                            ),
                    ),
                    if (compromissos.isNotEmpty) _buildBottomAction(cycleState),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erro: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro ao carregar usuário: $err')),
      ),
    );
  }

  Widget _buildSummaryCard(double totalFer, double totalMsp, NumberFormat format) {
    return Card(
      color: Colors.blueGrey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Total do Mês',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              format.format(_totalDevido),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Para o FER', style: TextStyle(color: Colors.white60)),
                    Text(
                      format.format(totalFer),
                      style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(width: 1, height: 30, color: Colors.white24),
                Column(
                  children: [
                    const Text('Para Você (MSP)', style: TextStyle(color: Colors.white60)),
                    Text(
                      format.format(totalMsp),
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(AsyncValue<void> state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _paymentController,
            decoration: const InputDecoration(
              labelText: 'Valor que vou pagar',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyInputFormatter()],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o valor';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: state.isLoading || _paymentController.text == '0,00' || _paymentController.text == 'R\$ 0,00'
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      final valorPago = CurrencyInputFormatter.parseAndConvert(_paymentController.text);
                      ref.read(monthlyCycleControllerProvider.notifier).processarCiclo(
                            valorPago: valorPago,
                            compromissos: _compromissos,
                          );
                    }
                  },
            child: state.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('CONFIRMAR PAGAMENTO'),
          ),
        ],
      ),
    );
  }


  Widget _buildMonthSelector(WidgetRef ref) {
    final selectedDate = ref.watch(selectedMonthProvider);
    final dateFormat = DateFormat('MMMM yyyy', 'pt_BR');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => ref.read(selectedMonthProvider.notifier).previousMonth(),
        ),
        Text(
          dateFormat.format(selectedDate).toUpperCase(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => ref.read(selectedMonthProvider.notifier).nextMonth(),
        ),
      ],
    );
  }

  bool _isPaid(Compromisso compromisso, int diaRevisao, DateTime referenceDate) {
    // Logic duplicated from CommitmentCard to determine if "Paid" status is true for this month
    final closingDay = diaRevisao;
    final firstBilling = DateTime(
      compromisso.dataInicioCompromisso.year,
      compromisso.dataInicioCompromisso.month + 1, // Start billing next month
      closingDay,
    );
    
    // We target the reference date's billing cycle
    final referenceTarget = DateTime(referenceDate.year, referenceDate.month, closingDay);
    
    int billedMonths = 0;
    
    if (referenceTarget.isAfter(firstBilling) || referenceTarget.isAtSameMomentAs(firstBilling)) {
       int monthsDiff = (referenceTarget.year - firstBilling.year) * 12 + referenceTarget.month - firstBilling.month;
       billedMonths = monthsDiff + 1;
    }

    return compromisso.numeroParcelasPagas >= billedMonths;
  }
}
