// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;

import '../../data/local/db/app_database.dart' as _i782;
import '../../data/repositories/auth_repository_impl.dart' as _i895;
import '../../data/repositories/caixinha_repository_impl.dart' as _i1007;
import '../../data/repositories/compromisso_repository_impl.dart' as _i835;
import '../../data/repositories/emprestimo_repository_impl.dart' as _i704;
import '../../data/repositories/fundo_repository_impl.dart' as _i815;
import '../../data/repositories/transacao_repository_impl.dart' as _i874;
import '../../data/repositories/usuario_repository_impl.dart' as _i273;
import '../../domain/repositories/i_auth_repository.dart' as _i841;
import '../../domain/repositories/i_caixinha_repository.dart' as _i49;
import '../../domain/repositories/i_compromisso_repository.dart' as _i191;
import '../../domain/repositories/i_emprestimo_repository.dart' as _i192;
import '../../domain/repositories/i_fundo_repository.dart' as _i972;
import '../../domain/repositories/i_transacao_repository.dart' as _i909;
import '../../domain/repositories/i_usuario_repository.dart' as _i300;
import '../../domain/usecases/calcular_inflacao_usecase.dart' as _i812;
import '../../domain/usecases/conciliar_saldos_usecase.dart' as _i142;
import '../../domain/usecases/processar_ciclo_mensal_usecase.dart' as _i1021;
import '../../domain/usecases/realizar_deposito_msp_usecase.dart' as _i31;
import '../../domain/usecases/realizar_deposito_usecase.dart' as _i53;
import '../../domain/usecases/realizar_uso_msp_usecase.dart' as _i280;
import '../../infrastructure/services/inflation_service.dart' as _i330;
import '../services/backup_service.dart' as _i832;
import 'app_module.dart' as _i460;
import 'database_module.dart' as _i384;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    final appModule = _$AppModule();
    gh.singleton<_i782.AppDatabase>(() => databaseModule.appDatabase);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.lazySingleton<_i152.LocalAuthentication>(() => appModule.localAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => appModule.googleSignIn);
    gh.factory<_i330.IInflationService>(() => _i330.InflationService());
    gh.lazySingleton<_i832.BackupService>(
      () => _i832.BackupService(
        gh<_i116.GoogleSignIn>(),
        gh<_i782.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i192.IEmprestimoRepository>(
      () => _i704.EmprestimoRepositoryImpl(gh<_i782.AppDatabase>()),
    );
    gh.lazySingleton<_i191.ICompromissoRepository>(
      () => _i835.CompromissoRepositoryImpl(gh<_i782.AppDatabase>()),
    );
    gh.lazySingleton<_i909.ITransacaoRepository>(
      () => _i874.TransacaoRepositoryImpl(gh<_i782.AppDatabase>()),
    );
    gh.lazySingleton<_i972.IFundoRepository>(
      () => _i815.FundoRepositoryImpl(gh<_i782.AppDatabase>()),
    );
    gh.factory<_i812.CalcularInflacaoUseCase>(
      () => _i812.CalcularInflacaoUseCase(
        gh<_i192.IEmprestimoRepository>(),
        gh<_i191.ICompromissoRepository>(),
        gh<_i909.ITransacaoRepository>(),
        gh<_i330.IInflationService>(),
      ),
    );
    gh.lazySingleton<_i841.IAuthRepository>(
      () => _i895.AuthRepositoryImpl(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i152.LocalAuthentication>(),
      ),
    );
    gh.lazySingleton<_i300.IUsuarioRepository>(
      () => _i273.UsuarioRepositoryImpl(gh<_i782.AppDatabase>()),
    );
    gh.lazySingleton<_i49.ICaixinhaRepository>(
      () => _i1007.CaixinhaRepositoryImpl(gh<_i782.AppDatabase>()),
    );
    gh.factory<_i53.RealizarDepositoUseCase>(
      () => _i53.RealizarDepositoUseCase(
        gh<_i909.ITransacaoRepository>(),
        gh<_i191.ICompromissoRepository>(),
        gh<_i300.IUsuarioRepository>(),
        gh<_i972.IFundoRepository>(),
        gh<_i192.IEmprestimoRepository>(),
      ),
    );
    gh.factory<_i1021.ProcessarCicloMensalUseCase>(
      () => _i1021.ProcessarCicloMensalUseCase(
        gh<_i909.ITransacaoRepository>(),
        gh<_i191.ICompromissoRepository>(),
        gh<_i192.IEmprestimoRepository>(),
        gh<_i972.IFundoRepository>(),
      ),
    );
    gh.factory<_i142.ConciliarSaldosUseCase>(
      () => _i142.ConciliarSaldosUseCase(
        gh<_i909.ITransacaoRepository>(),
        gh<_i972.IFundoRepository>(),
        gh<_i49.ICaixinhaRepository>(),
        gh<_i192.IEmprestimoRepository>(),
      ),
    );
    gh.factory<_i280.RealizarUsoMspUseCase>(
      () => _i280.RealizarUsoMspUseCase(
        gh<_i909.ITransacaoRepository>(),
        gh<_i972.IFundoRepository>(),
        gh<_i192.IEmprestimoRepository>(),
      ),
    );
    gh.factory<_i31.RealizarDepositoMspUseCase>(
      () => _i31.RealizarDepositoMspUseCase(
        gh<_i909.ITransacaoRepository>(),
        gh<_i972.IFundoRepository>(),
        gh<_i49.ICaixinhaRepository>(),
      ),
    );
    return this;
  }
}

class _$DatabaseModule extends _i384.DatabaseModule {}

class _$AppModule extends _i460.AppModule {}
