import 'package:flutter/material.dart';
import '../nucleo/escudo_aislamiento.dart';

class Ms10MotoresStacYJdw {
  // ===========================================================================
  // MOTOR #15: STAC (ANTES MIRAI) - RENDERIZADOR DIRECTO DE JSON ESTILO STITCH
  // Convierte arboles JSON {"type": "container|column|row|card|text|button..."}
  // ===========================================================================
  static Widget construirMotorStacStitch({
    required Map b,
    required double anchoPantalla,
    required Function(Map, Map) onDispararBoton,
  }) {
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFFFBB400));
    final Map nodoRaiz = Map.from((b['stac_json'] as Map?) ?? {
      'type': 'column',
      'children': [
        {
          'type': 'text',
          'data': b['titulo']?.toString() ?? '🎨 MOTOR #15 STAC (STITCH JSON NATIVO)',
          'style': {'color': '#FBB400', 'fontSize': 15, 'fontWeight': 'bold'}
        },
        {
          'type': 'text',
          'data': b['subtitulo']?.toString() ?? 'Renderizado directo desde estructura JSON de Stitch sin recompilar.',
          'style': {'color': '#D7E3FD', 'fontSize': 12}
        }
      ]
    });

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101C2F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorBorde, width: 1.5),
        boxShadow: [BoxShadow(color: colorBorde.withAlpha(50), blurRadius: 10)],
      ),
      child: _interpretarNodoStac(nodoRaiz, b, onDispararBoton),
    );
  }

  static Widget _interpretarNodoStac(Map nodo, Map bloquePadre, Function(Map, Map) onDispararBoton) {
    final String type = (nodo['type']?.toString() ?? 'container').toLowerCase();
    final Map style = Map.from((nodo['style'] as Map?) ?? {});
    final List childrenRaw = (nodo['children'] as List?) ?? [];

    if (type == 'text') {
      final Color col = hexAColor(style['color']?.toString(), const Color(0xFFD7E3FD));
      final double sz = double.tryParse(style['fontSize']?.toString() ?? '13') ?? 13.0;
      final bool bold = style['fontWeight']?.toString() == 'bold' || style['fontWeight']?.toString() == '700';
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Text(
          nodo['data']?.toString() ?? nodo['text']?.toString() ?? '',
          style: TextStyle(color: col, fontSize: sz, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        ),
      );
    }

    if (type == 'button' || type == 'elevatedbutton') {
      final Color bg = hexAColor(style['backgroundColor']?.toString(), const Color(0xFFFBB400));
      final Color fg = hexAColor(style['color']?.toString(), const Color(0xFF071326));
      final Map accionMap = Map.from((nodo['onPressed'] as Map?) ?? {
        'accion': 'EJECUTAR_RPC',
        'parametros_fijos': {'p_id_accion': 'SIM_INTERACCION_DISEÑO', 'p_valor': '⚡ Botón Stac/Stitch ejecutado en vivo.'}
      });
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => onDispararBoton(accionMap, bloquePadre),
            child: Text(
              nodo['label']?.toString() ?? nodo['child_text']?.toString() ?? 'Acción Stitch',
              style: TextStyle(color: fg, fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ),
        ),
      );
    }

    if (type == 'row') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: childrenRaw.map((c) => Expanded(child: _interpretarNodoStac(Map.from(c as Map), bloquePadre, onDispararBoton))).toList(),
      );
    }

    if (type == 'card' || type == 'container') {
      final Color bg = hexAColor(style['backgroundColor']?.toString(), const Color(0xFF142033));
      final Color brd = hexAColor(style['borderColor']?.toString(), const Color(0xFF2A3549));
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: brd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: childrenRaw.map((c) => _interpretarNodoStac(Map.from(c as Map), bloquePadre, onDispararBoton)).toList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: childrenRaw.map((c) => _interpretarNodoStac(Map.from(c as Map), bloquePadre, onDispararBoton)).toList(),
    );
  }

  // ===========================================================================
  // MOTOR #16: JSON_DYNAMIC_WIDGET (EL ENSAMBLADOR HÍBRIDO)
  // Permite mezclar JSON libre e invocar cualquiera de los 14 Motores Nativos
  // por su nombre dentro del diccionario registrado ("MOTOR_NATIVO:CARNET_QR_ACTIVO").
  // ===========================================================================
  static Widget construirMotorJsonDynamicHibrido({
    required Map b,
    required Widget Function(Map) constructorMotorNativoPorNombre,
    required Function(Map, Map) onDispararBoton,
  }) {
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFF00C853));
    final List nodosHibridos = (b['jdw_nodos'] as List?) ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorBorde, width: 1.5),
        boxShadow: [BoxShadow(color: colorBorde.withAlpha(50), blurRadius: 10)],
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
          ...nodosHibridos.map((item) {
            final Map nodo = Map.from(item as Map);
            final String tipoNodo = nodo['type']?.toString() ?? 'text';
            if (tipoNodo.startsWith('MOTOR_NATIVO:') || nodo['es_motor_nativo'] == true) {
              final String nombreMotor = tipoNodo.replaceAll('MOTOR_NATIVO:', '').trim();
              final Map configMotor = Map.from((nodo['args'] as Map?) ?? nodo);
              configMotor['tipo'] = nombreMotor;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: constructorMotorNativoPorNombre(configMotor),
              );
            }
            return _interpretarNodoStac(nodo, b, onDispararBoton);
          }),
        ],
      ),
    );
  }
}