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
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFBB400), width: 1.8),
                      boxShadow: [BoxShadow(color: const Color(0xFFFBB400).withAlpha(65), blurRadius: 8)],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Color(0xFF00F3FF), size: 22),
                      ),
                    ),
                  ),
                  const Text(
                    'SAN JOSÉ',
                    style: TextStyle(
                      color: Color(0xFFD7E3FD),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      shadows: [Shadow(color: Color(0xFF00509D), blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00509D),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('1942', style: TextStyle(color: Color(0xFFFBB400), fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2A3E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFBB400), width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Color(0xFFFBB400), size: 15),
                    const SizedBox(width: 4),
                    Text(
                      '${b['puntos_mto'] ?? '350'} pts',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${b['socio_nombre'] ?? 'SOCIO VIP · ORURO'}', style: const TextStyle(color: Color(0xFFFFD795), fontSize: 11, fontWeight: FontWeight.bold)),
                    Text('${b['socio_rango'] ?? 'Lanzamiento Activo'}', style: const TextStyle(color: Color(0xFFA9C7FF), fontSize: 10)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text('${b['online_txt'] ?? '5420 On line'} | ', style: const TextStyle(color: Color(0xFF00E676), fontSize: 10, fontWeight: FontWeight.bold)),
                        Flexible(
                          child: Text(
                            '${b['recompensas_txt'] ?? '315 Recompensas'}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFFFFB703), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('3 MOTORES SDUI:', style: TextStyle(color: Color(0xFFA9C7FF), fontSize: 9, fontWeight: FontWeight.bold)),
                  const Text('ESQ3 + STAC + JDW', style: TextStyle(color: Color(0xFF00E676), fontSize: 11, fontWeight: FontWeight.w900)),
                  Text('1 USD = ${b['tasa_bs'] ?? '6.86'} Bs', style: const TextStyle(color: Colors.white70, fontSize: 9)),
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
                      color: const Color(0xFF101C2F),
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
                        decoration: BoxDecoration(color: const Color(0xFFFBB400), borderRadius: BorderRadius.circular(4)),
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