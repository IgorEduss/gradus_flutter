import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumericKeyboard extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onBiometricsPressed;
  final bool showBiometrics;
  final Widget? customLeftButton;
  final Widget? customRightButton;

  const NumericKeyboard({
    super.key,
    required this.onNumberPressed,
    required this.onBackspacePressed,
    this.onBiometricsPressed,
    this.showBiometrics = false,
    this.customLeftButton,
    this.customRightButton,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 16), // Reduced from 24
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 16), // Reduced from 24
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 16), // Reduced from 24
          _buildLastRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: numbers.map((number) => _buildNumberButton(number)).toList(),
    );
  }

  Widget _buildLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Custom Left Button or Biometrics
        SizedBox(
          width: 60, // Reduced from 70
          height: 60, // Reduced from 70
          child: customLeftButton ?? (showBiometrics && onBiometricsPressed != null
              ? IconButton(
                  onPressed: onBiometricsPressed,
                  icon: const Icon(Icons.fingerprint, size: 32, color: Colors.white),
                )
              : null),
        ),
        _buildNumberButton('0'),
        // Custom Right Button or Backspace
        SizedBox(
          width: 60, // Reduced from 70
          height: 60, // Reduced from 70
          child: customRightButton ?? IconButton(
            onPressed: onBackspacePressed,
            icon: const Icon(Icons.backspace_outlined, size: 28, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      width: 60, // Reduced from 70
      height: 60, // Reduced from 70
      child: TextButton(
        onPressed: () => onNumberPressed(number),
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          foregroundColor: const Color(0xFF9DF425),
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 28, // Reduced from 32
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
