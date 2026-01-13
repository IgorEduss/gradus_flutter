import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gradus/domain/entities/compromisso.dart';
import '../auth/numeric_keyboard.dart';

class DepositModal extends StatefulWidget {
  final Compromisso compromisso;
  final Function(double valor) onConfirm;

  const DepositModal({
    super.key,
    required this.compromisso,
    required this.onConfirm,
  });

  @override
  State<DepositModal> createState() => _DepositModalState();
}

class _DepositModalState extends State<DepositModal> {
  String _amount = '';
  final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    // Start with default installment value
    double initialValue = widget.compromisso.valorParcela;
    // Format to string removing symbol and non-numeric chars for internal state if needed, 
    // but simpler to just start empty or with pre-filled string representation.
    // Let's start with the installment value pre-filled.
    _amount = (initialValue * 100).toInt().toString(); 
  }

  void _onNumberPressed(String number) {
    setState(() {
      _amount += number;
    });
  }

  void _onBackspacePressed() {
    if (_amount.isNotEmpty) {
      setState(() {
        _amount = _amount.substring(0, _amount.length - 1);
      });
    }
  }

  double get _currentValue {
    if (_amount.isEmpty) return 0.0;
    return double.parse(_amount) / 100;
  }

  @override
  Widget build(BuildContext context) {
    final double valorParcela = widget.compromisso.valorParcela;
    final double valorAtual = _currentValue;
    
    // Calculate how many installments this amount covers (partially or fully)
    final double qtdParcelas = valorAtual / valorParcela;
    String infoText;
    
    if (valorAtual == 0) {
      infoText = 'Digite o valor do depósito';
    } else if (valorAtual % valorParcela == 0) {
      final int parcelasInteiras = qtdParcelas.toInt();
      infoText = 'Isso quitará $parcelasInteiras ${parcelasInteiras == 1 ? "parcela" : "parcelas"}';
    } else {
      final int parcelasInteiras = qtdParcelas.floor();
      final double resto = valorAtual - (parcelasInteiras * valorParcela);
      
      if (parcelasInteiras > 0) {
        infoText = 'Isso quitará $parcelasInteiras ${parcelasInteiras == 1 ? "parcela" : "parcelas"} e amortizará ${NumberFormat.simpleCurrency(locale: 'pt_BR').format(resto)}';
      } else {
        infoText = 'Isso amortizará ${NumberFormat.simpleCurrency(locale: 'pt_BR').format(valorAtual)} do saldo devedor';
      }
    }


    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Header: Drag handle + Close Button
          Stack(
            alignment: Alignment.center,
            children: [
              // Centered Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Right-aligned Close Button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Text(
            'Quanto você quer depositar?',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          
          // Amount Display
          Text(
            _currencyFormat.format(valorAtual),
            style: const TextStyle(
              color: Color(0xFF9DF425),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Dynamic Info Text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              infoText,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          
          const Spacer(),
          
          // Numeric Keyboard
          NumericKeyboard(
            onNumberPressed: _onNumberPressed,
            onBackspacePressed: _onBackspacePressed,
            customLeftButton: TextButton(
               onPressed: () {
                 setState(() {
                   _amount = '';
                 });
               },
               child: const Text('C', style: TextStyle(color: Colors.red, fontSize: 24)),
            ),
            customRightButton: IconButton(
               icon: const Icon(Icons.backspace_outlined, color: Colors.white, size: 28),
               onPressed: _onBackspacePressed,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: valorAtual > 0 
                    ? () => widget.onConfirm(valorAtual)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9DF425),
                  disabledBackgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'CONFIRMAR PAGAMENTO',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
