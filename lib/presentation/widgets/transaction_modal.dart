import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get_it/get_it.dart';
import '../../domain/repositories/i_usuario_repository.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/commitment_controller.dart';
import '../providers/user_provider.dart';

class TransactionModal extends ConsumerStatefulWidget {
  const TransactionModal({super.key});

  @override
  ConsumerState<TransactionModal> createState() => _TransactionModalState();
}

class _TransactionModalState extends ConsumerState<TransactionModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _transactionType = 'ENTRADA'; // ENTRADA, SAIDA
  String _fundType = 'FER'; // FER, MSP
  int? _selectedCommitmentId;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    print('Submit called');
    if (_formKey.currentState!.validate()) {
      print('Form valid');
      final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
      final description = _descriptionController.text;

      // Obter o usuário atual diretamente do repositório para garantir
      print('Fetching user from repository...');
      final userRepo = GetIt.I<IUsuarioRepository>();
      final user = await userRepo.getUsuario();
      print('User fetched: $user');

      if (user == null) {
        print('Error: User is null');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro: Usuário não encontrado. Tente reiniciar o app.')),
          );
        }
        return;
      }

      try {
        print('Calling addTransaction');
        await ref.read(transactionControllerProvider.notifier).addTransaction(
              valor: amount,
              descricao: description,
              tipoTransacao: _transactionType,
              tipoFundo: _fundType,
              usuarioId: user.id,
              commitmentId: _selectedCommitmentId,
            );
        
        // Check for error in state
        final state = ref.read(transactionControllerProvider);
        if (state.hasError) {
          print('State has error: ${state.error}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao salvar: ${state.error}')),
            );
          }
        } else {
          print('Success');
          if (mounted) {
            Navigator.of(context).pop(); // Fechar modal
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transação salva com sucesso!')),
            );
          }
        }
      } catch (e) {
        print('Exception caught: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar: $e')),
          );
        }
      }
    } else {
      print('Form invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionControllerProvider);
    final isLoading = state is AsyncLoading;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nova Transação',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Tipo de Transação
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Entrada'),
                    value: 'ENTRADA',
                    groupValue: _transactionType,
                    onChanged: (value) => setState(() => _transactionType = value!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Saída'),
                    value: 'SAIDA',
                    groupValue: _transactionType,
                    onChanged: (value) => setState(() => _transactionType = value!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            // Fundo
            DropdownButtonFormField<String>(
              value: _fundType,
              decoration: const InputDecoration(labelText: 'Fundo'),
              items: const [
                DropdownMenuItem(value: 'FER', child: Text('Fundo Escada Rolante (FER)')),
                DropdownMenuItem(value: 'MSP', child: Text('Meu Saldo Pessoal (MSP)')),
              ],
              onChanged: (value) => setState(() {
                _fundType = value!;
                _selectedCommitmentId = null; // Clear selection on fund change
                _descriptionController.clear();
              }),
            ),
            if ((_fundType == 'FER' || _fundType == 'MSP') && _transactionType == 'ENTRADA') ...[
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) {
                  final commitmentsAsync = ref.watch(activeCommitmentsProvider);
                  return commitmentsAsync.when(
                    data: (commitments) {
                      final filteredCommitments = commitments.where((c) {
                        if (_fundType == 'FER') return c.tipoCompromisso == 'FACILITADOR_FER';
                        if (_fundType == 'MSP') return c.tipoCompromisso == 'DEPOSITO_MSP';
                        return false;
                      }).toList();

                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: _fundType == 'FER' ? 'Compromisso (Obrigatório)' : 'Compromisso (Opcional)',
                        ),
                        value: _selectedCommitmentId,
                        items: [
                          // Opção "Nenhum" apenas se NÃO for FER
                          if (_fundType != 'FER')
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text('Nenhum / Depósito Avulso'),
                            ),
                          ...filteredCommitments.map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.descricao),
                              )),
                        ],
                        validator: (value) {
                          if (_fundType == 'FER' && value == null) {
                            return 'Selecione um compromisso para o FER';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedCommitmentId = value;
                            
                            // Auto-preenchimento
                            if (value != null) {
                              final selectedCommitment = filteredCommitments.firstWhere((c) => c.id == value);
                              
                              // 1. Descrição Padrão
                              _descriptionController.text = 'Pagamento: ${selectedCommitment.descricao}';

                              // 2. Cálculo do Valor (Parcela ou Resto)
                              double valorAPagar = selectedCommitment.valorParcela;
                              
                              if (selectedCommitment.valorTotalComprometido != null) {
                                final totalPagoEstimado = selectedCommitment.numeroParcelasPagas * selectedCommitment.valorParcela;
                                final saldoDevedor = selectedCommitment.valorTotalComprometido! - totalPagoEstimado;
                                
                                // Se o saldo devedor for menor ou igual à parcela (com margem de erro para float), paga o resto
                                if (saldoDevedor <= valorAPagar + 0.01) {
                                  valorAPagar = saldoDevedor;
                                }
                              }
                              
                              // Formatar para o campo (usando . para decimal conforme o validador atual)
                              _amountController.text = valorAPagar.toStringAsFixed(2).replaceAll('.', ',');
                            }
                          });
                        },
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text('Erro ao carregar compromissos'),
                  );
                },
              ),
            ],
            const SizedBox(height: 16),
            // Valor
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
                prefixText: 'R\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe o valor';
                if (double.tryParse(value.replaceAll(',', '.')) == null) return 'Valor inválido';
                return null;
              },
            ),
            // Descrição (Oculta para FER/ENTRADA pois é automática)
            if (!(_fundType == 'FER' && _transactionType == 'ENTRADA')) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe uma descrição';
                  return null;
                },
              ),
            ],
            const SizedBox(height: 24),
            // Botão Salvar
            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar Transação'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
