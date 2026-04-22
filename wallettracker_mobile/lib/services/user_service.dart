import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';

class UserService {
  /// ⭐ Tornar usuário Premium
  /// 🚨 Retorna um NOVO TOKEN com premium=true
  Future<String> upgradeToPremium(String token) async {
    final response = await http.patch(
      Uri.parse('${ApiClient.baseUrl}/user/upgrade'),
      headers: ApiClient.headers(token: token),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao tornar usuário premium');
    }

    final data = jsonDecode(response.body);

    return data['token'];
  }

  Future<String> downgradeFromPremium(String token) async {
    final response = await http.patch(
      Uri.parse('${ApiClient.baseUrl}/user/downgrade'),
      headers: ApiClient.headers(token: token),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao voltar para usuário normal');
    }

    final data = jsonDecode(response.body);

    return data['token'];
  }
}