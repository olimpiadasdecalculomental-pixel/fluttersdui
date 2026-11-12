import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nucleo/orquestador_sdui.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    // Escudo Global Visual: Evita pantallas rojas si un widget falla con millones de usuarios
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0505),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orangeAccent),
        ),
        child: const Row(
          children: [
            Icon(Icons.shield_outlined, color: Colors.orangeAccent, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Escudo Activo: Micro-componente aislado de forma segura.',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ],
        ),
      );
    };

    runApp(const OrbeSuperAppSdui());
  }, (Object error, StackTrace stack) {
    debugPrint('Escudo Global Asincrono intercepto un error: $error');
  });
}

class OrbeSuperAppSdui extends StatelessWidget {
  const OrbeSuperAppSdui({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF05050F),
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: 'SuperApp Orbe SDUI - Microservicios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF05050F),
      ),
      home: const LienzoMaestroSdui(),
    );
  }
}