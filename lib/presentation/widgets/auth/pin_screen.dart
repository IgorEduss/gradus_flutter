import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../controllers/security_controller.dart';
import 'numeric_keyboard.dart';
import 'pin_dots.dart';

enum PinMode { create, verify, change }

class PinScreen extends ConsumerStatefulWidget {
  final PinMode mode;
  final VoidCallback? onSuccess; // For verified/created
  final bool canCancel;

  const PinScreen({
    super.key, 
    required this.mode, 
    this.onSuccess,
    this.canCancel = true,
  });

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  String _currentPin = '';
  String _tempPin = ''; // For creation/change steps
  int _step = 0; // 0: Enter/Create, 1: Confirm, 2: Old (for change), 3: New, 4: Confirm New
  bool _isError = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _updateMessage();
  }

  void _updateMessage() {
    if (widget.mode == PinMode.verify) {
      _message = 'Digite seu PIN';
    } else if (widget.mode == PinMode.create) {
      if (_step == 0) _message = 'Crie um PIN de 4 dígitos';
      else _message = 'Confirme seu PIN';
    } else { // Change
      if (_step == 0) _message = 'Digite seu PIN atual';
      else if (_step == 1) _message = 'Digite o novo PIN';
      else _message = 'Confirme o novo PIN';
    }
    setState(() {});
  }

  void _handleNumber(String number) {
    if (_currentPin.length < 4) {
      setState(() {
        _currentPin += number;
        _isError = false;
      });
    }

    if (_currentPin.length == 4) {
      _onSubmit();
    }
  }

  Future<void> _onSubmit() async {
    // Logic based on mode and step
    final controller = ref.read(securityControllerProvider.notifier);
    
    if (widget.mode == PinMode.verify) {
      final isValid = await controller.verifyPin(_currentPin);
      if (isValid) {
        widget.onSuccess?.call();
        if (mounted) Navigator.pop(context, true);
      } else {
        _showError();
      }
    } else if (widget.mode == PinMode.create) {
      if (_step == 0) {
        // First entry
        setState(() {
          _tempPin = _currentPin;
          _currentPin = '';
          _step = 1;
          _updateMessage();
        });
      } else {
        // Confirm
        if (_currentPin == _tempPin) {
          await controller.setPin(_currentPin);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN criado com sucesso!')));
            widget.onSuccess?.call();
            Navigator.pop(context, true);
          }
        } else {
           _showError('Os PINs não coincidem');
           Future.delayed(const Duration(milliseconds: 1000), () {
             setState(() {
               _step = 0;
               _currentPin = '';
               _tempPin = '';
               _updateMessage();
               _isError = false;
             });
           });
        }
      }
    } else if (widget.mode == PinMode.change) {
       if (_step == 0) {
         // Verify old
         final isValid = await controller.verifyPin(_currentPin);
         if (isValid) {
            setState(() {
              _step = 1;
              _currentPin = '';
              _updateMessage();
            });
         } else {
            _showError();
         }
       } else if (_step == 1) {
         // Enter new
         setState(() {
           _tempPin = _currentPin;
           _currentPin = '';
           _step = 2;
           _updateMessage();
         });
       } else {
         // Confirm new
         if (_currentPin == _tempPin) {
            await controller.setPin(_currentPin);
             if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN alterado com sucesso!')));
              widget.onSuccess?.call();
              Navigator.pop(context, true);
            }
         } else {
            _showError('Os PINs não coincidem');
             Future.delayed(const Duration(milliseconds: 1000), () {
             setState(() {
               _step = 1;
               _currentPin = '';
               _tempPin = '';
               _updateMessage();
               _isError = false;
             });
           });
         }
       }
    }
  }

  void _showError([String msg = 'PIN Incorreto']) {
    setState(() {
      _isError = true;
      _message = msg;
    });
    Vibration.vibrate(duration: 200);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _currentPin = '';
          _isError = false;
          _updateMessage();
        });
      }
    });
  }

  void _handleBackspace() {
    if (_currentPin.isNotEmpty) {
      setState(() {
        _currentPin = _currentPin.substring(0, _currentPin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.canCancel 
          ? IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))
          : null,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Text(
               _message,
               style: GoogleFonts.spaceGrotesk(
                 color: _isError ? Colors.redAccent : Colors.white,
                 fontSize: 24,
                 fontWeight: FontWeight.bold,
               ),
             ),
             const SizedBox(height: 40),
             PinDots(pinLength: 4, currentLength: _currentPin.length, isError: _isError),
             const Spacer(),
             NumericKeyboard(
               onNumberPressed: _handleNumber,
               onBackspacePressed: _handleBackspace,
               showBiometrics: false,
             ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
