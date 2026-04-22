import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';

class ExpenseMediaService {
  /// 📂 Buscar mídias de uma despesa (Premium)
  Future<List<Map<String, dynamic>>> getMedia({
    required String token,
    required String expenseId,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/expenses/media/$expenseId'),
      headers: ApiClient.headers(token: token),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar mídias');
    }

    return List<Map<String, dynamic>>.from(
      jsonDecode(response.body),
    );
  }

  /// 🖼️ Upload de múltiplas imagens (galeria – Web + Mobile)
  Future<void> uploadImages({
    required String token,
    required String expenseId,
    required List<Uint8List> images,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiClient.baseUrl}/expenses/media/$expenseId'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    for (final image in images) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'media',         // ✅ deve bater com upload.array("media")
          image,
          filename: 'image.jpg',
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Erro ao fazer upload das imagens');
    }
  }

  /// 📷 Upload de uma única imagem (câmera – Mobile)
  ///
  /// Reutiliza internamente o upload múltiplo
  Future<void> uploadSingleImage({
    required String token,
    required String expenseId,
    required Uint8List image,
  }) async {
    await uploadImages(
      token: token,
      expenseId: expenseId,
      images: [image],
    );
  }

  /// 🗑️ Excluir mídia individual (Premium)
  Future<void> deleteMedia({
    required String token,
    required String mediaId,
  }) async {
    final response = await http.delete(
      Uri.parse('${ApiClient.baseUrl}/expenses/media/$mediaId'),
      headers: ApiClient.headers(token: token),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir mídia');
    }
  }
}