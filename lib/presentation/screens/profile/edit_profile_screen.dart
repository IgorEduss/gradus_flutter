import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/currency_input_formatter.dart';
import '../../../domain/entities/usuario.dart';
import '../../../domain/repositories/i_usuario_repository.dart';
import '../../widgets/auth/numeric_keyboard.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final Usuario usuario;

  const EditProfileScreen({super.key, required this.usuario});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _unitController;
  late int _diaRevisao;
  late bool _inflacaoEmprestimos;
  late bool _inflacaoFacilitadores;
  late bool _inflacaoMsp;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.usuario.nome);
    _unitController = TextEditingController(
      text: CurrencyInputFormatter.formatDouble(widget.usuario.unidadePagamento),
    );
    _diaRevisao = widget.usuario.diaRevisaoMensal;
    _inflacaoEmprestimos = widget.usuario.inflacaoAplicarFerEmprestimos;
    _inflacaoFacilitadores = widget.usuario.inflacaoAplicarFerFacilitadores;
    _inflacaoMsp = widget.usuario.inflacaoAplicarMspDepositos;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
     double unitValue = CurrencyInputFormatter.parseAndConvert(_unitController.text);
     if (unitValue <= 0) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unidade de pagamento inválida')));
       return;
     }

     final updatedUser = Usuario(
       id: widget.usuario.id,
       userCloudId: widget.usuario.userCloudId,
       nome: _nameController.text,
       unidadePagamento: unitValue,
       diaRevisaoMensal: _diaRevisao,
       inflacaoAplicarFerEmprestimos: _inflacaoEmprestimos,
       inflacaoAplicarFerFacilitadores: _inflacaoFacilitadores,
       inflacaoAplicarMspDepositos: _inflacaoMsp,
       dataCriacao: widget.usuario.dataCriacao,
       dataAtualizacao: DateTime.now(),
     );

     try {
       await GetIt.I<IUsuarioRepository>().saveUsuario(updatedUser);
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil atualizado com sucesso!')));
         Navigator.of(context).pop(true); // Return true to indicate update
       }
     } catch (e) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
       }
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Editar Perfil', style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Salvar', style: TextStyle(color: Color(0xFF9DF425), fontSize: 16)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Dados Pessoais'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Seu Nome'),
              style: const TextStyle(color: Colors.white),
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Financeiro'),
            const SizedBox(height: 16),
            
            // Payment Unit Section (Since it uses custom keyboard, maybe just a field for now or replicate the modal logic?)
            // For simplicity in this edit screen, let's use a standard field but with numeric keyboard logic if possible, 
            // or just allow standard typing for now as we are deep in the app.
            // But to be consistent with Onboarding, let's use the CurrencyInputFormatter on change.
            TextFormField(
              controller: _unitController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Unidade de Pagamento (R\$)'),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                 // Basic formatter
                 String raw = value.replaceAll(RegExp(r'[^0-9]'), '');
                 if (raw.isNotEmpty) {
                    double val = double.parse(raw) / 100;
                    String formatted = CurrencyInputFormatter.formatDouble(val);
                    if (formatted != value) {
                        _unitController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(offset: formatted.length),
                        );
                    }
                 }
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Valor base para os degraus da sua Escada Rolante.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Ciclo Mensal'),
             const SizedBox(height: 16),
             InkWell(
               onTap: () {
                 // Show Dialog Picker
                 showDialog(
                   context: context,
                   builder: (context) => AlertDialog(
                     backgroundColor: const Color(0xFF1C1C1E),
                     title: const Text('Dia de Revisão', style: TextStyle(color: Colors.white)),
                     content: SizedBox(
                       width: double.maxFinite,
                       height: 300,
                       child: GridView.builder(
                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 7,
                           mainAxisSpacing: 8,
                           crossAxisSpacing: 8,
                         ),
                         itemCount: 31,
                         itemBuilder: (context, index) {
                           final day = index + 1;
                           final isSelected = day == _diaRevisao;
                           return InkWell(
                             onTap: () {
                               setState(() => _diaRevisao = day);
                               Navigator.pop(context);
                             },
                             child: Container(
                               decoration: BoxDecoration(
                                 color: isSelected ? const Color(0xFF9DF425) : Colors.white10,
                                 shape: BoxShape.circle,
                               ),
                               alignment: Alignment.center,
                               child: Text(
                                 '$day',
                                 style: TextStyle(
                                   color: isSelected ? Colors.black : Colors.white,
                                   fontWeight: FontWeight.bold
                                 ),
                               ),
                             ),
                           );
                         },
                       ),
                     ),
                   )
                 );
               },
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.white24),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('Dia de Revisão', style: const TextStyle(color: Colors.white)),
                     Text('Dia $_diaRevisao', style: const TextStyle(color: Color(0xFF9DF425), fontWeight: FontWeight.bold)),
                   ],
                 ),
               ),
             ),

            const SizedBox(height: 32),
            _buildSectionTitle('Ajustes de Inflação (IPCA)'),
            const SizedBox(height: 8),
            const Text(
              'Defina onde a correção inflacionária deve ser aplicada automaticamente.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            
            _buildSwitchTile(
              title: 'Empréstimos FER',
              subtitle: 'Corrigir saldo devedor mensalmente',
              value: _inflacaoEmprestimos,
              onChanged: (v) => setState(() => _inflacaoEmprestimos = v),
            ),
             _buildSwitchTile(
              title: 'Facilitadores FER',
              subtitle: 'Corrigir valor dos compromissos anualmente',
              value: _inflacaoFacilitadores,
              onChanged: (v) => setState(() => _inflacaoFacilitadores = v),
            ),
             _buildSwitchTile(
              title: 'Depósitos MSP',
              subtitle: 'Corrigir meta de depósito mensalmente',
              value: _inflacaoMsp,
              onChanged: (v) => setState(() => _inflacaoMsp = v),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF9DF425)),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: const Color(0xFF1C1C1E),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF9DF425),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title, 
    required String subtitle, 
    required bool value, 
    required ValueChanged<bool> onChanged
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      value: value,
      activeColor: const Color(0xFF9DF425),
      trackColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.selected) ? const Color(0xFF9DF425).withOpacity(0.3) : Colors.grey.shade800),
      onChanged: onChanged,
    );
  }
}
