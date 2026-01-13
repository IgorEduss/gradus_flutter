import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/currency_input_formatter.dart';
import '../controllers/commitment_controller.dart';
import '../controllers/transaction_controller.dart';
import '../providers/user_provider.dart';

class LoanRequestModal extends ConsumerStatefulWidget {
  const LoanRequestModal({super.key});

  @override
  ConsumerState<LoanRequestModal> createState() => _LoanRequestModalState();
}

class _LoanRequestModalState extends ConsumerState<LoanRequestModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _installmentController = TextEditingController();
  final _reasonController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _installmentController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = CurrencyInputFormatter.parseAndConvert(_amountController.text);
      final installment = CurrencyInputFormatter.parseAndConvert(_installmentController.text);
      final reason = _reasonController.text;

      final userAsync = ref.read(usuarioProvider);
      final user = userAsync.value;

      if (user == null) throw Exception('Usuário não encontrado');

      // 1. Create Commitment (The Debt)
      final totalParcelas = (amount / installment).ceil();
      // Start paying next month
      final now = DateTime.now();
      final dataInicio = DateTime(now.year, now.month + 1, user.diaRevisaoMensal);

      await ref.read(commitmentControllerProvider.notifier).addCommitment(
        descricao: 'Empréstimo FER: $reason',
        valorParcela: installment,
        dataInicio: dataInicio,
        usuarioId: user.id,
        numeroTotalParcelas: totalParcelas,
        valorTotalComprometido: amount,
        tipoCompromisso: 'EMPRESTIMO_FER', // Special type
      );

      // 2. Create Transaction (The Money Entry)
      await ref.read(transactionControllerProvider.notifier).addTransaction(
        valor: amount,
        descricao: 'Crédito Empréstimo: $reason',
        tipoTransacao: 'ENTRADA',
        tipoFundo: 'MSP', // Goes to personal wallet
        usuarioId: user.id,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empréstimo solicitado com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao solicitar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.handshake, color: Colors.orangeAccent, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Solicitar Empréstimo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'O valor será depositado no seu MSP e uma dívida será criada no FER.',
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Amount Needed
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Valor Necessário',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe o valor';
                if (CurrencyInputFormatter.parseAndConvert(value) <= 0) return 'Valor inválido';
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            
            const SizedBox(height: 16),

            // Installment capability
            TextFormField(
              controller: _installmentController,
              decoration: const InputDecoration(
                labelText: 'Quanto pode pagar por mês?',
                helperText: 'Isso definirá o número de parcelas',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe o valor da parcela';
                 final v = CurrencyInputFormatter.parseAndConvert(value);
                 final total = CurrencyInputFormatter.parseAndConvert(_amountController.text);
                 if (v <= 0) return 'Valor inválido';
                 if (v > total) return 'Parcela não pode ser maior que o empréstimo';
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),

             const SizedBox(height: 16),

            // Reason
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Motivo (Opcional)',
                hintText: 'Ex: Emergência médica, Reforma',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Summary
            Builder(
              builder: (context) {
                final total = CurrencyInputFormatter.parseAndConvert(_amountController.text);
                final parcela = CurrencyInputFormatter.parseAndConvert(_installmentController.text);

                if (total <= 0 || parcela <= 0) return const SizedBox.shrink();

                final numParcelas = (total / parcela).ceil();
                
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text('Resumo do Empréstimo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                      const SizedBox(height: 8),
                      Text('${currencyFormat.format(total)} em $numParcelas x ${currencyFormat.format(parcela)}'),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.black,
              ),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black))
                  : const Text('Confirmar Solicitação'),
            ),
          ],
        ),
      ),
    );
  }
}
