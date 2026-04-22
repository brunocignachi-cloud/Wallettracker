import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';
import '../models/expense_model.dart';

class ExpenseService {
  Future<List<ExpenseModel>> getExpenses(String token) async {
    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/expenses'),
      headers: ApiClient.headers(token: token),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar despesas');
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => ExpenseModel.fromJson(e)).toList();
  }

  Future<void> createExpense(
    String token,
    String description,
    double amount,
    String category,
    DateTime date,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/expenses'),
      headers: ApiClient.headers(token: token),
      body: jsonEncode({
        'description': description,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar despesa');
    }
  }

  Future<void> updateExpense(
    String token,
    String expenseId,
    String description,
    double amount,
    String category,
    DateTime date,
  ) async {
    final response = await http.put(
      Uri.parse('${ApiClient.baseUrl}/expenses/$expenseId'),
      headers: ApiClient.headers(token: token),
      body: jsonEncode({
        'description': description,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar despesa');
    }
  }

  Future<void> deleteExpense(String token, String expenseId) async {
    final response = await http.delete(
      Uri.parse('${ApiClient.baseUrl}/expenses/$expenseId'),
      headers: ApiClient.headers(token: token),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir despesa');
    }
  }

}
