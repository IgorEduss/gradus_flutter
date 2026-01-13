import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/compromisso.dart';
import '../../domain/entities/emprestimo.dart';
import '../../domain/repositories/i_compromisso_repository.dart';
import '../../domain/repositories/i_emprestimo_repository.dart';
import '../../domain/repositories/i_fundo_repository.dart';

part 'commitment_controller.g.dart';

@riverpod
class CommitmentController extends _$CommitmentController {
  @override
  FutureOr<void> build() {
    // Initial state is void (idle)
  }

  Future<void> addCommitment({
    required String descricao,
    required double valorParcela,
    required DateTime dataInicio,
    required int usuarioId,
    int? numeroTotalParcelas,
    double? valorTotalComprometido,
    String tipoCompromisso = 'FACILITADOR_FER', // FACILITADOR_FER, DEPOSITO_MSP
  }) async {
    state = const AsyncLoading();
    
    try {
      final repository = GetIt.I<ICompromissoRepository>();
      final fundoRepository = GetIt.I<IFundoRepository>();

      // Determinar o fundo de destino com base no tipo
      int? destinoId;
      if (tipoCompromisso == 'FACILITADOR_FER' || tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO') {
        final fer = await fundoRepository.getFundo('FER');
        destinoId = fer?.id;
      } else if (tipoCompromisso == 'DEPOSITO_MSP') {
        final msp = await fundoRepository.getFundo('MSP');
        destinoId = msp?.id;
      }

      final novoCompromisso = Compromisso(
        id: 0, // ID gerado pelo banco
        usuarioId: usuarioId,
        descricao: descricao,
        tipoCompromisso: tipoCompromisso,
        valorParcela: valorParcela,
        numeroTotalParcelas: numeroTotalParcelas,
        valorTotalComprometido: valorTotalComprometido,
        numeroParcelasPagas: 0,
        fundoPrincipalDestinoId: destinoId, // Vincula ao fundo correto
        dataInicioCompromisso: dataInicio,
        dataProximoVencimento: dataInicio, // Inicialmente o mesmo
        statusCompromisso: 'ATIVO',
        ajusteInflacaoAplicavel: false, // Default por enquanto
        dataCriacao: DateTime.now(),
        dataAtualizacao: DateTime.now(),
      );

      await repository.createCompromisso(novoCompromisso);
      
      // Lógica específica para Empréstimo
      if (tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO' && valorTotalComprometido != null && destinoId != null) {
          final emprestimoRepo = GetIt.I<IEmprestimoRepository>();
          
          // 1. Criar registro de Empréstimo
          final novoEmprestimo = Emprestimo(
              id: 0,
              usuarioId: usuarioId,
              fundoOrigemId: destinoId, // O fundo de destino do compromisso (FER) é a origem do dinheiro emprestado
              valorConcedido: valorTotalComprometido,
              saldoDevedorAtual: valorTotalComprometido,
              proposito: descricao,
              statusEmprestimo: 'ATIVO',
              dataConcessao: dataInicio,
              dataCriacao: DateTime.now(),
              dataAtualizacao: DateTime.now(),
          );
          
          await emprestimoRepo.createEmprestimo(novoEmprestimo);

          // 2. Debitar o valor do saldo do FER
          // Precisamos buscar o saldo atualizado primeiro para garantir inconsistência? 
          // O updateSaldo geralmente é "set", não "decrement". Vamos buscar o fundo novamente ou usar a ref que já temos se for recente.
          final ferAtualizado = await fundoRepository.getFundo('FER');
          if (ferAtualizado != null) {
              final novoSaldo = ferAtualizado.saldoAtual - valorTotalComprometido;
              await fundoRepository.updateSaldo(ferAtualizado.id, novoSaldo);
          }
      }
      
      // Explicitly set data if successful, though void
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateCommitment({
    required Compromisso compromissoOriginal,
    String? descricao,
    double? valorParcela,
    DateTime? dataInicio,
    int? numeroTotalParcelas,
    double? valorTotalComprometido,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = GetIt.I<ICompromissoRepository>();
      
      final updatedCompromisso = compromissoOriginal.copyWith(
        descricao: descricao ?? compromissoOriginal.descricao,
        valorParcela: valorParcela ?? compromissoOriginal.valorParcela,
        dataInicioCompromisso: dataInicio ?? compromissoOriginal.dataInicioCompromisso,
        numeroTotalParcelas: numeroTotalParcelas ?? compromissoOriginal.numeroTotalParcelas,
        valorTotalComprometido: valorTotalComprometido ?? compromissoOriginal.valorTotalComprometido,
        // Reset warnings or other fields if critical values changed? 
        // For now, keep it simple.
        dataAtualizacao: DateTime.now(),
      );

      await repository.updateCompromisso(updatedCompromisso);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<Emprestimo>> debugFetchActiveLoans() async {
      final emprestimoRepo = GetIt.I<IEmprestimoRepository>();
      return await emprestimoRepo.getEmprestimosAtivos();
  }

  Future<void> debugForceDeleteLoan(int loanId) async {
      final emprestimoRepo = GetIt.I<IEmprestimoRepository>();
      final fundoRepository = GetIt.I<IFundoRepository>();
      
      // Revert saldo first?
      // Since this is a force delete "ghost", likely the money is already gone from FER
      // and we want to recover it?
      // Or maybe the user just wants to clear the record because it's wrong?
      // Let's assume we want to REFUND the FER for these ghosts.
      // But verify if we should.
      // Let's give the option in UI? Too complex.
      // Let's safe default: Refund Saldo Devedor to FER.
       try {
         final loans = await emprestimoRepo.getEmprestimosAtivos();
         final loan = loans.firstWhere((l) => l.id == loanId);
         
         final fer = await fundoRepository.getFundo('FER');
         if (fer != null) {
             await fundoRepository.updateSaldo(fer.id, fer.saldoAtual + loan.saldoDevedorAtual);
         }
         
         await emprestimoRepo.deleteEmprestimo(loanId);
       } catch (e) {
         // handle
       }
  }

  Future<void> deleteCommitment(Compromisso compromisso) async {
    state = const AsyncLoading();
    try {
      final repository = GetIt.I<ICompromissoRepository>();
      final emprestimoRepo = GetIt.I<IEmprestimoRepository>(); // Inject/Get repositories
      final fundoRepository = GetIt.I<IFundoRepository>();

      // Lógica de Reversão de Empréstimo
      if (compromisso.tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO') {
         // 1. Encontrar o empréstimo correspondente
         final emprestimos = await emprestimoRepo.getEmprestimosAtivos();
         try {
             final emprestimo = emprestimos.firstWhere(
                 (e) => e.proposito == compromisso.descricao && e.statusEmprestimo == 'ATIVO',
             );
             
             // 2. Excluir o empréstimo (Soft delete)
             await emprestimoRepo.deleteEmprestimo(emprestimo.id);
             
             // 3. Estornar o saldo ao FER
             final valorAEstornar = emprestimo.saldoDevedorAtual;
             
             final fer = await fundoRepository.getFundo('FER');
             if (fer != null) {
                 await fundoRepository.updateSaldo(fer.id, fer.saldoAtual + valorAEstornar);
             }
             
         } catch (_) {
             // Empréstimo não encontrado ou erro
         }
      }

      await repository.deleteCompromisso(compromisso.id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
       state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
Stream<List<Compromisso>> activeCommitments(ActiveCommitmentsRef ref) {
  final repository = GetIt.I<ICompromissoRepository>();
  return repository.watchCompromissosAtivos(); // Assumindo que retorna todos por enquanto, filtrar se necessário
}
