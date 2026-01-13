import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/currency_input_formatter.dart';
import '../../core/utils/currency_input_formatter.dart';
import '../controllers/commitment_controller.dart';
import '../../domain/entities/compromisso.dart';
import '../providers/user_provider.dart';
import 'auth/numeric_keyboard.dart'; // Import NumericKeyboard

enum _InputTarget { total, installment }

class CommitmentModal extends ConsumerStatefulWidget {
  final String? initialType;
  final Compromisso? compromisso;

  const CommitmentModal({super.key, this.initialType, this.compromisso});

  @override
  ConsumerState<CommitmentModal> createState() => _CommitmentModalState();
}

class _CommitmentModalState extends ConsumerState<CommitmentModal> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  
  // State for Total Value
  String _currentValueString = '0,00';
  
  // State for Installment Value
  final _installmentValueController = TextEditingController();
  String _installmentValueString = '0,00';
  
  DateTime _startDate = DateTime.now();
  late String _commitmentType; 
  
  bool _isInitialized = false;
  double? _userPreferredInstallment;
  
  // Focus Logic
  final FocusNode _descriptionFocus = FocusNode();
  bool _showSystemKeyboard = false;
  _InputTarget _activeInput = _InputTarget.total; // Default active

  @override
  void initState() {
    super.initState();
    _descriptionFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      // If description gets focus, show system keyboard
      if (_descriptionFocus.hasFocus) {
        _showSystemKeyboard = true;
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _installmentValueController.dispose();
    _descriptionFocus.removeListener(_onFocusChange);
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    setState(() {
      String targetString = _activeInput == _InputTarget.total ? _currentValueString : _installmentValueString;
      String raw = targetString.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (raw.length >= 9) return; // Max digits check
      
      raw = raw + number;
      _updateTargetValue(raw);
    });
  }

  void _onBackspacePressed() {
    setState(() {
      String targetString = _activeInput == _InputTarget.total ? _currentValueString : _installmentValueString;
      String raw = targetString.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (raw.isNotEmpty) {
        raw = raw.substring(0, raw.length - 1);
      }
      _updateTargetValue(raw);
    });
  }

  void _updateTargetValue(String raw) {
      if (raw.isEmpty) raw = '0';
      double value = double.parse(raw) / 100;
      final formatted = NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2).format(value).trim();
      
      if (_activeInput == _InputTarget.total) {
          _currentValueString = formatted;
      } else {
          _installmentValueString = formatted;
          // Update controller to show value in field
          final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
          _installmentValueController.text = currencyFormat.format(value);
      }
  }
  
  // Replaces _recalculateInstallment largely, logic moved to explicit input
  
  double _parseValue(String formatted) {
    return double.tryParse(formatted.replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;
  }
  
  double _parseCurrentValue() => _parseValue(_currentValueString);
  double _parseInstallmentValue() => _parseValue(_installmentValueString);


  Future<void> _submit() async {
      final totalValue = _parseCurrentValue();

      if (totalValue <= 0) {
          _showErrorDialog('Valor inválido', 'Informe um valor maior que zero.');
          return;
      }
      
      if (_descriptionController.text.isEmpty) {
           _showErrorDialog('Descrição obrigatória', 'Informe uma descrição para o compromisso.');
           return;
      }

      var installmentValue = _parseInstallmentValue();
      
      if (installmentValue <= 0) {
          _showErrorDialog('Parcela inválida', 'O valor da parcela deve ser maior que zero.');
          return;
      }
      
      if (installmentValue > totalValue && totalValue > 0) {
        // Warn or auto-fix? Auto-fix to total is safer
        installmentValue = totalValue;
      }

      final userAsync = ref.read(usuarioProvider);
      final user = userAsync.value;

      if (user == null) {
          _showErrorDialog('Erro de Usuário', 'Usuário não identificado. Tente reiniciar o app.');
          return;
      }

      final numeroParcelas = (totalValue / installmentValue).ceil();

      try {
        // Show loading dialog
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (c) => const Center(child: CircularProgressIndicator()),
        );

        if (widget.compromisso != null) {
           await ref.read(commitmentControllerProvider.notifier).updateCommitment(
              compromissoOriginal: widget.compromisso!,
              descricao: _descriptionController.text,
              valorParcela: installmentValue,
              dataInicio: _startDate,
              numeroTotalParcelas: numeroParcelas,
              valorTotalComprometido: totalValue,
           );
        } else {
          await ref.read(commitmentControllerProvider.notifier).addCommitment(
                descricao: _descriptionController.text,
                valorParcela: installmentValue,
                dataInicio: _startDate,
                usuarioId: user.id,
                numeroTotalParcelas: numeroParcelas,
                valorTotalComprometido: totalValue,
                tipoCompromisso: _commitmentType,
              );
        }

        // Check for errors in state
        final state = ref.read(commitmentControllerProvider);
        
        // Close loading dialog
        if (mounted) Navigator.of(context).pop(); 

        if (state.hasError) {
             throw state.error!;
        }

        if (mounted) {
          Navigator.of(context).pop(); // Close modal
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Facilitador registrado com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog('Erro ao salvar', e.toString());
        }
      }
  }

  void _showErrorDialog(String title, String message) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text(title, style: const TextStyle(color: Colors.black)),
              content: Text(message, style: const TextStyle(color: Colors.black)),
              actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                  ),
              ],
          ),
      );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Hide keyboard if open
    FocusScope.of(context).unfocus();
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(usuarioProvider);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Initialize defaults unique time
    if (!_isInitialized && userAsync.hasValue && userAsync.value != null) {
      final user = userAsync.value!;
      
      // Initialize commitment type
      if (widget.initialType != null) {
          _commitmentType = widget.initialType!;
      } else {
          _commitmentType = widget.compromisso?.tipoCompromisso ?? 'FACILITADOR_FER';
      }

      if (widget.compromisso != null) {
          // Editing mode
          final c = widget.compromisso!;
          _descriptionController.text = c.descricao;
          _startDate = c.dataInicioCompromisso;
          
          final total = c.valorTotalComprometido ?? 0.0;
          final installment = c.valorParcela;
          
          _currentValueString = NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2).format(total).trim();
          _installmentValueString = NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2).format(installment).trim();
          _installmentValueController.text = currencyFormat.format(installment);
          
      } else {
          // Create mode defaults
          final initialInstallment = user.unidadePagamento ?? 50.0;
          
          // Init Installment String and Controller
          _installmentValueString = NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2).format(initialInstallment).trim();
          _installmentValueController.text = currencyFormat.format(initialInstallment);
          _userPreferredInstallment = initialInstallment;
          
          final now = DateTime.now();
          _startDate = DateTime(now.year, now.month, user.diaRevisaoMensal);
      }
      _isInitialized = true;
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141414), // Dark background matching screen
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Use constrained height or flex to fit keyboard
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            // Handle bar
            Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(2)),
                ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getTitle(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // 1. Hero Value Display
                    GestureDetector(
                      onTap: () {
                        setState(() {
                             _activeInput = _InputTarget.total;
                             _showSystemKeyboard = false;
                        });
                        FocusScope.of(context).unfocus();
                      },
                      child: Column(
                        children: [
                            Text(
                                'Valor Total',
                                style: TextStyle(
                                    color: _activeInput == _InputTarget.total ? const Color(0xFF9AFF1A) : Colors.grey, 
                                    fontSize: 14
                                ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'R\$ $_currentValueString',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: _activeInput == _InputTarget.total ? const Color(0xFF9AFF1A) : Colors.white60, 
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // 2. Calculation Card (Reactive)
                    Builder(
                        builder: (context) {
                          final totalValue = _parseCurrentValue();
                          var installmentValue = _parseInstallmentValue();
                          
                          // Avoid division by zero
                          if (installmentValue <= 0) installmentValue = 1.0; 
                          
                          if (totalValue <= 0) return const SizedBox(height: 100); // Placeholder space

                          final adjusted = totalValue < installmentValue;
                          if (adjusted) installmentValue = totalValue;

                          final parcelasInteiras = (totalValue / installmentValue).floor();
                          // Calculate remainder precisely
                          final valorParcelasInteiras = parcelasInteiras * installmentValue;
                          final resto = totalValue - valorParcelasInteiras;
                          
                          final temResto = resto > 0.005; // float tolerance
                          final totalParcelas = parcelasInteiras + (temResto ? 1 : 0);
                          
                           // Cálculo da data de quitação
                          final dataQuitacao = DateTime(
                            _startDate.year,
                            _startDate.month + totalParcelas,
                            _startDate.day,
                          );
                          final mesQuitacao = DateFormat('MMMM yyyy', 'pt_BR').format(dataQuitacao);
                          
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Planejamento', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                        Text('Termina em', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                    ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align top in case of multiline
                                  children: [
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                 Text(
                                                    '$totalParcelas parcelas',
                                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                 if (temResto)
                                                     Text.rich(
                                                         TextSpan(
                                                             children: [
                                                                 TextSpan(text: '$parcelasInteiras x ${currencyFormat.format(installmentValue)}'),
                                                                 TextSpan(text: ' + ', style: TextStyle(color: Colors.grey)),
                                                                 TextSpan(text: '1 x ${currencyFormat.format(resto)}'),
                                                             ],
                                                         ),
                                                         style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                                                     )
                                                 else
                                                    Text(
                                                        'de ${currencyFormat.format(installmentValue)}',
                                                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                                                    ),
                                            ],
                                        ),
                                    ),
                                    const SizedBox(width: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2), // Slight visual alignment
                                      child: Text(
                                          mesQuitacao.toUpperCase(),
                                          style: const TextStyle(color: Color(0xFF9AFF1A), fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                    ),

                    const SizedBox(height: 24),
                    
                    // 3. Inputs (Description, Installment, Date)
                    Column(
                        children: [
                            TextFormField(
                                controller: _descriptionController,
                                focusNode: _descriptionFocus, 
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    labelText: 'Descrição',
                                    labelStyle: TextStyle(color: Colors.grey[400]),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9AFF1A))),
                                ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                                children: [
                                    // Installment Value Input (ReadOnly tap)
                                    Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                                setState(() {
                                                    _activeInput = _InputTarget.installment;
                                                    _showSystemKeyboard = false;
                                                });
                                                FocusScope.of(context).unfocus();
                                            },
                                            child: AbsorbPointer( // Prevent keyboard
                                                child: TextFormField(
                                                    controller: _installmentValueController,
                                                    readOnly: true, // Key: Custom keyboard only
                                                    style: TextStyle(
                                                        color: _activeInput == _InputTarget.installment ? const Color(0xFF9AFF1A) : Colors.white
                                                    ),
                                                    decoration: InputDecoration(
                                                        labelText: 'Valor da Parcela',
                                                        labelStyle: TextStyle(
                                                            color: _activeInput == _InputTarget.installment ? const Color(0xFF9AFF1A) : Colors.grey[400]
                                                        ),
                                                        enabledBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: _activeInput == _InputTarget.installment ? const Color(0xFF9AFF1A) : Colors.grey[800]!
                                                            )
                                                        ),
                                                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9AFF1A))),
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Date Input
                                    Expanded(
                                        child: InkWell(
                                            onTap: () => _selectDate(context),
                                            child: InputDecorator(
                                                decoration: InputDecoration(
                                                    labelText: 'Data de Referência',
                                                    labelStyle: TextStyle(color: Colors.grey[400]),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                                                ),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text(dateFormat.format(_startDate), style: const TextStyle(color: Colors.white)),
                                                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                                    ],
                                                ),
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ],
                    ),
                  ],
                ),
              ),
            ),
            
            // 4. Keyboard / Button Area
            if (!_showSystemKeyboard) ...[
                // Custom Numeric Keyboard
                Container(
                    color: const Color(0xFF141414),
                    child: NumericKeyboard(
                        onNumberPressed: _onNumberPressed,
                        onBackspacePressed: _onBackspacePressed, // Still needed for param requirement but unused if replaced?
                        // Move Backspace to Left
                        customLeftButton: IconButton(
                            icon: const Icon(Icons.backspace_outlined, size: 28, color: Colors.white),
                            onPressed: _onBackspacePressed,
                        ),
                        // Submit on Right
                        customRightButton: IconButton(
                            icon: const Icon(Icons.check_circle, size: 48, color: Color(0xFF9AFF1A)),
                            onPressed: _submit,
                        ),
                    ),
                ),
            ] else ...[
                 Padding(
                     padding: EdgeInsets.only(
                         bottom: MediaQuery.of(context).viewInsets.bottom + 16, 
                         left: 16, 
                         right: 16
                     ),
                     child: ElevatedButton(
                         onPressed: _submit,
                         style: ElevatedButton.styleFrom(
                             backgroundColor: const Color(0xFF9AFF1A),
                             foregroundColor: Colors.black,
                             padding: const EdgeInsets.symmetric(vertical: 16),
                         ),
                         child: Text(_getButtonText()),
                     ),
                 ),
            ],
        ],
      ),
    );
  }

  String _getTitle() {
      if (_commitmentType == 'RESSARCIMENTO_EMPRESTIMO') {
          return widget.compromisso != null ? 'Atualizar Empréstimo' : 'Solicitar Empréstimo';
      }
      return widget.compromisso != null ? 'Editar Facilitador' : 'Novo Facilitador';
  }

  String _getButtonText() {
      if (_commitmentType == 'RESSARCIMENTO_EMPRESTIMO') {
          return widget.compromisso != null ? 'Atualizar Solicitação' : 'Confirmar Solicitação';
      }
      return widget.compromisso != null ? 'Atualizar Facilitador' : 'Salvar Facilitador';
  }
}
