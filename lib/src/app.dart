import 'package:flutter/material.dart';

// Importa la página 'pattern_page.dart', que contiene el widget de la pantalla del patrón
import 'package:flutter_application/src/pages/pattern_page.dart';

// Clase principal que representa la aplicación Flutter
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Método build que construye y devuelve la interfaz de usuario de la aplicación
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuración para ocultar el banner de depuración en la esquina superior derecha
      debugShowCheckedModeBanner: false,
      
      // Definición de la pantalla principal de la aplicación
      home: Center(
        // Creación de una instancia del widget PatternPage, que contiene la pantalla del patrón
        child: PatternPage(
          // Proporciona una función de devolución de llamada que manejará el patrón ingresado
          onPatternEntered: (pattern) {
            // Esta función de devolución de llamada está vacía en este ejemplo
            // Puedes realizar acciones adicionales según el patrón ingresado aquí
          },
        ),
      ),
    );
  }
}
