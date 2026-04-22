import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';
import '../models/user_model.dart';
import '../models/auth_response.dart';

class AuthService {
  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/auth/login'),
      headers: ApiClient.headers(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Credenciais inválidas');
    }

    final data = jsonDecode(response.body);

    return AuthResponse(
      token: data['token'],
      user: UserModel.fromJson(data['user']),
    );
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/auth/register'),
      headers: ApiClient.headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao cadastrar usuário');
    }
  }
}