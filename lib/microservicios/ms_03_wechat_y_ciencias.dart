import 'package:flutter/material.dart';

class Ms03WechatYCiencias {
  static Widget construirChatWechatP2P({
    required Map b,
    required Map estadoForm,
    required Function(Map, Map) onDispararBoton,
  }) {
    final List mensajes = (b['items_lista'] as List?) ?? [
      '🟢 @JORGE_REX: ¡Bienvenidos al canal oficial WeChat Orbe!',
      '🎁 [SOBRE ROJO P2P]: +50 MTO enviados al grupo',
      '🎙️ @PROFE_M3: [Nota de Voz 0:14s - Clase Robótica]'
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00FF66), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(b['titulo']?.toString() ?? '💬 WECHAT SUPERAPP: CHAT, VOZ Y PAGOS P2P', style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          ...mensajes.map((m) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF00F3FF).withAlpha(80)),
                ),
                child: Text(m.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
              )),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Escribe mensaje o monto MTO...',
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF00FF66))),
                  ),
                  onChanged: (v) => estadoForm['p_mensaje_chat'] = v,
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFF00FF66)),
                icon: const Icon(Icons.send, color: Colors.black, size: 18),
                onPressed: () => onDispararBoton({'accion': 'EJECUTAR_RPC', 'parametros_fijos': {'p_id_accion': 'CHAT_ENVIAR_MSJ'}}, b),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget construirLabCiencias({
    required Map b,
    required Function(String) onFeedback,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00F3FF), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(b['titulo']?.toString() ?? '🔬 LABORATORIO DE MATEMÁTICAS, FÍSICA Y QUÍMICA', style: const TextStyle(color: Color(0xFF00F3FF), fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          const Text('Fórmulas LaTeX: ∫ f(x)dx · F = m·a · E = m·c² · H₂SO₄ + 2NaOH ➔ Na₂SO₄ + 2H₂O', style: TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              '📐 Derivada / Integral',
              '⚡ Fuerza (Newtons)',
              '🧪 Masa Molar PubChem',
              '🌡️ Kelvin ⇄ Celsius'
            ].map((op) => OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF00F3FF))),
                  onPressed: () => onFeedback('🔬 Simulación científica activa: $op'),
                  child: Text(op, style: const TextStyle(color: Colors.white, fontSize: 11)),
                )).toList(),
          ),
        ],
      ),
    );
  }
}