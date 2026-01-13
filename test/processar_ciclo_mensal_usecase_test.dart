import 'package:flutter_test/flutter_test.dart';
import 'package:gradus/domain/entities/compromisso.dart';
import 'package:gradus/domain/entities/emprestimo.dart';
import 'package:gradus/domain/entities/fundo.dart';
import 'package:gradus/domain/entities/transacao.dart';
import 'package:gradus/domain/repositories/i_compromisso_repository.dart';
import 'package:gradus/domain/repositories/i_emprestimo_repository.dart';
import 'package:gradus/domain/repositories/i_fundo_repository.dart';
import 'package:gradus/domain/repositories/i_transacao_repository.dart';
import 'package:gradus/domain/usecases/processar_ciclo_mensal_usecase.dart';

// Manual Mocks
class MockTransacaoRepository implements ITransacaoRepository {
  final List<Transacao> addedTransacoes = [];
  
  @override
  Future<void> addTransacao(Transacao transacao) async {
    addedTransacoes.add(transacao);
  }

  @override
  Future<void> runTransaction(Future<void> Function() action) async {
    await action();
  }

  @override
  Future<List<Transacao>> getExtrato({DateTime? inicio, DateTime? fim, int? fundoId}) async => [];
  
  @override
  Stream<List<Transacao>> watchUltimasTransacoes({int limit = 10}) => Stream.value([]);
}

class MockCompromissoRepository implements ICompromissoRepository {
  final Map<int, int> pagos = {};

  @override
  Future<void> registrarPagamentoParcela(int compromissoId, int numeroParcelasPagas) async {
    pagos[compromissoId] = numeroParcelasPagas;
  }

  Compromisso? createdCompromisso;

  @override
  Future<void> createCompromisso(Compromisso compromisso) async {
    createdCompromisso = compromisso;
  }
  @override
  Future<List<Compromisso>> getCompromissosDoMes(DateTime mesReferencia) async => [];
  @override
  Stream<List<Compromisso>> watchCompromissosAtivos() => Stream.value([]);
  @override
  Stream<List<Compromisso>> watchCompromissosDoMes(DateTime mesReferencia) => Stream.value([]);
  @override
  Future<void> updateValorTotal(int compromissoId, double novoValor) async {}
}

class MockEmprestimoRepository implements IEmprestimoRepository {
  Emprestimo? createdEmprestimo;

  @override
  Future<int> createEmprestimo(Emprestimo emprestimo) async {
    createdEmprestimo = emprestimo;
    return 123; // Mock ID
  }

  @override
  Future<List<Emprestimo>> getEmprestimosAtivos() async => [];
  @override
  Future<double> getSaldoDevedorTotal() async => 0;
  @override
  Future<void> quitarEmprestimo(int emprestimoId) async {}
  @override
  Future<void> updateSaldoDevedor(int emprestimoId, double novoSaldo) async {}
  @override
  Stream<List<Emprestimo>> watchEmprestimosAtivos() => Stream.value([]);
  @override
  Stream<double> watchSaldoDevedorTotal() => Stream.value(0);
}

class MockFundoRepository implements IFundoRepository {
  final Map<String, Fundo> fundos = {
    'FER': Fundo(id: 1, usuarioId: 1, tipoFundo: 'FER', nomeFundo: 'FER', saldoAtual: 1000, picoPatrimonioTotalAlcancado: 1000, dataCriacao: DateTime.now(), dataAtualizacao: DateTime.now()),
    'MSP': Fundo(id: 2, usuarioId: 1, tipoFundo: 'MSP', nomeFundo: 'MSP', saldoAtual: 500, picoPatrimonioTotalAlcancado: 0, dataCriacao: DateTime.now(), dataAtualizacao: DateTime.now()),
  };

  @override
  Future<Fundo?> getFundo(String tipoFundo) async => fundos[tipoFundo];

  @override
  Future<void> updateSaldo(int fundoId, double novoSaldo) async {
    final key = fundos.keys.firstWhere((k) => fundos[k]!.id == fundoId);
    fundos[key] = fundos[key]!.copyWith(saldoAtual: novoSaldo);
  }

  @override
  Future<void> createFundo(Fundo fundo) async {}
  @override
  Future<List<Fundo>> getAllFundos() async => fundos.values.toList();
  @override
  Stream<Fundo?> watchFundo(String tipoFundo) => Stream.value(fundos[tipoFundo]);
}

void main() {
  late ProcessarCicloMensalUseCase useCase;
  late MockTransacaoRepository transacaoRepo;
  late MockCompromissoRepository compromissoRepo;
  late MockEmprestimoRepository emprestimoRepo;
  late MockFundoRepository fundoRepo;

  setUp(() {
    transacaoRepo = MockTransacaoRepository();
    compromissoRepo = MockCompromissoRepository();
    emprestimoRepo = MockEmprestimoRepository();
    fundoRepo = MockFundoRepository();
    useCase = ProcessarCicloMensalUseCase(
      transacaoRepo,
      compromissoRepo,
      emprestimoRepo,
      fundoRepo,
    );
  });

  final compromissoFer = Compromisso(
    id: 1,
    usuarioId: 1,
    descricao: 'Aporte FER',
    tipoCompromisso: 'FACILITADOR_FER',
    valorParcela: 100,
    dataInicioCompromisso: DateTime.now(),
    dataCriacao: DateTime.now(),
    dataAtualizacao: DateTime.now(),
    numeroParcelasPagas: 0,
    statusCompromisso: 'ATIVO',
    ajusteInflacaoAplicavel: false,
  );

  final compromissoMsp = Compromisso(
    id: 2,
    usuarioId: 1,
    descricao: 'Poupança',
    tipoCompromisso: 'DEPOSITO_MSP',
    valorParcela: 50,
    dataInicioCompromisso: DateTime.now(),
    dataCriacao: DateTime.now(),
    dataAtualizacao: DateTime.now(),
    numeroParcelasPagas: 0,
    statusCompromisso: 'ATIVO',
    ajusteInflacaoAplicavel: false,
  );

  test('Scenario A: Exact Payment', () async {
    // Total Devido = 100 (FER) + 50 (MSP) = 150
    // Pago = 150
    await useCase(
      usuarioId: 1,
      valorPago: 150,
      compromissos: [compromissoFer, compromissoMsp],
      unidadePagamento: 50.0,
    );

    // Verify Commitments Paid
    expect(compromissoRepo.pagos[1], 1);
    expect(compromissoRepo.pagos[2], 1);

    // Verify Balances
    // FER: 1000 + 100 = 1100
    // MSP: 500 + 50 = 550
    expect(fundoRepo.fundos['FER']!.saldoAtual, 1100);
    expect(fundoRepo.fundos['MSP']!.saldoAtual, 550);

    // Verify No Loan
    expect(emprestimoRepo.createdEmprestimo, isNull);
  });

  test('Scenario B: Deficit (Loan Creation)', () async {
    // Total Devido = 150
    // Pago = 80 (Less than FER 100)
    // FER gets 80 from user + 20 from Loan = 100 total coverage?
    // Logic:
    // valorParaFer = 80
    // valorParaMsp = 0
    // Deficit = 100 - 80 = 20
    // Loan created for 20.
    // FER Balance Update: 1000 + 80 (user) = 1080?
    // Wait, logic in UseCase:
    // updateSaldo(fer.id, fer.saldoAtual + valorParaFer);
    // So 1000 + 80 = 1080.
    // The loan of 20 goes to cover the deficit, but where does it go?
    // In the UseCase logic I wrote:
    // await _fundoRepository.updateSaldo(fer.id, fer.saldoAtual + valorParaFer);
    // This implies the loan money DOES NOT enter the FER balance as "cash".
    // It enters as "Receivable" (Asset).
    // So Cash Balance increases by 80.
    // This seems correct for "Cash Flow".
    
    await useCase(
      usuarioId: 1,
      valorPago: 80,
      compromissos: [compromissoFer, compromissoMsp],
      unidadePagamento: 50.0,
    );

    // Verify Commitments Paid (All marked as paid in this simplified logic)
    expect(compromissoRepo.pagos[1], 1);
    expect(compromissoRepo.pagos[2], 1);

    // Verify Loan Created
    expect(emprestimoRepo.createdEmprestimo, isNotNull);
    expect(emprestimoRepo.createdEmprestimo!.valorConcedido, 20);

    // Verify Balances
    // FER: 1000 + 80 = 1080
    // MSP: 500 + 0 = 500
    expect(fundoRepo.fundos['FER']!.saldoAtual, 1080);
    expect(fundoRepo.fundos['MSP']!.saldoAtual, 500);

    // Verify Repayment Commitment Created
    expect(compromissoRepo.createdCompromisso, isNotNull);
    expect(compromissoRepo.createdCompromisso!.descricao, 'Ressarcimento');
    expect(compromissoRepo.createdCompromisso!.tipoCompromisso, 'FACILITADOR_FER');
    expect(compromissoRepo.createdCompromisso!.valorTotalComprometido, 20); // Deficit amount
    expect(compromissoRepo.createdCompromisso!.valorParcela, 50.0); // Unidade Pagamento
    expect(compromissoRepo.createdCompromisso!.numeroTotalParcelas, 1); // ceil(20/50) = 1
  });

  test('Scenario C: Surplus', () async {
    // Total Devido = 150
    // Pago = 200
    // Surplus = 50
    // Logic:
    // valorParaFer = 100
    // valorParaMsp = 200 - 100 = 100
    
    await useCase(
      usuarioId: 1,
      valorPago: 200,
      compromissos: [compromissoFer, compromissoMsp],
      unidadePagamento: 50.0,
    );

    // Verify Balances
    // FER: 1000 + 100 = 1100
    // MSP: 500 + 100 = 600
    expect(fundoRepo.fundos['FER']!.saldoAtual, 1100);
    expect(fundoRepo.fundos['MSP']!.saldoAtual, 600);
  });
}
