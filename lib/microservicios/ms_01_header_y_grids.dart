import 'package:flutter/material.dart';
import '../nucleo/escudo_aislamiento.dart';

class Ms01HeaderYGrids {
  static Widget construirHeaderImperio(Map b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Color(0xFF05050C),
        border: Border(bottom: BorderSide(color: Color(0xFF1A1A2E), width: 1.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    'ORBE',
                    style: TextStyle(
                      color: Color(0xFF00F3FF),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      shadows: [Shadow(color: Color(0xFF00F3FF), blurRadius: 12)],
                    ),
                  ),
                  Text(' 🌍', style: TextStyle(fontSize: 20)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red, width: 1.5),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.power_settings_new, color: Colors.red, size: 15),
                    SizedBox(width: 4),
                    Text('SALIR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Socio: ${b['socio_nombre'] ?? 'JORGE REX'}', style: const TextStyle(color: Color(0xFF00FFFF), fontSize: 11)),
                  Text('${b['socio_rango'] ?? 'SUPERADMIN'}', style: const TextStyle(color: Color(0xFF00FFFF), fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text('${b['online_txt'] ?? '5420 On line'} | ', style: const TextStyle(color: Color(0xFF00FF00), fontSize: 10, fontWeight: FontWeight.bold)),
                      Text('${b['recompensas_txt'] ?? '315 Recompensas'}', style: const TextStyle(color: Color(0xFFFFFF00), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('INVENTARIO:', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text('${b['puntos_mto'] ?? '9999999.00'} MTO', style: const TextStyle(color: Color(0xFF00FFFF), fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('1 USD = ${b['tasa_bs'] ?? '6.86'} Bs | 1 USD = ${b['tasa_mto'] ?? '100'} MTO', style: const TextStyle(color: Color(0xFF00FFFF), fontSize: 9)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget construirGridIconos4Col({
    required Map b,
    required double anchoPantalla,
    required Function(Map, Map) onDispararBoton,
    required Function(String) onFeedback,
  }) {
    final bool esTablet = anchoPantalla >= 650;
    final List items = (b['items_iconos'] as List?) ?? [];
    final List inmersivos = (b['botones_inmersivos'] as List?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: esTablet ? 6 : 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: items.length,
          itemBuilder: (ctx, idx) {
            final item = Map.from(items[idx] as Map);
            final col = hexAColor(item['color']?.toString());
            final esVip = item['vip'] == true;
            return InkWell(
              onTap: () => onDispararBoton({
                'accion': 'EJECUTAR_RPC',
                'parametros_fijos': {'p_id_accion': item['label']}
              }, b),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A1C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: col, width: 1.5),
                      boxShadow: [BoxShadow(color: col.withAlpha(70), blurRadius: 8)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(resolverIconoOrbe(item['icono']?.toString() ?? ''), color: col, size: 26),
                        const SizedBox(height: 6),
                        Text(
                          item['label']?.toString() ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: col, fontSize: 8.5, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (esVip)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(4)),
                        child: const Text('VIP', style: TextStyle(color: Colors.black, fontSize: 7, fontWeight: FontWeight.w900)),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        if (inmersivos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: inmersivos.map((btn) {
                final m = Map.from(btn as Map);
                final c = hexAColor(m['color']?.toString());
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: c),
                    backgroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => onFeedback('🥽 Modo Inmersivo Activado: ${m['texto']}'),
                  child: Text(m['texto']?.toString() ?? '', style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold)),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}