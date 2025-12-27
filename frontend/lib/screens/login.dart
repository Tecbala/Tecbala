import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meu_app/api/api_config.dart';
import 'package:meu_app/screens/dashbord.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;

  final String baseUrl = '${ApiConfig.baseUrl}${ApiConfig.auth}';

  Future<void> _authenticate() async {
    try {
      final route = _isLogin ? 'login' : 'register';

      final response = await http.post(
        Uri.parse('$baseUrl/$route'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          if (!_isLogin) 'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (_isLogin) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          await prefs.setString('name', data['user']['name']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Dashboard()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Conta criada com sucesso!')),
          );
          setState(() => _isLogin = true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro no servidor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro de conexão')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFB3E5FC),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Logo
              Row(
                children: [
                  Image.asset('lib/assets/tecbala_logo.png', width: 40, height: 40),
                  const SizedBox(width: 8),
                  Text(
                    'TechBala',
                    style: GoogleFonts.rubikGlitch(
                      fontSize: 24,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 130),

              /// Título
              Text(
                _isLogin ? 'Entre na sua conta' : 'Crie sua conta',
                style: GoogleFonts.righteous(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 50),

              if (!_isLogin) _inputField('Nome', _nameController, false),

              _inputField('Email', _emailController, false),
              _inputField('Senha', _passwordController, true),

              const SizedBox(height: 50),

              /// Botão Entrar / Cadastrar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _authenticate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2962FF),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _isLogin ? 'Entrar' : 'Cadastrar',
                    style: GoogleFonts.righteous(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Alternar Login / Cadastro
              TextButton(
                onPressed: () {
                  setState(() => _isLogin = !_isLogin);
                },
                child: Text(
                  _isLogin ? 'Criar nova conta' : 'Já tenho conta',
                  style: const TextStyle(
                    color: Color(0xFF2962FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Campo estilizado (igual ao design A)
  Widget _inputField(
    String hint,
    TextEditingController controller,
    bool isPassword,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          style: GoogleFonts.righteous(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.righteous(color: Colors.grey[600]),

            // 🔹 Borda normal (sem clicar)
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),

            // 🔹 Borda quando clicar (FOCUS)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xFF2962FF), // azul igual ao botão
                width: 2,
              ),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }
}
