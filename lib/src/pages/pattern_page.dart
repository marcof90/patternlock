import 'package:flutter/material.dart';
import 'pattern_lock_screen.dart'; // Ajusta la ruta según la ubicación real de tu archivo
import 'package:flutter_application/src/pages/count_page.dart';

class PatternPage extends StatelessWidget {
  final void Function(dynamic pattern) onPatternEntered;

  const PatternPage({Key? key, required this.onPatternEntered}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pattern Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF241108),
              Color(0xFF391100),
              Color(0xFF86543B),
            ],
            stops: [0.4202, 0.6016, 0.9793],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: PasswordPattern(
            // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
            onFinish: (pattern) {
              // Callback para manejar el patrón en PatternPage
              _handleEnteredPattern(context, pattern);
            },
            // Puedes proporcionar cualquier lógica adicional aquí si es necesario
          ),
        ),
      ),
    );
  }

  // Función para manejar el patrón ingresado
  void _handleEnteredPattern(BuildContext context, String pattern) {
    // Puedes realizar cualquier otra acción necesaria aquí
    print('Entered Pattern: $pattern');
    if(pattern == "014367"){      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CountPage(),
        ),
      );
    }

    // Puedes navegar a otra página, mostrar un diálogo, etc.
    // Navigator.push(context, MaterialPageRoute(builder: (context) => OtraPagina()));
  }
}
