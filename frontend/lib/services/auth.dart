import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meu_app/api/api_config.dart';

class AuthService {

  Future<bool> login(String email, String senha) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.auth}/login',
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": senha,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Login bem-sucedido");
        print("Token: ${data['token']}");
        return true;
      } else {
        print("❌ Erro no login: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Erro de conexão: $e");
      return false;
    }
  }
}
