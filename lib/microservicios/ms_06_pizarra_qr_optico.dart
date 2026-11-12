import 'package:flutter/material.dart';
import '../nucleo/escudo_aislamiento.dart';

class Ms06PizarraQrOptico {
  static Widget construirPizarraTactil({
    required Map b,
    required List trazosPizarra,
    required Color colorLapizActual,
    required Function(Color) onCambiarColor,
    required Function onLimpiar,
    required Function(Offset) onIniciarTrazo,
    required Function(Offset) onActualizarTrazo,
  }) {
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFF00FF66));
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
          Text(
            b['titulo']?.toString() ?? '✍️ PIZARRA TÁCTIL NEÓN (DIBUJA CON EL DEDO)',
            style: TextStyle(color: colorBorde, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Color(0xFF00FF66),
                  const Color(0xFF00F3FF),
                  const Color(0xFFFF00FC),
                  const Color(0xFFFFD700),
                ].map((col) => GestureDetector(
                      onTap: () => onCambiarColor(col),
                      child: Container(
                        width: 26,
                        height: 26,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: col,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorLapizActual == col ? Colors.white : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                    )).toList(),
              ),
              TextButton.icon(
                onPressed: () => onLimpiar(),
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                label: const Text(
                  'LIMPIAR',
                  style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onPanStart: (d) => onIniciarTrazo(d.localPosition),
            onPanUpdate: (d) => onActualizarTrazo(d.localPosition),
            child: Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: CustomPaint(
                painter: PintorPizarraNeon(trazosPizarra, colorLapizActual),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PintorPizarraNeon extends CustomPainter {
  final List trazos;
  final Color colorLapiz;
  PintorPizarraNeon(this.trazos, this.colorLapiz);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorLapiz
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final trazo in trazos) {
      final List pts = trazo as List;
      for (int i = 0; i < pts.length - 1; i++) {
        canvas.drawLine(pts[i] as Offset, pts[i + 1] as Offset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PintorMatrizQrOptico extends CustomPainter {
  final String semilla;
  PintorMatrizQrOptico(this.semilla);

  @override
  void paint(Canvas canvas, Size size) {
    const int n = 21;
    final double celda = size.width / n;
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final int hashBase = semilla.codeUnits.fold(0, (a, b) => (a as int) * 31 + (b as int));

    void dibujarEsquina(int fila0, int col0) {
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 7; c++) {
          final borde = r == 0 || r == 6 || c == 0 || c == 6 || (r >= 2 && r <= 4 && c >= 2 && c <= 4);
          if (borde) {
            canvas.drawRect(Rect.fromLTWH((col0 + c) * celda, (fila0 + r) * celda, celda, celda), paint);
          }
        }
      }
    }

    dibujarEsquina(0, 0);
    dibujarEsquina(0, n - 7);
    dibujarEsquina(n - 7, 0);

    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        if ((r < 8 && c < 8) || (r < 8 && c >= n - 8) || (r >= n - 8 && c < 8)) continue;
        final v = ((r * 37 + c * 17 + hashBase) & 3) == 0;
        if (v) {
          canvas.drawRect(Rect.fromLTWH(c * celda, r * celda, celda, celda), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}