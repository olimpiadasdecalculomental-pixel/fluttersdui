import 'package:flutter/material.dart';
import '../nucleo/escudo_aislamiento.dart';
import 'ms_06_pizarra_qr_optico.dart';

class Ms09TarjetaNeonBase {
  static Widget construirTarjetaNeonBase({
    required Map b,
    required double anchoPantalla,
    required Map estadoForm,
    required Function(String, String) onActualizarCampo,
    required Function(Map, Map) onDispararBoton,
  }) {
    final tipo = b['tipo']?.toString() ?? 'TARJETA_NEON';
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFF00F3FF));
    final List chips = (b['selector_chips'] as List?) ?? [];
    final List inputs = (b['campos_input'] as List?) ?? [];
    final List lista = (b['items_lista'] as List?) ?? [];
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
              style: TextStyle(
                color: colorBorde,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: colorBorde, blurRadius: 8)],
              ),
            ),
          if (b['subtitulo'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: Text(b['subtitulo'].toString(), style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
            ),

          if (tipo == 'CARNET_QR_ACTIVO')
            Center(
              child: Column(
                children: [
                  Text(
                    b['valor_qr_defecto']?.toString() ?? 'ORBE-QR',
                    style: const TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF00F3FF), width: 3),
                    ),
                    child: SizedBox(
                      width: 145,
                      height: 145,
                      child: CustomPaint(
                        painter: PintorMatrizQrOptico(b['valor_qr_defecto']?.toString() ?? 'ORBE-QR'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

          if (b['imagen_url'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InteractiveViewer(
                  child: Image.network(
                    b['imagen_url'].toString(),
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: Colors.black54,
                      child: const Center(child: Icon(Icons.image, color: Colors.white54)),
                    ),
                  ),
                ),
              ),
            ),

          if (chips.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: chips.map((c) {
                  final txt = c.toString();
                  final campo = b['campo_selector']?.toString() ?? 'p_seleccion';
                  final activo = estadoForm[campo] == txt;
                  return ChoiceChip(
                    label: Text(
                      txt,
                      style: TextStyle(
                        color: activo ? Colors.black : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: activo,
                    selectedColor: colorBorde,
                    backgroundColor: const Color(0xFF111111),
                    onSelected: (_) => onActualizarCampo(campo, txt),
                  );
                }).toList(),
              ),
            ),

          ...inputs.map((inp) {
            final m = Map.from(inp as Map);
            final campo = m['campo']?.toString() ?? 'p_input';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                obscureText: m['es_password'] == true,
                keyboardType: m['teclado'] == 'numeric' ? TextInputType.number : TextInputType.text,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: m['placeholder']?.toString() ?? '',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorBorde),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorBorde, width: 2),
                  ),
                ),
                onChanged: (v) => onActualizarCampo(campo, v),
              ),
            );
          }),

          ...lista.map((item) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF333333)),
                ),
                child: Text(
                  item.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )),

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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: m['color_borde_btn'] != null
                            ? BorderSide(color: hexAColor(m['color_borde_btn'].toString()))
                            : BorderSide.none,
                      ),
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
      ),
    );
  }
}