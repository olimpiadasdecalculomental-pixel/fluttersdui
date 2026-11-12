import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/escudo_aislamiento.dart';

class Ms07KahootLumosityIot {
  static Widget construirMotorJuegoCognitivo({
    required Map b,
    required double anchoPantalla,
    required Set celdasLumosity,
    required bool arduinoLed1,
    required bool arduinoRele2,
    required Function(String) onFeedback,
    required Function(int) onToggleLumosity,
    required Function(bool) onToggleArduinoLed,
    required Function(bool) onToggleArduinoRele,
    required Function(Map, Map) onDispararBoton,
  }) {
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFF00FF66));
    final List opcionesKahoot = (b['opciones_kahoot'] as List?) ?? [];
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
          Text(
            b['pregunta']?.toString() ?? 'Pregunta Interactiva Kahoot:',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: opcionesKahoot.map((op) {
              final m = Map.from(op as Map);
              final col = hexAColor(m['color']?.toString());
              return SizedBox(
                width: (anchoPantalla - 76) / 2,
                height: 75,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: col,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final ok = m['correcta'] == true;
                    HapticFeedback.heavyImpact();
                    onFeedback(ok ? '🏆 ¡KAHOOT CORRECTO! (+10 Ptos MTO)' : '⚠️ Respuesta incorrecta');
                  },
                  child: Text(
                    m['texto']?.toString() ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          const Text(
            '🧠 ENTRENAMIENTO CEREBRAL LUMOSITY (MEMORIA ESPACIAL 3x3):',
            style: TextStyle(color: Color(0xFF00F3FF), fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.9,
            ),
            itemCount: 9,
            itemBuilder: (ctx, cellIdx) {
              final activa = celdasLumosity.contains(cellIdx);
              return InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onToggleLumosity(cellIdx);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: activa ? const Color(0xFF00FF66) : const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: activa ? Colors.white : const Color(0xFF00F3FF)),
                  ),
                  child: Center(
                    child: Text(
                      activa ? '⚡ ACTIVO' : 'NODO ${cellIdx + 1}',
                      style: TextStyle(
                        color: activa ? Colors.black : Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF041322),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF00F3FF)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  dense: true,
                  title: const Text(
                    '🤖 Arduino / ESP32 LED Pin 13 (Bluetooth/Wi-Fi)',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  value: arduinoLed1,
                  activeColor: const Color(0xFF00FF66),
                  onChanged: (v) => onToggleArduinoLed(v),
                ),
                SwitchListTile(
                  dense: true,
                  title: const Text(
                    '⚡ Relé IoT MQTT Bomba / Motor SmartHome',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  value: arduinoRele2,
                  activeColor: const Color(0xFFFF00FC),
                  onChanged: (v) => onToggleArduinoRele(v),
                ),
              ],
            ),
          ),
          if (botones.isNotEmpty) ...[
            const SizedBox(height: 10),
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
                    child: Text(
                      m['texto']?.toString() ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colTxt, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}