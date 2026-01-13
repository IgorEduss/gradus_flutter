import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/caixinha.dart';
import '../../domain/repositories/i_caixinha_repository.dart';
import '../../domain/repositories/i_compromisso_repository.dart';
import '../../domain/repositories/i_usuario_repository.dart';
import '../../domain/repositories/i_fundo_repository.dart';
import '../../domain/repositories/i_transacao_repository.dart';
import '../../domain/entities/compromisso.dart';
import '../../domain/entities/transacao.dart';

part 'caixinha_controller.g.dart';

@riverpod
class CaixinhaController extends _$CaixinhaController {
  @override
  Stream<List<Caixinha>> build() {
    final repository = GetIt.I<ICaixinhaRepository>();
    return repository.watchCaixinhas();
  }

  Future<void> addCaixinha({
    required String nome,
    double? metaValor,
    bool objetivoObrigatorio = false,
    double? valorMensal, // Optional custom value for mandatory commitment
  }) async {
    final caixinhaRepository = GetIt.I<ICaixinhaRepository>();
    final compromissoRepository = GetIt.I<ICompromissoRepository>();
    final usuarioRepository = GetIt.I<IUsuarioRepository>();

    // 1. Fetch User for ID and UnidadePagamento
    final user = await usuarioRepository.getUsuario();
    if (user == null) throw Exception('Usuário não encontrado');

    final novaCaixinha = Caixinha(
      id: 0, // Auto-generated
      usuarioId: user.id,
      nomeCaixinha: nome,
      saldoAtual: 0.0,
      metaValor: metaValor,
      depositoObrigatorio: objetivoObrigatorio,
      statusCaixinha: 'ATIVA',
      dataCriacao: DateTime.now(),
      dataAtualizacao: DateTime.now(),
    );

    // 2. Create Caixinha and get ID
    final caixinhaId = await caixinhaRepository.createCaixinha(novaCaixinha);

    // 3. Create Commitment if mandatory
    if (objetivoObrigatorio) {
      // Use provided valorMensal, or fallback to user default, or 0 if somehow null
      final valorParcela = valorMensal ?? user.unidadePagamento;
      
      await compromissoRepository.createCompromisso(Compromisso(
        id: 0,
        usuarioId: user.id,
        descricao: 'Aporte: $nome',
        tipoCompromisso: 'CAIXINHA_MSP',
        valorTotalComprometido: null, 
        valorParcela: valorParcela,
        numeroTotalParcelas: null,
        numeroParcelasPagas: 0,
        fundoPrincipalDestinoId: null,
        caixinhaDestinoId: caixinhaId,
        dataInicioCompromisso: DateTime.now(),
        statusCompromisso: 'ATIVO',
        ajusteInflacaoAplicavel: true,
        dataCriacao: DateTime.now(),
        dataAtualizacao: DateTime.now(),
      ));
    }
  }

  Future<void> deleteCaixinha(int id) async {
    final caixinhaRepository = GetIt.I<ICaixinhaRepository>();
    final fundoRepository = GetIt.I<IFundoRepository>();
    final transacaoRepository = GetIt.I<ITransacaoRepository>();

    await transacaoRepository.runTransaction(() async {
      // 1. Get Caixinha details
      final caixinhas = await caixinhaRepository.getCaixinhasAtivas();
      final caixinha = caixinhas.firstWhere((c) => c.id == id, orElse: () => throw Exception('Caixinha not found'));

      // 2. Transfer Balance to MSP if > 0
      if (caixinha.saldoAtual > 0) {
        final msp = await fundoRepository.getFundo('MSP');
        if (msp != null) {
          // Update MSP
          final novoSaldoMsp = msp.saldoAtual + caixinha.saldoAtual;
          await fundoRepository.updateSaldo(msp.id, novoSaldoMsp);

          // Record Transaction
          await transacaoRepository.addTransacao(Transacao(
            id: 0,
            usuarioId: caixinha.usuarioId,
            valor: caixinha.saldoAtual,
            dataTransacao: DateTime.now(),
            descricao: 'Resgate por Exclusão: ${caixinha.nomeCaixinha}',
            tipoTransacao: 'ENTRADA', // Technically internal transfer, but MSP gains
            fundoPrincipalDestinoId: msp.id,
            caixinhaOrigemId: caixinha.id,
            dataCriacao: DateTime.now(),
            dataAtualizacao: DateTime.now(),
          ));
        }
      }

      // 3. Delete Caixinha
      await caixinhaRepository.deleteCaixinha(id);
    });
  }
}
