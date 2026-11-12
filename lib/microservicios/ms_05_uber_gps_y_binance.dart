import 'package:flutter/material.dart';
import '../nucleo/escudo_aislamiento.dart';

class Ms05UberGpsYBinance {
  static Widget construirUberMapaRadarGps(Map b) {
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFF00F3FF));
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorBorde, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(b['titulo']?.toString() ?? '🗺️ RADAR GPS EN VIVO (ESTILO UBER / PARENTAL)', style: TextStyle(color: colorBorde, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(b['subtitulo']?.toString() ?? 'Ubicación satelital en tiempo real (Oruro, Bolivia - Pellizca para Zoom):', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 10),
          Container(
            height: 210,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF030B17),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colorBorde),
            ),
            clipBehavior: Clip.antiAlias,
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4.0,
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: PintorRadarSatelitalOruro())),
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, color: Color(0xFFFF0055), size: 38),
                        Text('📍 PARQUE DE LA UNIÓN (ORURO)', style: TextStyle(color: Color(0xFF00FF66), fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.black87)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget construirBinanceCriptoTrading(Map b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(b['titulo']?.toString() ?? '📈 MERCADO MTO / BITCOIN / USDT (ESTILO BINANCE)', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(b['subtitulo']?.toString() ?? '1 USD = 100 MTO | 1 USD = 6.86 Bs | Variación 24h: +14.8%', style: const TextStyle(color: Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            height: 170,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
            child: CustomPaint(painter: PintorGraficoBinance()),
          ),
        ],
      ),
    );
  }
}

class PintorRadarSatelitalOruro extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = const Color(0xFF00F3FF).withAlpha(35)..strokeWidth = 1;
    for (int i = 1; i < 8; i++) {
      canvas.drawLine(Offset(size.width * (i / 8), 0), Offset(size.width * (i / 8), size.height), gridPaint);
      canvas.drawLine(Offset(0, size.height * (i / 8)), Offset(size.width, size.height * (i / 8)), gridPaint);
    }
    final circlePaint = Paint()
      ..color = const Color(0xFF00FF66).withAlpha(65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 32, circlePaint);
    canvas.drawCircle(center, 68, circlePaint);
    canvas.drawCircle(center, 105, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PintorGraficoBinance extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = Colors.white12..strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final pts = [
      Offset(0, size.height * 0.80),
      Offset(size.width * 0.16, size.height * 0.65),
      Offset(size.width * 0.32, size.height * 0.72),
      Offset(size.width * 0.48, size.height * 0.45),
      Offset(size.width * 0.64, size.height * 0.52),
      Offset(size.width * 0.80, size.height * 0.25),
      Offset(size.width, size.height * 0.12),
    ];

    final linePaint = Paint()
      ..color = const Color(0xFF00FF66)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(path, linePaint);

    for (int i = 0; i < pts.length; i++) {
      final alcista = i % 2 == 0;
      final x = pts[i].dx;
      final y = pts[i].dy;
      final wickPaint = Paint()
        ..color = alcista ? const Color(0xFF00FF66) : const Color(0xFFFF0055)
        ..strokeWidth = 1.5;
      final bodyPaint = Paint()
        ..color = alcista ? const Color(0xFF00FF66) : const Color(0xFFFF0055)
        ..style = PaintingStyle.fill;
      canvas.drawLine(Offset(x, y - 14), Offset(x, y + 14), wickPaint);
      canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: 8, height: 14), bodyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}