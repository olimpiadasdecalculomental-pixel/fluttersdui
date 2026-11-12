import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/escudo_aislamiento.dart';
import '../nucleo/puente_supabase_sdui.dart';

class Ms02CatalogoYDragDrop {
  static Widget construirGridTarjetas2Col({
    required Map b,
    required double anchoPantalla,
    required Function(String) onFeedback,
  }) {
    final bool esTablet = anchoPantalla >= 650;
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFF00F3FF));
    final List items = (b['items_grid'] as List?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (b['titulo'] != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(b['titulo'].toString(), style: TextStyle(color: colorBorde, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: esTablet ? 4 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.82,
          ),
          itemCount: items.length,
          itemBuilder: (ctx, idx) {
            final it = Map.from(items[idx] as Map);
            final c = hexAColor(it['color']?.toString(), colorBorde);
            return InkWell(
              onTap: () => onFeedback('🎬 Abriendo: ${it['titulo']} (${it['precio']})'),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: c, width: 1.5),
                  boxShadow: [BoxShadow(color: c.withAlpha(64), blurRadius: 8)],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.black87,
                      child: Text(
                        it['badge_top']?.toString() ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: it['imagen_url'] != null
                          ? Image.network(
                              it['imagen_url'].toString(),
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.movie_filter, size: 40, color: Color(0xFF00F3FF))),
                            )
                          : const Center(child: Icon(Icons.movie, size: 40, color: Colors.white54)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it['titulo']?.toString() ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(it['subtitulo']?.toString() ?? '', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(height: 4),
                          Text(it['precio']?.toString() ?? '', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  static Widget construirDragAndDropLista({
    required Map b,
    required Function(String) onFeedback,
    required Function onRefrescarUi,
  }) {
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFFFF00FC));
    final List itemsOrig = List.from((b['items_lista'] as List?) ?? [
      '1. Bloque Cabecera Imperio (Arrastrar ☰)',
      '2. Bloque Reproductor 4DX / 5D (Arrastrar ☰)',
      '3. Bloque Cuadrícula Ecosistema (Arrastrar ☰)',
      '4. Bloque Radar GPS y Cripto (Arrastrar ☰)'
    ]);

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
          Text(b['titulo']?.toString() ?? '🖐️ DRAG & DROP: ARRASTRA Y ORDENA EN BD', style: TextStyle(color: colorBorde, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(b['subtitulo']?.toString() ?? 'Mantén presionado un elemento para moverlo y guardar su posición en Supabase:', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 10),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) async {
              HapticFeedback.mediumImpact();
              if (newIndex > oldIndex) newIndex -= 1;
              final itemMovido = itemsOrig.removeAt(oldIndex);
              itemsOrig.insert(newIndex, itemMovido);
              b['items_lista'] = itemsOrig;
              onFeedback('🖐️ Orden actualizado (${oldIndex + 1} ➔ ${newIndex + 1}) y guardado en BD.');
              onRefrescarUi();
              await PuenteSupabaseSdui.ejecutarRpcUniversal('esq3_rpc_mover_componente_drag_drop', {
                'p_id_pantalla': b['id_pantalla_origen'] ?? 'RAIZ',
                'p_id_bloque': b['id'] ?? 'drag_drop_bloque',
                'p_nuevo_orden_json': itemsOrig
              });
            },
            children: List.generate(itemsOrig.length, (idx) {
              final txt = itemsOrig[idx].toString();
              return Container(
                key: ValueKey('dd_${b['id']}_$idx'),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorBorde),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(txt, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                    Icon(Icons.drag_handle, color: colorBorde, size: 20),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}