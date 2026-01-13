import 'package:flutter/material.dart';

class PinDots extends StatelessWidget {
  final int pinLength;
  final int currentLength;
  final bool isError;

  const PinDots({
    super.key,
    required this.pinLength,
    required this.currentLength,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        final isFilled = index < currentLength;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isError
                ? Colors.redAccent
                : isFilled
                    ? const Color(0xFF9DF425) // Lime Green
                    : Colors.white10,
            border: Border.all(
              color: isError
                  ? Colors.redAccent
                  : isFilled
                      ? const Color(0xFF9DF425)
                      : Colors.white30,
              width: 1,
            ),
          ),
        );
      }),
    );
  }
}
