import 'package:flutter/material.dart';
import 'package:meu_app/screens/apresMMA.dart';
import 'package:google_fonts/google_fonts.dart';

class Apresbasquete extends StatelessWidget {
  const Apresbasquete({super.key});

  void _goToApresentacao(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ApresMMA()), // Nome correto da classe
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF994F),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),

            // Ícone dentro do círculo com gradiente
            Column(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // gradient: LinearGradient(
                    //   colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'lib/assets/basquete.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Título
                Text(
                  'Basquete',
                  style: GoogleFonts.righteous(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Texto descritivo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Velocidade, explosão e controle. Um jogo\n de intensidade e inteligência em cada\n lance.',
                    style: GoogleFonts.righteous(
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
              const SizedBox(height: 40),
           // Botões (Modificado conforme a imagem)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Para o botão Avançar ocupar a largura total
                children: [
                  // Botão Avançar (estilo da imagem)
                  ElevatedButton(
                    onPressed: () => _goToApresentacao(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F51B5), // Azul escuro
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Cantos arredondados
                      ),
                      elevation: 8, // Sombra
                    ),
                    child: Text(
                      'Avançar',
                      style: GoogleFonts.righteous(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20), // Espaço entre os botões

                  // Botão Voltar (estilo da imagem: texto simples com sombra)
                  Align(
                    alignment: Alignment.centerLeft, // Alinhado à esquerda dentro do Padding
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Volta para a tela anterior
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF3F51B5), // Cor do texto Voltar
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black26,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
