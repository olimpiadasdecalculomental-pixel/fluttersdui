import 'package:flutter/material.dart';

Color hexAColor(String? hex, [Color defecto = const Color(0xFF00F3FF)]) {
  if (hex == null || hex.isEmpty) return defecto;
  String limpio = hex.replaceAll('#', '').trim();
  if (limpio.length == 6) limpio = 'FF$limpio';
  final val = int.tryParse(limpio, radix: 16);
  return val != null ? Color(val) : defecto;
}

// Circuit Breaker: Si un microservicio falla, los otros 14 siguen funcionando al 100%
Widget ejecutarConEscudoMicroservicio(String nombreModulo, Widget Function() constructorWidget) {
  try {
    return constructorWidget();
  } catch (e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A0A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Text(
        '🛡️ Microservicio [$nombreModulo] aislado por seguridad: $e',
        style: const TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

IconData resolverIconoOrbe(String nombre) {
  switch (nombre.toLowerCase()) {
    case 'gift': return Icons.card_giftcard;
    case 'favorite': return Icons.favorite;
    case 'refresh': return Icons.refresh;
    case 'gamepad': return Icons.sports_esports;
    case 'school': return Icons.school;
    case 'wallet': return Icons.account_balance_wallet;
    case 'store': return Icons.storefront;
    case 'book': return Icons.menu_book;
    case 'music': return Icons.music_note;
    case 'videocam': return Icons.videocam;
    case 'rocket': return Icons.rocket_launch;
    case 'movie': return Icons.movie_filter;
    case 'library': return Icons.local_library;
    case 'bulb': return Icons.lightbulb;
    case 'shield': return Icons.verified_user;
    case 'iot': return Icons.bluetooth_connected;
    case 'crypto': return Icons.currency_bitcoin;
    case 'map': return Icons.map;
    case 'translate': return Icons.record_voice_over;
    default: return Icons.auto_awesome;
  }
}