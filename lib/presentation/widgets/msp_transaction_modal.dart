import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/currency_input_formatter.dart';
import '../controllers/transaction_controller.dart';
import '../providers/user_provider.dart';
import '../controllers/msp_use_controller.dart';
import '../../domain/usecases/realizar_uso_msp_usecase.dart'; // for enum
import 'auth/numeric_keyboard.dart'; // Import custom keyboard


enum MspTransactionType { receita, despesa, transferencia }

class MspTransactionModal extends ConsumerStatefulWidget {
  const MspTransactionModal({super.key});

  @override
  ConsumerState<MspTransactionModal> createState() => _MspTransactionModalState();
}

class _MspTransactionModalState extends ConsumerState<MspTransactionModal> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  
  int _selectedIndex = 0; // 0: Receita, 1: Despesa, 2: Amortização
  int? _selectedLoanId;
  int? _selectedCaixinhaId;
  String _amountString = '0,00';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    setState(() {
      String raw = _amountString.replaceAll(RegExp(r'[^0-9]'), '');
      if (raw.length >= 9) return;
      raw = raw + number;
      _updateAmountValue(raw);
    });
  }

  void _onBackspacePressed() {
    setState(() {
      String raw = _amountString.replaceAll(RegExp(r'[^0-9]'), '');
      if (raw.isNotEmpty) {
        raw = raw.substring(0, raw.length - 1);
      }
      _updateAmountValue(raw);
    });
  }

  void _updateAmountValue(String raw) {
      if (raw.isEmpty) raw = '0';
      double value = double.parse(raw) / 100;
      final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2);
      _amountString = formatter.format(value).replaceAll('R\$', '').trim();
  }

  double _getAmountAsDouble() {
     String raw = _amountString.replaceAll('.', '').replaceAll(',', '.');
     return double.tryParse(raw) ?? 0.0;
  }

  Future<void> _submit() async {
      print('Debug: Starting _submit');
      
      if (_selectedIndex == 2 && _selectedLoanId == null) { 
         print('Debug: Amortization validation failed');
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selecione um empréstimo para amortizar.')),
          );
          return;
      }

      final amount = _getAmountAsDouble();
      print('Debug: Amount parsed: $amount');
      if (amount <= 0) {
          print('Debug: Amount invalid');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Informe um valor válido.')),
          );
          return;
      }

      String description = _descriptionController.text;
      
      // Auto-generate or append Caixinha name
      if (_selectedIndex == 0 && _selectedCaixinhaId != null) {
          final caixinhas = ref.read(activeCaixinhasProvider).value ?? [];
          final selectedCaixinha = caixinhas.where((c) => c.id == _selectedCaixinhaId).firstOrNull;
          
          if (selectedCaixinha != null) {
              if (description.isEmpty) {
                  description = 'Depósito - ${selectedCaixinha.nomeCaixinha}';
              } else {
                  // User provided description, append Caixinha name with simple dash separator
                  description = '$description - ${selectedCaixinha.nomeCaixinha}';
              }
          }
      } else if (description.isEmpty) {
           description = _getDefaultDescription();
      }

      final userAsync = ref.read(usuarioProvider);
      final user = userAsync.value;

      print('Debug: User found: ${user?.id}');

      if (user == null) {
         print('Debug: User is null');
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário não identificado.')),
          );
          return;
      }

      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      try {
        print('Debug: Entering try block, selectedIndex: $_selectedIndex');
        
        // --- LOGIC FOR EXPENSE (GASTO) ---
        if (_selectedIndex == 1) {
            // Check Balance
            final mspBalance = await ref.read(mspBalanceProvider.future);
            
            if (amount > mspBalance) {
               // INSUFFICIENT FUNDS -> SHOW DIALOG
               final bool? confirm = await showDialog<bool>(
                 context: context,
                 builder: (ctx) => AlertDialog(
                   backgroundColor: const Color(0xFF2C2C2C),
                   title: const Text('Saldo Insuficiente', style: TextStyle(color: Colors.white)),
                   content: Text(
                     'Seu saldo atual é R\$ ${NumberFormat.simpleCurrency(locale: "pt_BR", name: "").format(mspBalance).trim()}.\n\n'
                     'Para completar esta transação, será necessário realizar um empréstimo automático com o FER para cobrir a diferença.\n\n'
                     'Deseja continuar?',
                     style: const TextStyle(color: Colors.white70),
                   ),
                   actions: [
                     TextButton(
                       onPressed: () => Navigator.pop(ctx, false),
                       child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                     ),
                     TextButton(
                       onPressed: () => Navigator.pop(ctx, true),
                       child: const Text('Confirmar', style: TextStyle(color: Color(0xFF9DF425), fontWeight: FontWeight.bold)),
                     ),
                   ],
                 ),
               );

               if (confirm != true) return; // User cancelled

               // Perform Automatic Loan + Use
               await ref.read(mspUseControllerProvider.notifier).realizarUsoComEmprestimoAutomatico(
                 usuarioId: user.id,
                 valorTotalSaque: amount,
                 saldoAtualMsp: mspBalance,
                 descricao: description,
               );

            } else {
               // SUFFICIENT FUNDS -> NORMAL FLOW
               await ref.read(mspUseControllerProvider.notifier).realizarUso(
                usuarioId: user.id,
                valor: amount,
                descricao: description,
                tipoUso: TipoUsoMsp.gastoPessoal,
                emprestimoId: null,
              );
            }
        } 
        
        // --- LOGIC FOR DEPOSIT ---
        else if (_selectedIndex == 0) {
          print('Debug: Calling mspUseController.realizarDeposito');
          await ref.read(mspUseControllerProvider.notifier).realizarDeposito(
            valor: amount,
            descricao: description,
            usuarioId: user.id,
            caixinhaId: _selectedCaixinhaId,
          );
        } 
        
        // --- LOGIC FOR AMORTIZATION ---
        else {
          print('Debug: Calling mspUseController.realizarUso (Amortizacao)');
          await ref.read(mspUseControllerProvider.notifier).realizarUso(
            usuarioId: user.id,
            valor: amount,
            descricao: description,
            tipoUso: TipoUsoMsp.amortizacaoEmprestimo,
            emprestimoId: _selectedLoanId,
          );
        }
        
        print('Debug: Transaction successful, popping');

        navigator.pop();
        messenger.showSnackBar(
           const SnackBar(
             content: Text('Operação realizada com sucesso!'),
             backgroundColor: Colors.green,
           ),
        );
      } catch (e, stack) {
         print('Debug: Catch error: $e');
         print('Debug: Stacktrace: $stack');
         messenger.showSnackBar(
            SnackBar(
              content: Text('Erro: $e'),
              backgroundColor: Colors.red,
            ),
          );
      }
  }

  @override
  Widget build(BuildContext context) {
    // Watch user to ensure it's loaded
    final userAsync = ref.watch(usuarioProvider);
    
    final isLoading = ref.watch(transactionControllerProvider) is AsyncLoading || 
                      ref.watch(mspUseControllerProvider) is AsyncLoading ||
                      userAsync.isLoading; // Disable if user is loading
    
    final loansAsync = ref.watch(activeLoansProvider);
    final caixinhasAsync = ref.watch(activeCaixinhasProvider);

    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom, // Handle text field focus
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                 const SizedBox(width: 48), // Spacer to balance the icon
                 Expanded(
                   child: Text(
                    'Movimentar MSP',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                 ),
                 IconButton(
                   icon: const Icon(Icons.close, color: Colors.white70),
                   onPressed: () => Navigator.of(context).pop(),
                 ),
              ],
            ),
           ),
            const SizedBox(height: 24),
            
            // Segmented Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('Receita'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Gasto'),
                  icon: Icon(Icons.shopping_cart),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('Amortizar'), // Renamed from Transferência
                  icon: Icon(Icons.account_balance_wallet),
                ),
              ],
              selected: {_selectedIndex},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedIndex = newSelection.first;
                  _selectedLoanId = null; // Reset loan selection
                  _selectedCaixinhaId = null; // Reset caixinha selection
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                       switch (_selectedIndex) {
                         case 0: return Colors.green.withOpacity(0.2);
                         case 1: return Colors.orange.withOpacity(0.2);
                         case 2: return Colors.blue.withOpacity(0.2);
                       }
                    }
                    return null; 
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                     if (states.contains(MaterialState.selected)) {
                       switch (_selectedIndex) {
                         case 0: return Colors.green;
                         case 1: return Colors.orange;
                         case 2: return Colors.blue;
                       }
                    }
                    return Colors.grey;
                  },
                ),
              ),
            ),
            ),
            
            const SizedBox(height: 24),

            // Caixinha Dropdown (Receita)
            if (_selectedIndex == 0) ...[
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: caixinhasAsync.when(
                  data: (caixinhas) {
                    if (caixinhas.isEmpty) return const SizedBox.shrink();
                    return DropdownButtonFormField<int>(
                      value: _selectedCaixinhaId,
                      decoration: const InputDecoration(
                        labelText: 'Destinar para Caixinha (Opcional)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('Nenhuma (Direto no Saldo Pessoal)'),
                        ),
                        ...caixinhas.map((c) => DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(c.nomeCaixinha),
                        )),
                      ],
                      onChanged: (val) => setState(() => _selectedCaixinhaId = val),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_,__) => const SizedBox.shrink(),
                ),
               ),
               const SizedBox(height: 16),
            ],

            // Amortization Loan Dropdown
            if (_selectedIndex == 2) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: loansAsync.when(
                data: (loans) {
                  if (loans.isEmpty) {
                    return const Text(
                      'Você não possui empréstimos ativos para amortizar.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    );
                  }
                  return DropdownButtonFormField<int>(
                    value: _selectedLoanId,
                    decoration: const InputDecoration(
                      labelText: 'Selecione o Empréstimo',
                      border: OutlineInputBorder(),
                    ),
                    items: loans.map((loan) {
                      return DropdownMenuItem<int>(
                        value: loan.id,
                        child: Text(
                          '${loan.proposito ?? "Empréstimo #${loan.id}"} - R\$ ${loan.saldoDevedorAtual.toStringAsFixed(2)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedLoanId = val),
                    validator: (val) => val == null ? 'Obrigatório' : null,
                  );
                },
                loading: () => const Center(child: LinearProgressIndicator()),
                error: (e, s) => Text('Erro ao carregar empréstimos: $e'),
              ),
              ),
              const SizedBox(height: 16),
            ],

            // Custom Amount Display
             Center(
              child: Column(
                children: [
                  const Text('Valor da transação', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ $_amountString',
                    style: const TextStyle(
                      fontSize: 40, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Description Field (Standard Text Field)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição (Opcional)',
                hintText: _getDefaultDescription(),
                border: const OutlineInputBorder(),
              ),
            ),
            ),

            const SizedBox(height: 24),

            // Custom Numeric Keyboard (Only show if description is not focused/keyboard visible)
            if (!isKeyboardVisible)
              NumericKeyboard(
                onNumberPressed: _onNumberPressed,
                onBackspacePressed: _onBackspacePressed,
                customLeftButton: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: _getButtonColor(),
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: isLoading ? null : () {
                        print('Debug: Submit button pressed');
                        _submit();
                      },
                      child: isLoading 
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : const Icon(Icons.check, size: 32, color: Colors.white),
                    ),
                  ),
                ),
              ),

             // Padding for bottom safely
             SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  String _getDefaultDescription() {
    switch (_selectedIndex) {
      case 0: return 'Depósito Pessoal';
      case 1: return 'Gasto Pessoal';
      case 2: return 'Amortização Antecipada';
      default: return '';
    }
  }

  Color _getButtonColor() {
    switch (_selectedIndex) {
      case 0: return Colors.green;
      case 1: return Colors.orange;
      case 2: return Colors.blue;
      default: return Colors.grey;
    }
  }
}
