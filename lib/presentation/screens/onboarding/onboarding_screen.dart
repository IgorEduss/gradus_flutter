import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gradus/presentation/controllers/onboarding_controller.dart';
import 'package:gradus/core/utils/currency_input_formatter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibration/vibration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/auth/numeric_keyboard.dart';
import '../../widgets/auth/pin_dots.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>(); // Used for Name step
  final _unidadeFormKey = GlobalKey<FormState>(); // Used for Unidade step
  
  // State variables
  final TextEditingController _unidadeController = TextEditingController(text: '');
  final TextEditingController _nameController = TextEditingController();
  int _diaRevisao = 5; // Default
  bool _enableInflationFacilitadores = true;
  bool _enableInflationEmprestimos = true;
  bool _enableInflationMsp = true;
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  String? _recoveryEmail;
  bool _isGoogleLoading = false;

  // PIN State
  String _currentPin = '';
  String? _firstPin;
  bool _isPinError = false;

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _pageController.dispose();
    _unidadeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 1) {
      // Validate Name step
      if (!_formKey.currentState!.validate()) return;
    }
    if (_currentPage == 2) {
      // Validate Unidade step
      final value = CurrencyInputFormatter.parseAndConvert(_unidadeController.text);
      if (value <= 0) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('O valor deve ser maior que zero')),
          );
        }
        return;
      }
    }
    
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    final unidadeValue = CurrencyInputFormatter.parseAndConvert(_unidadeController.text);

    await ref.read(onboardingControllerProvider.notifier).completeOnboarding(
      nome: _nameController.text,
      unidadePagamento: unidadeValue,
      diaRevisaoMensal: _diaRevisao,
      recoveryEmail: _recoveryEmail,
      pin: _currentPin, // Use the confirmed PIN

      enableInflationEmprestimos: _enableInflationEmprestimos,
      enableInflationFacilitadores: _enableInflationFacilitadores,
      enableInflationMsp: _enableInflationMsp,
    );

    // Check for errors
    final state = ref.read(onboardingControllerProvider);
    if (state.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: ${state.error}')),
        );
      }
    } else {
      if (mounted) {
        // Navigate to Dashboard using GoRouter
        context.go('/');
      }
    }
  }

  void _previousPage() {
    if (_currentPage == 0) return;

    // Reset PIN state if going back from confirmation step
    if (_currentPage == 7) {
      setState(() {
        _currentPin = '';
        _isPinError = false;
        // Do not reset _firstPin here, keep it in case they go forward again? 
        // Actually, if they go back to Step 5 (Creation), _currentPin will be used for creation again.
        // So we should probably clear _firstPin if we go back to Step 5? 
        // No, if we go back to Step 5, they re-enter a new pin. 
        // _handlePinComplete for Step 5 sets _firstPin.
      });
    }
    
    // If going back FROM Step 6 (Creation) to Step 5 (Security), reset PIN state entirely
    if (_currentPage == 6) {
       setState(() {
        _currentPin = '';
        _firstPin = null;
        _isPinError = false;
      });
    }

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(onboardingControllerProvider) is AsyncLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe to enforce validation
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildWelcomeStep(),
                  _buildNameStep(),
                  _buildUnidadeStep(),
                  _buildCicloStep(),

                  _buildInflationStep(), // New Step
                  _buildSecurityStep(),
                  _buildPinCreationStep(isConfirming: false), // Step 6 -> 7
                  _buildPinCreationStep(isConfirming: true),  // Step 7 -> 8
                  _buildConclusionStep(isLoading),
                ],
              ),
            ),
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(9, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo_fundo_transparente.png', width: 120, height: 120),
          const SizedBox(height: 24),
          Text(
            'Bem-vindo ao Gradus',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'O Princípio da Escada Rolante não é apenas sobre economizar, é sobre transformar oportunidades em impulso.\n\nVamos configurar seu sistema para que você possa começar a subir seus degraus.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Começar Configuração'),
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Como devemos te chamar?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'Isso é apenas para personalizar sua experiência. Seus dados ficam salvos apenas no seu dispositivo.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Seu Nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Por favor, informe seu nome';
                return null;
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Próximo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnidadeStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Form(
        key: _unidadeFormKey,
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Sua Unidade de Pagamento',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'A "Unidade" é o valor base de todos os seus compromissos. É o tamanho do "degrau" que você se sente confortável em subir consistentemente.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            // Custom Display for Value
            Center(
              child: Text(
                _unidadeController.text.isEmpty ? 'R\$ 0,00' : _unidadeController.text,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 48, // Much larger font
                  fontWeight: FontWeight.bold,
                  color: CurrencyInputFormatter.parseAndConvert(_unidadeController.text) <= 0 ? Colors.grey.withOpacity(0.5) : Colors.white,
                ),
              ),
            ),
            const Spacer(),
            // Custom Keyboard
            NumericKeyboard(
              onNumberPressed: _onUnidadeDigit,
              onBackspacePressed: _onUnidadeBackspace,
              showBiometrics: false,
              customLeftButton: TextButton(
                onPressed: () => _onUnidadeDigit('00'),
                style: TextButton.styleFrom(
                  shape: const CircleBorder(),
                  foregroundColor: const Color(0xFF9DF425),
                ),
                child: const Text(
                  '00',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
             const SizedBox(height: 16),
             ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Próximo'),
            ),
             const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _onUnidadeDigit(String digits) {
    String currentText = _unidadeController.text;
    // Clean current text to get raw digits
    String rawDigits = currentText.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Append new digits
    String newRaw = rawDigits + digits;
    
    // Max limit check (optional, but good practice to avoid overflow)
    if (newRaw.length > 12) return; 

    // Format new value
    // Format new value
    double value = double.parse(newRaw) / 100;
    
    // Using manual formatting for simplicity given we have raw cents
    final formatted = CurrencyInputFormatter.formatDouble(value);
    
    setState(() {
      _unidadeController.text = formatted;
    });
  }

  void _onUnidadeBackspace() {
    String currentText = _unidadeController.text;
    String rawDigits = currentText.replaceAll(RegExp(r'[^0-9]'), '');

    if (rawDigits.isNotEmpty) {
       String newRaw = rawDigits.substring(0, rawDigits.length - 1);
       if (newRaw.isEmpty) {
         setState(() {
           _unidadeController.text = '';
         });
       } else {
         double value = double.parse(newRaw) / 100;
         final formatted = CurrencyInputFormatter.formatDouble(value);
         setState(() {
           _unidadeController.text = formatted;
         });
       }
    }
  }

  Widget _buildCicloStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seu Ciclo Mensal',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Text(
            'Escolha o dia do mês para revisar seus compromissos. O ideal é que seja logo após o dia em que você recebe seus rendimentos.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          InkWell(
            onTap: () => _showDayPicker(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dia $_diaRevisao',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                ],
              ),
            ),
          ),

          const Spacer(),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Próximo'),
          ),
        ],
      ),
    );
  }

  void _showDayPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E), // Dark iOS style
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              // Toolbar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Confirmar', style: TextStyle(color: Color(0xFF9AFF1A), fontSize: 16)),
                    ),
                  ],
                ),
              ),
              // Picker
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    brightness: Brightness.dark,
                    textTheme: CupertinoTextThemeData(
                      pickerTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(initialItem: _diaRevisao - 1),
                    onSelectedItemChanged: (int index) {
                      setState(() {
                         _diaRevisao = index + 1;
                      });
                    },
                    children: List.generate(31, (index) {
                      return Center(child: Text('Dia ${index + 1}'));
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _buildInflationStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proteção Contra Inflação 📈',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Text(
            'Escolha onde aplicar o reajuste automático pela inflação (IPCA)',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),

          SwitchListTile(
            title: const Text('Facilitadores (Compromissos)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('Reajustar valor das parcelas', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: _enableInflationFacilitadores,
            activeColor: const Color(0xFF9AFF1A),
            contentPadding: EdgeInsets.zero,
            onChanged: (bool value) {
              setState(() => _enableInflationFacilitadores = value);
            },
          ),
          const Divider(color: Colors.white10),
          
          SwitchListTile(
            title: const Text('Empréstimos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('Reajustar saldo devedor', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: _enableInflationEmprestimos,
            activeColor: const Color(0xFF9AFF1A),
            contentPadding: EdgeInsets.zero,
            onChanged: (bool value) {
              setState(() => _enableInflationEmprestimos = value);
            },
          ),
          const Divider(color: Colors.white10),

          SwitchListTile(
            title: const Text('Caixinhas e MSP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('Reajustar depósitos obrigatórios', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: _enableInflationMsp,
            activeColor: const Color(0xFF9AFF1A),
            contentPadding: EdgeInsets.zero,
            onChanged: (bool value) {
              setState(() => _enableInflationMsp = value);
            },
          ),
          
          const Spacer(),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Próximo'),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        setState(() {
          _recoveryEmail = account.email;
        });
      }
    } catch (error) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no login Google: $error')),
        );
      }
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }

  Widget _buildSecurityStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Segurança e Recuperação',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Text(
            'Para garantir que você nunca perca o acesso aos seus dados financeiros, vinculamos sua conta Google como uma "Chave Mestra".\n\nIsso permite recuperar seu acesso caso esqueça seu PIN.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          if (_recoveryEmail != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Conta Vinculada', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        Text(_recoveryEmail!, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
             ElevatedButton.icon(
              onPressed: _isGoogleLoading ? null : _signInWithGoogle,
              icon: _isGoogleLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Icon(Icons.security),
              label: Text(_isGoogleLoading ? 'Vinculando...' : 'Vincular Conta Google'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
             const SizedBox(height: 16),
             Center(
               child: TextButton(
                onPressed: _nextPage,
                child: const Text('Pular (Não Recomendado)', style: TextStyle(color: Colors.grey)),
               ),
             ),
          ],
          const Spacer(),
          if (_recoveryEmail != null)
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Próximo'),
            ),
        ],
      ),
    );
  }

  void _onNumberPressed(String number) {
    if (_currentPin.length < 4) {
      setState(() {
        _isPinError = false;
        _currentPin += number;
      });

      if (_currentPin.length == 4) {
        _handlePinComplete();
      }
    }
  }

  void _onBackspacePressed() {
    if (_currentPin.isNotEmpty) {
      setState(() {
        _isPinError = false;
        _currentPin = _currentPin.substring(0, _currentPin.length - 1);
      });
    }
  }

  void _handlePinComplete() async {
    // Logic depends on page
    if (_currentPage == 6) {
      // Creation Step
      _firstPin = _currentPin;
      // Auto advance after small delay
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _currentPin = ''; // Reset for confirmation
      });
      _nextPage();
    } else if (_currentPage == 7) {
      // Confirmation Step
      if (_currentPin == _firstPin) {
        // Success
         await Future.delayed(const Duration(milliseconds: 300));
        _nextPage();
      } else {
        // Mismatch
        setState(() => _isPinError = true);
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate();
        }
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          _currentPin = ''; 
           _isPinError = false;
          // Go back to creation step to retry
          _currentPage = 6; 
          _pageController.animateToPage(6, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        });
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Os códigos não coincidem. Tente novamente.')),
          );
        }
      }
    }
  }

  Widget _buildPinCreationStep({required bool isConfirming}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text(
            isConfirming ? 'Confirme seu código' : 'Crie seu código de acesso',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            isConfirming 
              ? 'Digite novamente para confirmar.' 
              : 'Esse código será solicitado sempre que você abrir o aplicativo.',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
           const SizedBox(height: 32),
           // Show dots only for current step interaction
           // If we are confirming, we use _currentPin. 
           // If creating, we use _currentPin.
           // Since we reset _currentPin between steps, this works.
           PinDots(
                  pinLength: 4,
                  currentLength: _currentPin.length,
                  isError: _isPinError,
            ),
           const Spacer(),
           NumericKeyboard(
              onNumberPressed: _onNumberPressed,
              onBackspacePressed: _onBackspacePressed,
              // No biometrics on creation flow
              showBiometrics: false, 
            ),
            const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildConclusionStep(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          const SizedBox(height: 24),
          Text(
            'Tudo Pronto!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            'Seu sistema Gradus está configurado.\n\nAgora você pode começar a registrar seus facilitadores e transformar economias em patrimônio.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: isLoading ? null : _finishOnboarding,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Ir para o Dashboard'),
          ),
        ],
      ),
    );
  }
} // End Class
