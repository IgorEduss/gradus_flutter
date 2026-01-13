import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/monthly_cycle_controller.dart';
import '../../controllers/wallet_controller.dart'; // For history check

class InflationSettingsScreen extends ConsumerStatefulWidget {
  const InflationSettingsScreen({super.key});

  @override
  ConsumerState<InflationSettingsScreen> createState() => _InflationSettingsScreenState();
}

class _InflationSettingsScreenState extends ConsumerState<InflationSettingsScreen> {
  final _rateController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _applyManualInflation() async {
    final rateStr = _rateController.text.replaceAll(',', '.');
    final ratePercent = double.tryParse(rateStr);

    if (ratePercent == null || ratePercent <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um valor válido positivo.')),
      );
      return;
    }

    // Convert % to decimal (e.g. 0.5 -> 0.005)
    final rateDecimal = ratePercent / 100.0;

    setState(() => _isLoading = true);

    try {
      await ref.read(monthlyCycleControllerProvider.notifier).forceInflationAdjustment(rateDecimal);
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ajuste de $ratePercent% aplicado com sucesso!'),
            backgroundColor: const Color(0xFF9DF425),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Erro ao aplicar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('Ajuste de Inflação'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajuste Manual',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Caso a atualização automática via Banco Central falhe, você pode inserir a taxa de inflação (IPCA) do mês manualmente aqui.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
            
            TextFormField(
              controller: _rateController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Taxa Mensal (%)',
                hintText: 'Ex: 0.56',
                labelStyle: const TextStyle(color: Colors.grey),
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                suffixText: '%',
                suffixStyle: const TextStyle(color: Colors.white),
              ),
            ),
            
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _applyManualInflation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9DF425),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(
                      'APLICAR AJUSTE',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
