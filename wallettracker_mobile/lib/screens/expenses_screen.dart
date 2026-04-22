import 'package:flutter/material.dart';
import '../services/expense_service.dart';
import '../models/expense_model.dart';
import 'create_expense_screen.dart';
import 'expense_detail_screen.dart';

class ExpensesScreen extends StatefulWidget {
  final String token;
  final bool isPremium;

  const ExpensesScreen({
    super.key,
    required this.token,
    required this.isPremium,
  });

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpenseService _service = ExpenseService();

  List<ExpenseModel> _expenses = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      final data = await _service.getExpenses(widget.token);

      if (!mounted) return;

      setState(() {
        _expenses = data;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Erro ao carregar despesas';
        _loading = false;
      });
    }
  }

  Future<void> _openCreateExpense() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateExpenseScreen(token: widget.token),
      ),
    );

    if (created == true) {
      setState(() => _loading = true);
      _loadExpenses();
    }
  }

  Future<void> _openExpenseDetail(ExpenseModel expense) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ExpenseDetailScreen(
          token: widget.token,
          expense: expense,
          isPremium: widget.isPremium, // ✅ AQUI
        ),
      ),
    );

    if (updated == true) {
      setState(() => _loading = true);
      _loadExpenses();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateExpense,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _expenses.isEmpty
                  ? const Center(child: Text('Nenhuma despesa cadastrada'))
                  : ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (_, index) {
                        final e = _expenses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text(e.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Categoria: ${e.category}'),
                                Text('Data: ${_formatDate(e.date)}'),
                              ],
                            ),
                            trailing: Text('R\$ ${e.amount.toStringAsFixed(2)}'),
                            onTap: () => _openExpenseDetail(e),
                          ),
                        );
                      },
                    ),
    );
  }
}
