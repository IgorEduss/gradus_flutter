import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/commitment_controller.dart';
import '../../widgets/objectives/commitment_card.dart';
import '../../widgets/commitment_modal.dart';
import '../../../domain/entities/compromisso.dart';

class ObjectivesScreen extends ConsumerStatefulWidget {
  const ObjectivesScreen({super.key});

  @override
  ConsumerState<ObjectivesScreen> createState() => _ObjectivesScreenState();
}

class _ObjectivesScreenState extends ConsumerState<ObjectivesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCommitmentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const CommitmentModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final commitmentsAsync = ref.watch(commitmentControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Objetivos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'EM ANDAMENTO'),
            Tab(text: 'REALIZADOS'),
          ],
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: commitmentsAsync.when(
        data: (commitments) {
          final List<Compromisso> list = commitments as List<Compromisso>;
          final active = list.where((c) => c.statusCompromisso == 'ATIVO').toList();
          final completed = list.where((c) => c.statusCompromisso == 'CONCLUIDO' || c.statusCompromisso == 'QUITADO').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildList(active),
              _buildList(completed),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCommitmentModal(context),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(List<dynamic> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum objetivo encontrado.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CommitmentCard(
          compromisso: item,
          onDeposit: () {
            // Navigate to deposit or show modal
            // For now, maybe just show a snackbar or navigate to monthly cycle?
            // The image says "Depositar", likely meaning making an extra payment or just a shortcut.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funcionalidade de depósito rápido em breve.')),
            );
          },
        );
      },
    );
  }
}
