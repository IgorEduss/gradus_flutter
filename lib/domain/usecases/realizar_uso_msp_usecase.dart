import 'package:injectable/injectable.dart';
import '../entities/transacao.dart';
import '../repositories/i_transacao_repository.dart';
import '../repositories/i_fundo_repository.dart';
import '../repositories/i_emprestimo_repository.dart';

enum TipoUsoMsp {
  gastoPessoal,
  amortizacaoEmprestimo,
}

@injectable
class RealizarUsoMspUseCase {
  final ITransacaoRepository _transacaoRepository;
  final IFundoRepository _fundoRepository;
  final IEmprestimoRepository _emprestimoRepository;

  RealizarUsoMspUseCase(
    this._transacaoRepository,
    this._fundoRepository,
    this._emprestimoRepository,
  );

  Future<void> call({
    required int usuarioId,
    required double valor,
    required String descricao,
    required TipoUsoMsp tipoUso,
    int? emprestimoId, 
  }) async {
    await _transacaoRepository.runTransaction(() async {
      // 1. Obter e Validar MSP
      final msp = await _fundoRepository.getFundo('MSP');
      if (msp == null) throw Exception('Fundo MSP não encontrado.');

      // 2. Debitar do MSP
      // Nota: Não estamos bloqueando saldo negativo por enquanto, conforme comportamento do sistema.
      final novoSaldoMsp = msp.saldoAtual - valor;
      await _fundoRepository.updateSaldo(msp.id, novoSaldoMsp);

      if (tipoUso == TipoUsoMsp.amortizacaoEmprestimo) {
        if (emprestimoId == null) throw Exception('ID do empréstimo obrigatório para amortização.');

        // 3. Lógica de Amortização
        final emprestimos = await _emprestimoRepository.getEmprestimosAtivos();
        final emprestimo = emprestimos.firstWhere(
          (e) => e.id == emprestimoId, 
          orElse: () => throw Exception('Empréstimo não encontrado ou não ativo.')
        );

        if (emprestimo.usuarioId != usuarioId) throw Exception('Empréstimo não pertence ao usuário.');

        double novoSaldoDevedor = emprestimo.saldoDevedorAtual - valor;
        
        // Se o valor pago for maior que o saldo devedor, o excedente deve retornar ao MSP?
        // Por simplicidade, assumo que a UI valida isso ou permitimos "troco" (não implementado aqui).
        // Vamos apenas zerar e assumir que o usuário sabe o que faz, ou lançar erro se valor > saldoDevedor?
        // DTA não especifica, mas boa prática é limitar ao saldo devedor.
        if (novoSaldoDevedor < -0.01) { // margem erro float
             throw Exception('O valor da amortização excede o saldo devedor (R\$ ${emprestimo.saldoDevedorAtual.toStringAsFixed(2)}).');
        }
        if (novoSaldoDevedor < 0) novoSaldoDevedor = 0;

        await _emprestimoRepository.updateSaldoDevedor(emprestimo.id, novoSaldoDevedor);

        if (novoSaldoDevedor == 0) {
          await _emprestimoRepository.quitarEmprestimo(emprestimo.id);
        }

        // Registrar Transação
        // Tipo: "SAIDA" do MSP, mas com flag específica ou descrição clara.
        // O sistema usa tipos de transação como strings. Vamos usar um específico.
        await _transacaoRepository.addTransacao(Transacao(
          id: 0,
          usuarioId: usuarioId,
          valor: valor,
          dataTransacao: DateTime.now(),
          descricao: descricao.isEmpty ? 'Amortização de Empréstimo #${emprestimo.id}' : descricao,
          tipoTransacao: 'AMORTIZACAO_COM_MSP',
          fundoPrincipalOrigemId: msp.id,
          emprestimoId: emprestimo.id,
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        ));

      } else {
        // 4. Lógica de Gasto Pessoal
        await _transacaoRepository.addTransacao(Transacao(
          id: 0,
          usuarioId: usuarioId,
          valor: valor,
          dataTransacao: DateTime.now(),
          descricao: descricao.isEmpty ? 'Gasto Pessoal' : descricao,
          tipoTransacao: 'USO_SALDO_PESSOAL',
          fundoPrincipalOrigemId: msp.id,
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        ));
      }
    });
  }
}
