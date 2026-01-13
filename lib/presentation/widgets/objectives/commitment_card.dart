import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/compromisso.dart';

class CommitmentCard extends StatefulWidget {
  final Compromisso compromisso;
  final VoidCallback onDeposit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onHistory;
  final int diaRevisaoMensal;
  final DateTime referenceDate;

  const CommitmentCard({
    super.key,
    required this.compromisso,
    required this.onDeposit,
    required this.diaRevisaoMensal,
    required this.referenceDate,
    this.onEdit,
    this.onDelete,
    this.onHistory,
  });

  @override
  State<CommitmentCard> createState() => _CommitmentCardState();
}

class _CommitmentCardState extends State<CommitmentCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('MMM yyyy', 'pt_BR');

    // Calculations
    final total = widget.compromisso.valorTotalComprometido ?? 0.0;
    final paid = widget.compromisso.valorParcela * widget.compromisso.numeroParcelasPagas;
    final remaining = total - paid;
    final progress = total > 0 ? paid / total : 0.0;
    final percentage = (progress * 100).toInt();

    // Date calculations
    // Date calculations
    // Dynamic calculation of total installments based on current total debt
    // If we amortized, the total debt decreased, so effective remaining installments decreased.
    // Total Installments = Current Total Debt / Installment Value
    final totalParcelas = widget.compromisso.valorParcela > 0 
        ? (total / widget.compromisso.valorParcela).ceil() 
        : (widget.compromisso.numeroTotalParcelas ?? 0);
    final endDate = widget.compromisso.dataInicioCompromisso.add(Duration(days: 30 * totalParcelas));
    final now = DateTime.now();
    final monthsRemaining = endDate.difference(now).inDays ~/ 30;

    return Card(
      color: const Color(0xFF1E1E1E), // Dark card background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header Row (Always Visible)
              Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C), // Lighter circle bg
                      shape: BoxShape.circle,
                      border: _isPaidCurrentMonth 
                          ? Border.all(color: const Color(0xFF9AFF1A), width: 1)
                          : null,
                    ),
                    child: Icon(
                      widget.compromisso.tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO'
                          ? Icons.handshake
                          : Icons.track_changes,
                      color: widget.compromisso.tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO'
                          ? Colors.orangeAccent
                          : Colors.blueAccent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.compromisso.descricao,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.compromisso.tipoCompromisso == 'FACILITADOR_FER'
                              ? 'Escada Rolante'
                              : (widget.compromisso.tipoCompromisso == 'RESSARCIMENTO_EMPRESTIMO'
                                  ? 'Ressarcimento de Empréstimo'
                                  : 'Depósito MSP'),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 4),
                          Text(
                            currencyFormat.format(widget.compromisso.valorParcela),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9DF425),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Mini Graph / Percentage (Only visible when collapsed)
                  if (!_isExpanded)
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 4,
                            backgroundColor: Colors.grey[800],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9DF425)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 12),
                   Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),

              // Expanded Details
              if (_isExpanded) ...[
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF262626),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text Details
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Objetivo Total'),
                            _buildValue(currencyFormat.format(total)),
                            const SizedBox(height: 12),
                            _buildLabel('Período'),
                            _buildValue('${dateFormat.format(widget.compromisso.dataInicioCompromisso)} - ${dateFormat.format(endDate)}'),
                            const SizedBox(height: 12),
                            _buildLabel('Parcela'),
                            _buildValue('${(widget.compromisso.numeroParcelasPagas + 1).clamp(1, totalParcelas)} de $totalParcelas'),
                          ],
                        ),
                      ),
                      
                      // Large Graph
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Stack(
                                alignment: Alignment.center,
                                fit: StackFit.expand,
                                children: [
                                  CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 8,
                                    backgroundColor: Colors.grey[800],
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9DF425)),
                                  ),
                                  Center(
                                    child: Text(
                                      '$percentage%',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currencyFormat.format(paid),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9DF425),
                              ),
                            ),
                            Text(
                              'faltam ${currencyFormat.format(remaining)}',
                              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Actions Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Edit/Delete (Left)
                    Row(
                      children: [
                        IconButton(
                          onPressed: widget.onHistory,
                          icon: const Icon(Icons.history, color: Colors.white70),
                          tooltip: 'Histórico',
                        ),
                        IconButton(
                          onPressed: widget.onEdit,
                          icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
                          tooltip: 'Editar',
                        ),
                        IconButton(
                          onPressed: widget.onDelete,
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          tooltip: 'Excluir',
                        ),
                      ],
                    ),

                    // Deposit Button (Right) or Paid Indicator
                    _buildDepositAction(),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get _isPaidCurrentMonth {
    final closingDay = widget.diaRevisaoMensal;
    final firstBilling = DateTime(
      widget.compromisso.dataInicioCompromisso.year,
      widget.compromisso.dataInicioCompromisso.month + 1,
      closingDay,
    );
    
    final referenceTarget = DateTime(widget.referenceDate.year, widget.referenceDate.month, closingDay);
    
    int billedMonths = 0;
    
    if (referenceTarget.isAfter(firstBilling) || referenceTarget.isAtSameMomentAs(firstBilling)) {
       int monthsDiff = (referenceTarget.year - firstBilling.year) * 12 + referenceTarget.month - firstBilling.month;
       billedMonths = monthsDiff + 1;
    }

    return widget.compromisso.numeroParcelasPagas >= billedMonths;
  }

  Widget _buildDepositAction() {
    // 1. Calculate Expected Paid Installments based on Closing Day
    // Use referenceDate (Selected Month) instead of now to determine the target for this view.
    final closingDay = widget.diaRevisaoMensal;
    final firstBilling = DateTime(
      widget.compromisso.dataInicioCompromisso.year,
      widget.compromisso.dataInicioCompromisso.month + 1, // Start billing next month
      closingDay,
    );
    
    // We use the reference date (e.g. Month 1st) but we want to know if the bill FOR THAT MONTH is due/paid.
    // If we are viewing Jan 2026, and bill is Jan 20.
    // If we just use Jan 1, it might look like "Before Bill".
    // But for the purpose of "Is this month paid?", we should probably consider the bill required.
    // Let's coerce the calculation to consider the reference month's bill as the target.
    
    // Calculate months from first billing to reference date billing
    // Target Billing Date for the Reference Month:
    // If Reference Month < First Billing Month/Year -> 0.
    // Else -> (RefYear - FirstYear)*12 + (RefMonth - FirstMonth) + 1.
    
    // Let's stick to the previous robust diff logic but using a constructed date for the reference month
    // that ensures we count the bill of that month.
    // Let's assume effectively "End of Reference Month" to ensure we capture the bill requirement?
    // Or just "Same day as closing day".
    
    final referenceTarget = DateTime(widget.referenceDate.year, widget.referenceDate.month, closingDay);
    
    int billedMonths = 0;
    
    if (referenceTarget.isAfter(firstBilling) || referenceTarget.isAtSameMomentAs(firstBilling)) {
       // Calculation:
       // If Ref = First. Diff = 0. +1 (inclusive) = 1.
       // If Ref = First + 1 month. Diff = 1. +1 = 2.
       int monthsDiff = (referenceTarget.year - firstBilling.year) * 12 + referenceTarget.month - firstBilling.month;
       billedMonths = monthsDiff + 1; // +1 because we include the first billing itself?
       // Let's check logic:
       // Start Nov. First Bill Dec 20.
       // logic: 
       // Ref = Dec 20. First = Dec 20.
       // Diff = 0.
       // billedMonths = 1. (Dec is due).
       // Ref = Jan 20. First = Dec 20.
       // Diff = 1.
       // billedMonths = 2. (Dec, Jan are due).
       // This seems correct.
    }

    // Check if Paid
    // If we have paid at least what was billed until the reference month
    bool isUpToDate = widget.compromisso.numeroParcelasPagas >= billedMonths;

    if (isUpToDate) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF9DF425).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF9DF425).withOpacity(0.5)),
        ),
        child: Row(
          children: const [
            Icon(Icons.check_circle, color: Color(0xFF9DF425), size: 20),
            SizedBox(width: 8),
            Text(
              'PAGO',
              style: TextStyle(
                color: Color(0xFF9DF425),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return OutlinedButton(
      onPressed: widget.onDeposit,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF9DF425)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        foregroundColor: const Color(0xFF9DF425),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text('DEPOSITAR', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
    );
  }

  Widget _buildValue(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
