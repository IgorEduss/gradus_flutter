import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/injection.dart';
import '../../domain/repositories/i_fundo_repository.dart';
import '../../domain/repositories/i_caixinha_repository.dart';
import '../../domain/repositories/i_transacao_repository.dart';
import '../../domain/repositories/i_emprestimo_repository.dart';
import '../../domain/repositories/i_compromisso_repository.dart';

import '../../domain/repositories/i_usuario_repository.dart';

part 'repositories_providers.g.dart';

@riverpod
IFundoRepository fundoRepository(FundoRepositoryRef ref) {
  return getIt<IFundoRepository>();
}

@riverpod
ICaixinhaRepository caixinhaRepository(CaixinhaRepositoryRef ref) {
  return getIt<ICaixinhaRepository>();
}

@riverpod
ITransacaoRepository transacaoRepository(TransacaoRepositoryRef ref) {
  return getIt<ITransacaoRepository>();
}

@riverpod
IEmprestimoRepository emprestimoRepository(EmprestimoRepositoryRef ref) {
  return getIt<IEmprestimoRepository>();
}

@riverpod
ICompromissoRepository compromissoRepository(CompromissoRepositoryRef ref) {
  return getIt<ICompromissoRepository>();
}

@riverpod
IUsuarioRepository usuarioRepository(UsuarioRepositoryRef ref) {
  return getIt<IUsuarioRepository>();
}
