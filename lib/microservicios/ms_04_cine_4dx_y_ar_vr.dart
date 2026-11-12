import 'package:flutter/material.dart';

class Ms04Cine4dxYArVr {
  static Widget construirVisorArVr360({
    required Map b,
    required String modoRealidad,
    required double offsetVrX,
    required Function(double) onDragVrX,
    required Function(String) onCambiarModo,
    required Function onGuardarOffline,
  }) {
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
          Text(b['titulo']?.toString() ?? '🥽 VISOR INMERSIVO AR / VR 360 / WEBAR', style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          const Text('Desliza horizontalmente para girar en 360° o alterna entre Lentes VR y Holograma AR con Láser Rojo:', style: TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 10),
          GestureDetector(
            onHorizontalDragUpdate: (d) => onDragVrX(d.delta.dx),
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00F3FF), width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: modoRealidad == 'VR'
                  ? Row(
                      children: [0, 1].map((ojo) => Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(right: BorderSide(color: ojo == 0 ? const Color(0xFF00F3FF) : Colors.transparent, width: 2)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: offsetVrX - 40,
                                    right: -offsetVrX - 40,
                                    top: -20,
                                    bottom: -20,
                                    child: Image.network(
                                      'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(color: const Color(0xFF041C2C)),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFF00FF66), width: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )).toList(),
                    )
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&q=80',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF051A05)),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 190,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF00FF66), width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width: 170, height: 3, color: Colors.redAccent),
                                const SizedBox(height: 12),
                                const Text('🎯 HOLOGRAMA AR 3D FIJADO', style: TextStyle(color: Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.bold, backgroundColor: Colors.black87)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: modoRealidad == 'AR' ? const Color(0xFF00FF66) : const Color(0xFF1E293B)),
                onPressed: () => onCambiarModo('AR'),
                child: Text('🔮 CINE AR (LÁSER)', style: TextStyle(color: modoRealidad == 'AR' ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: modoRealidad == 'VR' ? const Color(0xFF00F3FF) : const Color(0xFF1E293B)),
                onPressed: () => onCambiarModo('VR'),
                child: Text('🥽 LENTES VR 360', style: TextStyle(color: modoRealidad == 'VR' ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF00FC)),
                onPressed: () => onGuardarOffline(),
                child: const Text('📥 GUARDAR OFFLINE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}