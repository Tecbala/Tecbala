import 'package:flutter/material.dart';
import 'package:meu_app/screens/registration_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// Definição das cores aproximadas da imagem
class AppColors {
  static const Color background = Color(0xFFE0F7FA); // Azul claro
  static const Color primaryBlue = Color(0xFF42A5F5); // Azul para Natação e Avançar
  static const Color yellow = Color(0xFFFFCA28); // Amarelo para Vôlei
  static const Color orange = Color(0xFFFF7043); // Laranja para Basquete
  static const Color red = Color(0xFFEF5350); // Vermelho para MMA
  static const Color iconBackground = Colors.white;
}

// Modelo de dados para os botões de esporte
class SportItem {
  final String name;
  final IconData icon;
  final Color color;

  SportItem({required this.name, required this.icon, required this.color});
}

// Lista de esportes a serem exibidos
final List<SportItem> sports = [
  SportItem(name: 'Natação', icon: Icons.pool, color: AppColors.primaryBlue),
  SportItem(name: 'Vôlei', icon: Icons.sports_volleyball, color: AppColors.yellow),
  SportItem(name: 'Basquete', icon: Icons.sports_basketball, color: AppColors.orange),
  SportItem(name: 'MMA', icon: Icons.sports_mma, color: AppColors.red),
];

class SportSelectionScreen extends StatefulWidget {
  const SportSelectionScreen({super.key});

  @override
  State<SportSelectionScreen> createState() => _SportSelectionScreenState();
}

class _SportSelectionScreenState extends State<SportSelectionScreen> {
  String? _selectedSport;

  void _selectSport(String sportName) {
    setState(() {
      _selectedSport = sportName;
    });
    // Lógica de seleção (pode ser expandida no futuro)
    print('Esporte selecionado: $_selectedSport');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. Logo/Header "TechBala"
              const TechBalaLogo(),
              const SizedBox(height: 40),

              // 2. Título "Escolha seu esporte"
              Text(
                'Escolha seu\nesporte',
                textAlign: TextAlign.center,
                style: GoogleFonts.righteous(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),

              // 3. Lista de Botões de Esporte
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: sports.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final sport = sports[index];
                    final isSelected = _selectedSport == sport.name;
                    return SportSelectionButton(
                      sport: sport,
                      isSelected: isSelected,
                      onPressed: () => _selectSport(sport.name),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // 4. Botão "Avançar"
              ElevatedButton(
  onPressed: _selectedSport != null
      ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationScreen(
                esporteSelecionado: _selectedSport!,
              ),
            ),
          );
        }
      : null,
 // Desabilita se nenhum esporte for selecionado
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Avançar',
                  style: GoogleFonts.righteous(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para o Logo "TechBala"
class TechBalaLogo extends StatelessWidget {
  const TechBalaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Ícone de corredor (aproximação)
        const Icon(
          Icons.directions_run,
          size: 30,
          color: Colors.black,
        ),
        const SizedBox(width: 8),
        // Texto "TechBala"
        const Text(
          'TechBala',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// Widget para os Botões de Seleção de Esporte
class SportSelectionButton extends StatelessWidget {
  final SportItem sport;
  final bool isSelected;
  final VoidCallback onPressed;

  const SportSelectionButton({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: sport.color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.black, width: 3) // Borda para indicar seleção
              : null,
        ),
        child: Row(
          children: <Widget>[
            // Ícone com fundo circular
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.iconBackground,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: sport.color, width: 4),
              ),
              child: Icon(
                sport.icon,
                color: sport.color,
                size: 35,
              ),
            ),
            const SizedBox(width: 20),
            // Nome do Esporte
            Text(
              sport.name,
              style: GoogleFonts.righteous(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}