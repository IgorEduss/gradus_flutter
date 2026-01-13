import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:gradus/domain/entities/usuario.dart';
import 'package:gradus/domain/entities/fundo.dart';
import 'package:gradus/domain/repositories/i_usuario_repository.dart';
import 'package:gradus/domain/repositories/i_fundo_repository.dart';
import 'package:gradus/domain/repositories/i_auth_repository.dart';
import 'package:gradus/presentation/providers/auth_provider.dart';

class OnboardingController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is idle
  }

  Future<void> completeOnboarding({
    required String nome,
    required double unidadePagamento,
    required int diaRevisaoMensal,
    required String pin,
    String? recoveryEmail,
    required bool enableInflationEmprestimos,
    required bool enableInflationFacilitadores,
    required bool enableInflationMsp,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final usuarioRepository = GetIt.I<IUsuarioRepository>();
      final fundoRepository = GetIt.I<IFundoRepository>();
      final authRepository = GetIt.I<IAuthRepository>(); // Still needed for recovery email

      // 1. Create User
      final usuario = Usuario(
        id: 1, // Single user for local-first app
        userCloudId: null,
        nome: nome,
        unidadePagamento: unidadePagamento,
        diaRevisaoMensal: diaRevisaoMensal,
        inflacaoAplicarFerEmprestimos: enableInflationEmprestimos,
        inflacaoAplicarFerFacilitadores: enableInflationFacilitadores,
        inflacaoAplicarMspDepositos: enableInflationMsp,
        dataCriacao: DateTime.now(),
        dataAtualizacao: DateTime.now(),
      );
      await usuarioRepository.saveUsuario(usuario);

      // 2. Create Initial Funds (FER and MSP)
      // FER - Fundo Escada Rolante
      final existingFer = await fundoRepository.getFundo('FER');
      if (existingFer == null) {
        await fundoRepository.createFundo(Fundo(
          id: 0, // Auto-increment
          usuarioId: 1,
          tipoFundo: 'FER',
          nomeFundo: 'Fundo Escada Rolante',
          saldoAtual: 0.0,
          picoPatrimonioTotalAlcancado: 0.0,
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        ));
      }

      // MSP - Meu Saldo Pessoal
      final existingMsp = await fundoRepository.getFundo('MSP');
      if (existingMsp == null) {
        await fundoRepository.createFundo(Fundo(
          id: 0, // Auto-increment
          usuarioId: 1,
          tipoFundo: 'MSP',
          nomeFundo: 'Meu Saldo Pessoal',
          saldoAtual: 0.0,
          picoPatrimonioTotalAlcancado: 0.0,
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        ));
      }

      // 3. Save Recovery Email if provided
      if (recoveryEmail != null) {
        await authRepository.saveRecoveryEmail(recoveryEmail);
      }

      // 4. Save PIN and Authenticate via Provider (updates global auth state)
      await ref.read(authNotifierProvider.notifier).setPin(pin);
    });
  }
}

final onboardingControllerProvider = AsyncNotifierProvider<OnboardingController, void>(() {
  return OnboardingController();
});
