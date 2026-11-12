import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'escudo_aislamiento.dart';

class InspectorStitchSdui {
  static const List paletaColoresSanto = [
    {'nombre': 'Oro Quirquincho', 'hex': '#FFB703'},
    {'nombre': 'Azul Rey Santo', 'hex': '#00509D'},
    {'nombre': 'Cian Eléctrico', 'hex': '#A9C7FF'},
    {'nombre': 'Verde Quórum 51%', 'hex': '#00C853'},
    {'nombre': 'Coral Alerta', 'hex': '#FF3D71'},
    {'nombre': 'Azul Profundo', 'hex': '#134074'},
    {'nombre': 'Noche Minera', 'hex': '#142033'},
    {'nombre': 'Blanco Puro', 'hex': '#FFFFFF'},
  ];

  static Widget envolverConMarcoStitch({
    required bool modoEditActivo,
    required Map bloque,
    required int indice,
    required int totalBloques,
    required Widget child,
    required Function onZoomInspeccionar,
    required Function onSubirLugar,
    required Function onBajarLugar,
    required Function onQuitarComponente,
  }) {
    final double escala = double.tryParse(bloque['escala_stitch']?.toString() ?? '1.0') ?? 1.0;
    final Widget contenidoEscalado = escala != 1.0
        ? Transform.scale(scale: escala, child: child)
        : child;

    if (!modoEditActivo) return contenidoEscalado;

    final String idComp = bloque['id']?.toString() ?? 'comp_$indice';
    final String tipoComp = bloque['tipo']?.toString() ?? 'TARJETA_NEON';
    final Color colorActual = hexAColor(bloque['color_borde']?.toString(), const Color(0xFFFFB703));

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00F3FF), width: 2.2),
        boxShadow: [
          BoxShadow(color: const Color(0xFF00F3FF).withAlpha(65), blurRadius: 14),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF00509D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(color: colorActual, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '#${indice + 1} [$idComp] · $tipoComp',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (indice > 0)
                      InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onSubirLugar();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.arrow_upward, color: Color(0xFFFFD795), size: 17),
                        ),
                      ),
                    if (indice < totalBloques - 1)
                      InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onBajarLugar();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.arrow_downward, color: Color(0xFFFFD795), size: 17),
                        ),
                      ),
                    InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        onZoomInspeccionar();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBB400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.zoom_in, color: Color(0xFF071326), size: 14),
                            SizedBox(width: 3),
                            Text('EDIT / ZOOM', style: TextStyle(color: Color(0xFF071326), fontSize: 9.5, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        onQuitarComponente();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.delete_forever, color: Color(0xFFFFB4AB), size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              onZoomInspeccionar();
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: contenidoEscalado,
            ),
          ),
        ],
      ),
    );
  }

  static void abrirZoomComponenteStitch({
    required BuildContext context,
    required List listaBloquesPantalla,
    required int indiceInicial,
    required Widget Function(Map) constructorVistaPrevia,
    required Function(List) onGuardarCambiosEnNube,
  }) {
    int idxActual = indiceInicial;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF071326),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctxModal, setModalState) {
            if (listaBloquesPantalla.isEmpty) {
              Navigator.pop(ctxModal);
              return const SizedBox.shrink();
            }
            if (idxActual >= listaBloquesPantalla.length) {
              idxActual = listaBloquesPantalla.length - 1;
            }
            final Map b = Map.from(listaBloquesPantalla[idxActual] as Map);
            final TextEditingController ctrlTitulo = TextEditingController(text: b['titulo']?.toString() ?? '');
            final TextEditingController ctrlSub = TextEditingController(text: b['subtitulo']?.toString() ?? '');
            final double escalaActual = double.tryParse(b['escala_stitch']?.toString() ?? '1.0') ?? 1.0;

            void aplicarCambio(Map nuevosCampos) {
              final Map actualizado = {...b, ...nuevosCampos};
              listaBloquesPantalla[idxActual] = actualizado;
              setModalState(() {});
            }

            return SafeArea(
              child: Container(
                height: MediaQuery.of(ctxModal).size.height * 0.90,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_fix_high, color: Color(0xFFFBB400), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'STITCH EDIT · COMPONENTE ${idxActual + 1}/${listaBloquesPantalla.length}',
                              style: const TextStyle(color: Color(0xFFFBB400), fontWeight: FontWeight.w900, fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left, color: Colors.white),
                              onPressed: idxActual > 0 ? () => setModalState(() => idxActual--) : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right, color: Colors.white),
                              onPressed: idxActual < listaBloquesPantalla.length - 1 ? () => setModalState(() => idxActual++) : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.redAccent),
                              onPressed: () => Navigator.pop(ctxModal),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF2A3549)),
                    const Text(
                      '🔍 VISTA ACERCADA DEL COMPONENTE (PELLIZCA PARA HACER ZOOM):',
                      style: TextStyle(color: Color(0xFFA9C7FF), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 220,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF030E21),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF00509D), width: 1.5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InteractiveViewer(
                        minScale: 0.7,
                        maxScale: 3.0,
                        child: SingleChildScrollView(
                          child: Transform.scale(
                            scale: escalaActual,
                            child: constructorVistaPrevia(b),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F2A3E)),
                                  icon: const Icon(Icons.arrow_upward, color: Color(0xFFA9C7FF), size: 16),
                                  label: const Text('SUBIR LUGAR', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  onPressed: idxActual > 0
                                      ? () {
                                          final temp = listaBloquesPantalla.removeAt(idxActual);
                                          listaBloquesPantalla.insert(idxActual - 1, temp);
                                          setModalState(() => idxActual--);
                                        }
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F2A3E)),
                                  icon: const Icon(Icons.arrow_downward, color: Color(0xFFA9C7FF), size: 16),
                                  label: const Text('BAJAR LUGAR', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  onPressed: idxActual < listaBloquesPantalla.length - 1
                                      ? () {
                                          final temp = listaBloquesPantalla.removeAt(idxActual);
                                          listaBloquesPantalla.insert(idxActual + 1, temp);
                                          setModalState(() => idxActual++);
                                        }
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF93000A)),
                                icon: const Icon(Icons.delete_outline, color: Color(0xFFFFDAD6), size: 16),
                                label: const Text('QUITAR', style: TextStyle(color: Color(0xFFFFDAD6), fontSize: 11, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  listaBloquesPantalla.removeAt(idxActual);
                                  onGuardarCambiosEnNube(listaBloquesPantalla);
                                  Navigator.pop(ctxModal);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('🎨 CAMBIAR COLOR DEL COMPONENTE:', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: paletaColoresSanto.map((c) {
                              final Map mc = Map.from(c as Map);
                              final String hex = mc['hex'].toString();
                              final Color col = hexAColor(hex);
                              return InkWell(
                                onTap: () => aplicarCambio({'color_borde': hex}),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF142033),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: col, width: 2),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle)),
                                      const SizedBox(width: 6),
                                      Text(mc['nombre'].toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('📐 TAMAÑO / ESCALA VISUAL:', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text('${(escalaActual * 100).round()}%', style: const TextStyle(color: Color(0xFFFBB400), fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          Slider(
                            value: escalaActual.clamp(0.75, 1.25),
                            min: 0.75,
                            max: 1.25,
                            divisions: 10,
                            activeColor: const Color(0xFFFBB400),
                            onChanged: (val) => aplicarCambio({'escala_stitch': val.toStringAsFixed(2)}),
                          ),
                          const Text('✏️ EDITAR TÍTULO DEL COMPONENTE:', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          TextField(
                            controller: ctrlTitulo,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF101C2F),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (v) => b['titulo'] = v,
                          ),
                          const SizedBox(height: 10),
                          const Text('📝 EDITAR SUBTÍTULO / DESCRIPCIÓN:', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          TextField(
                            controller: ctrlSub,
                            maxLines: 2,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF101C2F),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (v) => b['subtitulo'] = v,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBB400),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.cloud_upload, color: Color(0xFF071326)),
                        label: const Text(
                          '💾 GUARDAR CAMBIOS DE ESTE COMPONENTE EN SUPABASE',
                          style: TextStyle(color: Color(0xFF071326), fontWeight: FontWeight.w900, fontSize: 12),
                        ),
                        onPressed: () {
                          listaBloquesPantalla[idxActual] = b;
                          onGuardarCambiosEnNube(listaBloquesPantalla);
                          Navigator.pop(ctxModal);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}