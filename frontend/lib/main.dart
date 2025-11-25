import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Função que testa a conexão com o backend
  Future<void> testarConexao() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.11:3000/user'));

      if (response.statusCode == 200) {
        print('✅ Conectado ao backend: ${response.body}');
      } else {
        print('❌ Erro do servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('🚫 Erro ao conectar: $e');
    }
  }

 

void main() {
  runApp(const MyApp());
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TecBala',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(), // ✅ Tela de boas-vindas como inicial
      debugShowCheckedModeBanner: false,
    );
  }

}


