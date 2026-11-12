import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/escudo_aislamiento.dart';

class Ms08CineCristalHtml5 {
  static Widget construirCineCristalHtml5({
    required Map b,
    required int episodioActual,
    required double anchoPantalla,
    required Function(int) onCambiarEpisodio,
    required Function(Map, Map) onDispararBoton,
  }) {
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFFFF00FC));
    final List botones = (b['botones'] as List?) ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorBorde, width: 1.5),
        boxShadow: [BoxShadow(color: colorBorde.withAlpha(56), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (b['titulo'] != null)
            Text(
              b['titulo'].toString(),
              style: TextStyle(color: colorBorde, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          if (b['subtitulo'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: Text(b['subtitulo'].toString(), style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
            ),
          Container(
            height: 270,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00F3FF), width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    episodioActual == 0
                        ? 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&q=80'
                        : 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF050A14)),
                  ),
                ),
                const Positioned(
                  top: 10,
                  left: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ORBE IMPERIO', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w900, fontSize: 15)),
                      Text('NETFLIX / TIKTOK / C-DRAMA 4DX', style: TextStyle(color: Colors.white70, fontSize: 8)),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () => onDispararBoton({'accion': 'DESCARGAR_VIDEO_OFFLINE'}, b),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0096FF).withAlpha(102),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF00FF66)),
                      ),
                      child: const Text('📥 OFFLINE / VR 360', style: TextStyle(color: Color(0xFF00FF66), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  width: 68,
                  child: Container(
                    padding: const EdgeInsets.only(top: 52),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0096FF).withAlpha(102),
                      border: const Border(right: BorderSide(color: Color(0xFF00F3FF))),
                    ),
                    child: Column(
                      children: [0, 1, 2].map((epIdx) {
                        final activo = episodioActual == epIdx;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              onCambiarEpisodio(epIdx);
                            },
                            child: Container(
                              width: 54,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: activo ? const Color(0xFF00F3FF).withAlpha(110) : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: activo ? const Color(0xFF00F3FF) : Colors.white24),
                              ),
                              child: Text(
                                'Ep. ${epIdx + 1}',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: activo ? const Color(0xFF00F3FF) : Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0096FF).withAlpha(110),
                      border: const Border(top: BorderSide(color: Color(0xFF00F3FF))),
                    ),
                    child: Text(
                      'Nuera del Billonario · Ep. ${episodioActual + 1} (⏳ Bóveda VIP: Quedan 7 Días)',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (botones.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: botones.map((btn) {
                final m = Map.from(btn as Map);
                final col = hexAColor(m['color']?.toString(), colorBorde);
                final colTxt = hexAColor(m['color_texto']?.toString(), Colors.black);
                final mitad = m['ancho_mitad'] == true;
                return SizedBox(
                  width: mitad ? (anchoPantalla - 72) / 2 : double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: col,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => onDispararBoton(m, b),
                    child: Text(m['texto']?.toString() ?? '', textAlign: TextAlign.center, style: TextStyle(color: colTxt, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}