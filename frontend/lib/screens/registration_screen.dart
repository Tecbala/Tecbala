import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meu_app/api/api_config.dart';

class RegistrationScreen extends StatefulWidget {
  final String esporteSelecionado;

  const RegistrationScreen({super.key, required this.esporteSelecionado});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  final _equipeController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _sexoController = TextEditingController();

  DateTime? _dataNascimento;
  String? _categoriaSelecionada;

  final categorias = [
    'Iniciante',
    'Amador',
    'Semi-profissional',
    'Profissional',
  ];

  final String baseUrl = ApiConfig.auth;

  Future<void> _salvarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    await http.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'esportePrincipal': widget.esporteSelecionado,
        'peso': double.tryParse(_pesoController.text),
        'altura': double.tryParse(_alturaController.text),
        'sexo': _sexoController.text,
        'dataNascimento': _dataNascimento?.toIso8601String(),
        'categoria': _categoriaSelecionada,
      }),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil salvo com sucesso')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFBDE0FE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Complete seu perfil',
                style: GoogleFonts.righteous(fontSize: 26),
              ),
              const SizedBox(height: 30),

              _input('Peso (kg)', _pesoController, TextInputType.number),
              _input('Altura (cm)', _alturaController, TextInputType.number),
              _input('Sexo', _sexoController, TextInputType.text),

              _datePicker(),

              const SizedBox(height: 20),
              _categoriaScroll(),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _salvarPerfil,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2948FF),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Salvar',
                  style: GoogleFonts.righteous(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String hint, TextEditingController controller, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: GoogleFonts.righteous(),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _datePicker() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime(2005),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (date != null) setState(() => _dataNascimento = date);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          _dataNascimento == null
              ? 'Data de nascimento'
              : '${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}',
          style: GoogleFonts.righteous(),
        ),
      ),
    );
  }

  Widget _categoriaScroll() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = categorias[index];
          final selected = cat == _categoriaSelecionada;

          return ChoiceChip(
            label: Text(cat, style: GoogleFonts.righteous()),
            selected: selected,
            selectedColor: const Color(0xFF2948FF),
            onSelected: (_) => setState(() => _categoriaSelecionada = cat),
          );
        },
      ),
    );
  }
}
