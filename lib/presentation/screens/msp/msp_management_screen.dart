import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../controllers/caixinha_controller.dart';
import '../../providers/dashboard_providers.dart';
import '../../widgets/dashboard/msp_summary_card.dart';
import '../../widgets/msp_transaction_modal.dart';

import '../../controllers/msp_detail_controller.dart'; // Import new controller
import '../../providers/user_provider.dart'; // Add this import
import '../../widgets/auth/numeric_keyboard.dart';
import '../../../core/utils/currency_input_formatter.dart';

class MspManagementScreen extends ConsumerStatefulWidget {
  const MspManagementScreen({super.key});

  @override
  ConsumerState<MspManagementScreen> createState() => _MspManagementScreenState();
}

class _MspManagementScreenState extends ConsumerState<MspManagementScreen> with SingleTickerProviderStateMixin {
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
    // We watch both controllers: Caixinhas (for tab 1) and Detail (for tab 2 + chart? or just detail?)
    // Actually, MSP Summary Card drives the top view.
    // The tabs will be below it.
    
    final detailAsync = ref.watch(mspDetailControllerProvider);
    final caixinhasAsync = ref.watch(caixinhaControllerProvider);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Saldo Pessoal'),
      ),
      body: detailAsync.when(
        data: (detailState) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
             SliverToBoxAdapter(
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     const MspSummaryCard(),
                     const SizedBox(height: 16),
                      Center(
                        child: FilledButton.icon(
                          onPressed: () => _showTransactionModal(context),
                          icon: const Icon(Icons.swap_horiz),
                          label: const Text('Movimentar Saldo'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.blueAccent, // MSP Theme is Blue/Green?
                        labelColor: Colors.blueAccent,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: 'Caixinhas'),
                          Tab(text: 'Extrato'),
                        ],
                      ),
                   ],
                 ),
               ),
             ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              // Caixinhas Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Seus Objetivos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                          onPressed: () => _showCaixinhaModal(context),
                        ),
                      ],
                     ),
                     caixinhasAsync.when(
                        data: (caixinhas) {
                          if (caixinhas.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(32),
                              child: Text('Nenhuma caixinha criada.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: caixinhas.length,
                            itemBuilder: (context, index) {
                              final caixinha = caixinhas[index];
                               return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: const CircleAvatar(backgroundColor: Colors.orangeAccent, child: Icon(Icons.savings, color: Colors.white)),
                                  title: Text(caixinha.nomeCaixinha),
                                  subtitle: Text('Saldo: ${currencyFormat.format(caixinha.saldoAtual)}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    onPressed: () => _confirmDelete(context, caixinha, ref),
                                  ),
                                  onTap: () => _showCaixinhaModal(context, caixinha: caixinha),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, s) => Text('Erro: $e'),
                     ),
                   ],
                ),
              ),
              
              // Extrato Tab
              ListView.builder(
                 padding: const EdgeInsets.all(16),
                 itemCount: detailState.transacoes.length,
                 itemBuilder: (context, index) {
                    final t = detailState.transacoes[index];
                    // Logic for display:
                    // If dest == MSP (ID 2 usually, check provider logic) -> Entry
                    // We don't have ID here easily either without logic.
                    // Let's assume based on value/type or just color code generic.
                    // Or replicate controller logic:
                    // Color Logic:
                    // ENTRADA -> Green
                    // SAIDA -> Red
                    // others -> Orange
                    
                    bool isEntry = t.tipoTransacao == 'ENTRADA' || t.tipoTransacao == 'RENDIMENTO_MSP' || t.tipoTransacao == 'RESGATE_CAIXINHA';
                    
                    // Specific fix: 'PAGAMENTO_COMPROMISSO' with fundoDestino == MSP? No, pagamentos come FROM MSP.
                    if (t.tipoTransacao == 'PAGAMENTO_COMPROMISSO') isEntry = false;
                    
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isEntry ? const Color(0xFF1E4D25) : const Color(0xFF4D251E),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isEntry ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isEntry ? const Color(0xFF9DF425) : Colors.redAccent,
                          size: 20,
                        ),
                      ),
                      title: Text(t.descricao, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(dateFormat.format(t.dataTransacao), style: const TextStyle(color: Colors.grey)),
                      trailing: Text(
                        currencyFormat.format(t.valor),
                        style: TextStyle(
                          color: isEntry ? const Color(0xFF9DF425) : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                 },
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro ao carregar extrato: $err')),
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic caixinha, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Caixinha?'),
        content: const Text('O saldo será retornado para o Saldo Geral.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              ref.read(caixinhaControllerProvider.notifier).deleteCaixinha(caixinha.id);
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _showTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const MspTransactionModal(), // Ensure this is imported
    );
  }

  void _showCaixinhaModal(BuildContext context, {dynamic caixinha}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CaixinhaModal(caixinha: caixinha),
    );
  }
}

class CaixinhaModal extends ConsumerStatefulWidget {
  final dynamic caixinha;
  const CaixinhaModal({super.key, this.caixinha});

  @override
  ConsumerState<CaixinhaModal> createState() => _CaixinhaModalState();
}

class _CaixinhaModalState extends ConsumerState<CaixinhaModal> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _metaController = TextEditingController();

  final _monthlyValueController = TextEditingController(); 
  bool _isObrigatorio = false;
  bool _showCustomKeyboard = false;
  String? _activeMonetaryField; // 'meta' or 'monthly'
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.caixinha != null) {
      _nomeController.text = widget.caixinha.nomeCaixinha;
      if (widget.caixinha.metaValor != null) {
        _metaController.text = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(widget.caixinha.metaValor);
      }
      _isObrigatorio = widget.caixinha.depositoObrigatorio;
    }
    
    // Listeners to hide custom keyboard when name is focused
    _nameFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_nameFocus.hasFocus) {
      setState(() {
        _showCustomKeyboard = false;
        _activeMonetaryField = null;
      });
    }
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (_activeMonetaryField == null) return;
    
    TextEditingController controller = _activeMonetaryField == 'meta' 
        ? _metaController 
        : _monthlyValueController;
        
    String currentValue = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (currentValue.length >= 9) return; // Max digits
    String newValue = currentValue + number;
    _updateMonetaryValue(controller, newValue);
  }

  void _onBackspacePressed() {
    if (_activeMonetaryField == null) return;

    TextEditingController controller = _activeMonetaryField == 'meta' 
        ? _metaController 
        : _monthlyValueController;

    String currentValue = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (currentValue.isNotEmpty) {
      String newValue = currentValue.substring(0, currentValue.length - 1);
      _updateMonetaryValue(controller, newValue);
    }
  }

  void _updateMonetaryValue(TextEditingController controller, String rawValue) {
      if (rawValue.isEmpty) rawValue = '0';
      double value = double.parse(rawValue) / 100;
      final formatted = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
      
      setState(() {
        controller.text = formatted;
      });
  }

  @override
  Widget build(BuildContext context) {
    // Watch user to get default payment unit
    final userAsync = ref.watch(usuarioProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
       padding: EdgeInsets.only(
         bottom: bottomInset, // Handle system kb inset
         left: 16,
         right: 16,
         top: 16,
       ),
       child: SingleChildScrollView(
         child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.caixinha == null ? 'Nova Caixinha' : 'Editar Caixinha',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                focusNode: _nameFocus,
                decoration: const InputDecoration(labelText: 'Nome da Caixinha'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
                onTap: () {
                  setState(() {
                    _showCustomKeyboard = false;
                    _activeMonetaryField = null;
                  });
                },
              ),
              const SizedBox(height: 12),
              
              // Meta Field (Custom Keyboard)
              GestureDetector(
                onTap: () {
                   setState(() {
                     _showCustomKeyboard = true;
                     _activeMonetaryField = 'meta';
                   });
                   FocusScope.of(context).unfocus(); 
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _metaController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Meta de Valor (Opcional)',
                      focusedBorder: _activeMonetaryField == 'meta'
                          ? const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9AFF1A), width: 2)) 
                          : null,
                      labelStyle: _activeMonetaryField == 'meta' ? const TextStyle(color: Color(0xFF9AFF1A)) : null,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Objetivo Obrigatório?'),
                subtitle: const Text('Define se os aportes são mandatórios.'),
                value: _isObrigatorio,
                onChanged: (val) {
                   setState(() {
                     _isObrigatorio = val;
                     if (val) {
                        if (_monthlyValueController.text.isEmpty && userAsync.hasValue) {
                            _monthlyValueController.text = CurrencyInputFormatter.formatDouble(userAsync.value!.unidadePagamento);
                        }
                     } else if (_activeMonetaryField == 'monthly') {
                         _showCustomKeyboard = false;
                         _activeMonetaryField = null;
                     }
                   });
                },
                contentPadding: EdgeInsets.zero,
              ),
              
              // Monthly Value Field (Custom Keyboard)
              if (_isObrigatorio) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                     setState(() {
                       _showCustomKeyboard = true;
                       _activeMonetaryField = 'monthly';
                     });
                     FocusScope.of(context).unfocus(); 
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _monthlyValueController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Valor do Aporte Mensal',
                        helperText: 'Valor padrão baseado na sua Unidade de Pagamento',
                        focusedBorder: _activeMonetaryField == 'monthly'
                            ? const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9AFF1A), width: 2)) 
                            : null,
                        labelStyle: _activeMonetaryField == 'monthly' ? const TextStyle(color: Color(0xFF9AFF1A)) : null,
                      ),
                      validator: (value) {
                        if (!_isObrigatorio) return null;
                        if (value == null || value.isEmpty) return 'Informe o valor mensal';
                        if (CurrencyInputFormatter.parseAndConvert(value) <= 0) return 'Valor deve ser maior que zero';
                        return null;
                      },
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              
              // Fixed Bottom Area
              if (!_showCustomKeyboard) 
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                   child: SizedBox(
                     width: double.infinity,
                     child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Salvar'),
                                     ),
                   ),
                ),
                
              if (_showCustomKeyboard)
                Container(
                  margin: const EdgeInsets.only(top: 10), 
                  child: NumericKeyboard(
                    onNumberPressed: _onNumberPressed,
                    onBackspacePressed: _onBackspacePressed,
                    customLeftButton: IconButton(
                       icon: const Icon(Icons.backspace_outlined),
                       onPressed: _onBackspacePressed,
                    ),
                    customRightButton: IconButton(
                       icon: const Icon(Icons.check_circle, color: Color(0xFF9AFF1A), size: 40),
                       onPressed: _submit,
                    ),
                  ),
                ),

               if (_showCustomKeyboard) const SizedBox(height: 16),
            ],
          ),
         ),
       ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
        final nome = _nomeController.text;
        final metaString = _metaController.text;
        final meta = metaString.isNotEmpty 
            ? CurrencyInputFormatter.parseAndConvert(metaString)
            : null;

        final monthlyValue = _isObrigatorio 
            ? CurrencyInputFormatter.parseAndConvert(_monthlyValueController.text)
            : null;
        
        if (widget.caixinha == null) {
          ref.read(caixinhaControllerProvider.notifier).addCaixinha(
            nome: nome,
            metaValor: meta,
            objetivoObrigatorio: _isObrigatorio,
            valorMensal: monthlyValue,
          );
        } else {
          // Update logic would go here
        }
        Navigator.pop(context);
    }
  }
}
