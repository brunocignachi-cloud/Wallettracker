class ApiClient {
  static const String baseUrl = 'https://wallettracker-v12.onrender.com';

  static Map<String, String> headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
