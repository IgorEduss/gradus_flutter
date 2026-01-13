import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/conciliation_controller.dart';
import '../../widgets/auth/numeric_keyboard.dart';

enum _InputTarget { realBalance, justification }

class ConciliationScreen extends ConsumerStatefulWidget {
  const ConciliationScreen({super.key});

  @override
  ConsumerState<ConciliationScreen> createState() => _ConciliationScreenState();
}

class _ConciliationScreenState extends ConsumerState<ConciliationScreen> {
  _InputTarget _activeInput = _InputTarget.realBalance;
  String _saldoRealString = '0,00';
  String _justificationString = '0,00';

  bool _hasUserTyped = false; // Flag to track interaction

  @override
  void initState() {
    super.initState();
    // Initialize controller with zero
     WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conciliationControllerProvider.notifier).updateSaldoReal(0.0);
      ref.read(conciliationControllerProvider.notifier).updateSaldoJustificado(0.0);
    });
  }

  void _onNumberPressed(String number) {
    if (_activeInput == _InputTarget.realBalance && !_hasUserTyped) {
      _hasUserTyped = true; // Mark as typed on first input
    }
    
    setState(() {
      String targetString = _activeInput == _InputTarget.realBalance ? _saldoRealString : _justificationString;
      String raw = targetString.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (raw.length >= 9) return; // Max digits check
      
      raw = raw + number;
      _updateTargetValue(raw);
    });
  }

  void _onBackspacePressed() {
    if (_activeInput == _InputTarget.realBalance && !_hasUserTyped) {
       _hasUserTyped = true;
    }

    setState(() {
      String targetString = _activeInput == _InputTarget.realBalance ? _saldoRealString : _justificationString;
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
      
      if (_activeInput == _InputTarget.realBalance) {
          _saldoRealString = formatted;
          ref.read(conciliationControllerProvider.notifier).updateSaldoReal(value);
      } else {
          _justificationString = formatted;
          ref.read(conciliationControllerProvider.notifier).updateSaldoJustificado(value);
      }
  }

  void _setActiveInput(_InputTarget target) {
    setState(() {
      _activeInput = target;
    });
  }

  Future<void> _confirm() async {
      final state = ref.read(conciliationControllerProvider).value;
      if (state == null || state.saldoRealInput <= 0) return;

      // TODO: Get real userID. Using 1 as default for now.
      ref.read(conciliationControllerProvider.notifier).confirmarConciliacao(1).then((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Conciliação realizada com sucesso!')),
          );
          Navigator.of(context).pop();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(conciliationControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF141414), // Dark background
      appBar: AppBar(
        title: const Text('Conciliação de Saldos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err', style: const TextStyle(color: Colors.red))),
        data: (state) => Container(
          child: Column(
            children: [
               Expanded(
                 child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInfoCard(
                        title: 'Saldo Virtual Esperado',
                        value: state.saldoVirtual,
                        color: Colors.grey,
                        icon: Icons.computer,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Qual o seu saldo real total hoje?',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      
                      // Custom Input: Saldo Real
                      GestureDetector(
                        onTap: () => _setActiveInput(_InputTarget.realBalance),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _activeInput == _InputTarget.realBalance 
                                    ? const Color(0xFF9AFF1A) 
                                    : Colors.grey[700]!,
                                width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text('R\$ ', style: GoogleFonts.spaceGrotesk(color: Colors.grey, fontSize: 18)),
                              Expanded(
                                child: Text(
                                  _saldoRealString,
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: _activeInput == _InputTarget.realBalance ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (_activeInput == _InputTarget.realBalance)
                                Container(
                                  width: 2,
                                  height: 24,
                                  color: const Color(0xFF9AFF1A),
                                ), 
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      if (_hasUserTyped) // Only show if user has interacted
                        _buildDifferenceSection(state),
                    ],
                  ),
                           ),
               ),
              
              // Custom Keyboard Area
              Container(
                color: const Color(0xFF1C1C1E),
                padding: const EdgeInsets.only(bottom: 24, top: 12),
                child: NumericKeyboard(
                    onNumberPressed: _onNumberPressed,
                    onBackspacePressed: _onBackspacePressed,
                    customLeftButton: IconButton(
                        icon: const Icon(Icons.backspace_outlined, size: 28, color: Colors.white),
                        onPressed: _onBackspacePressed,
                    ),
                    customRightButton: IconButton(
                        icon: Icon(Icons.check_circle, size: 48, 
                             color: state.saldoRealInput > 0 ? const Color(0xFF9AFF1A) : Colors.grey),
                        onPressed: state.saldoRealInput > 0 ? _confirm : null,
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required double value, required Color color, required IconData icon}) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 4),
              Text(currency.format(value), style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(icon, color: color, size: 32),
        ],
      ),
    );
  }

  Widget _buildDifferenceSection(ConciliationState state) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final diff = state.diferenca;
    
    Color color;
    String text;
    IconData icon;

    if (diff.abs() < 0.01) {
      color = Colors.green;
      text = 'Saldos Conciliados';
      icon = Icons.check_circle;
    } else if (diff > 0) {
      color = const Color(0xFF9DF425);
      text = 'Diferença Positiva (Rendimento)';
      icon = Icons.trending_up;
    } else {
      color = Colors.orange;
      text = 'Diferença Negativa';
      icon = Icons.warning;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color),
                      const SizedBox(width: 8),
                      Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(currency.format(diff), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              if (diff > 0) ...[
                const SizedBox(height: 8),
                const Text(
                  'O valor excedente será distribuído como rendimento entre o FER e seu Saldo Pessoal.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        if (diff < -0.01) ...[
          const SizedBox(height: 16),
          const Text(
            'Você pode justificar parte dessa diferença como "Uso Pessoal". O restante será convertido em um Empréstimo automático do FER.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          
          // Custom Input: Justificativa
          GestureDetector(
            onTap: () => _setActiveInput(_InputTarget.justification),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                    color: _activeInput == _InputTarget.justification
                        ? const Color(0xFF9AFF1A) 
                        : Colors.grey[700]!,
                     width: 1,
                ),
                borderRadius: BorderRadius.circular(4), // Slightly different radius
              ),
              child: Row(
                children: [
                  Text('Justificar valor (Uso do MSP)', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
                  const Spacer(),
                  Text(
                    'R\$ $_justificationString',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: _activeInput == _InputTarget.justification ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                   if (_activeInput == _InputTarget.justification)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        width: 2,
                        height: 16,
                        color: const Color(0xFF9AFF1A),
                      ),
                ],
              ),
            ),
          ),

          if (state.saldoJustificado < diff.abs()) ...[
            const SizedBox(height: 8),
            Text(
              'Será criado um Empréstimo de: ${currency.format(diff.abs() - state.saldoJustificado)}',
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ]
        ],
      ],
    );
  }
}
