import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'escudo_aislamiento.dart';

class InspectorStitchSdui {
  static const List paletaStitchOficial = [
    {'nombre': 'Oro Santo', 'hex': '#FBB400'},
    {'nombre': 'Oro Claro', 'hex': '#FFD795'},
    {'nombre': 'Azul Rey', 'hex': '#00509D'},
    {'nombre': 'Azul Cian', 'hex': '#A9C7FF'},
    {'nombre': 'Noche Minera', 'hex': '#071326'},
    {'nombre': 'Contenedor', 'hex': '#142033'},
    {'nombre': 'Contenedor Alto', 'hex': '#1F2A3E'},
    {'nombre': 'Azul Terciario', 'hex': '#295186'},
    {'nombre': 'Verde Quórum', 'hex': '#00C853'},
    {'nombre': 'Coral Alerta', 'hex': '#FF3D71'},
    {'nombre': 'Rojo Intenso', 'hex': '#93000A'},
    {'nombre': 'Blanco Puro', 'hex': '#D7E3FD'},
  ];

  // Compatibilidad con el orquestador general
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
    if (!modoEditActivo) return child;
    return child;
  }

  // Envoltura interactiva para cada seccion de las 5 pantallas de Google Stitch
  static Widget envolverSeccionStitchPro({
    required BuildContext context,
    required bool modoEdit,
    required String idSeccion,
    required String nombreSeccion,
    required int index,
    required int total,
    required Map configSeccion,
    required Widget child,
    required Function onSubir,
    required Function onBajar,
    required Function onQuitar,
    required Function onDuplicar,
    required Function(Map) onGuardarConfig,
  }) {
    if (configSeccion['oculto'] == true) {
      if (!modoEdit) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2A3E).withAlpha(180),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFFB4AB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('👁️ Oculto: $nombreSeccion', style: const TextStyle(color: Color(0xFFFFB4AB), fontSize: 11, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                final Map nuevo = Map.from(configSeccion);
                nuevo['oculto'] = false;
                onGuardarConfig(nuevo);
              },
              child: const Text('MOSTRAR', style: TextStyle(color: Color(0xFFFBB400), fontSize: 11, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      );
    }

    final double escala = double.tryParse(configSeccion['escala']?.toString() ?? '1.0') ?? 1.0;
    final double padExtra = double.tryParse(configSeccion['padding_extra']?.toString() ?? '0.0') ?? 0.0;
    final double margenVert = double.tryParse(configSeccion['margen_vertical']?.toString() ?? '0.0') ?? 0.0;
    final double radioCustom = double.tryParse(configSeccion['radio_borde']?.toString() ?? '-1') ?? -1.0;
    final double altoFijo = double.tryParse(configSeccion['alto_fijo']?.toString() ?? '0') ?? 0.0;
    final double anchoFactor = (double.tryParse(configSeccion['ancho_porc']?.toString() ?? '100') ?? 100.0) / 100.0;
    final String? hexFondo = configSeccion['color_fondo_hex']?.toString();
    final String? hexBorde = configSeccion['color_borde_hex']?.toString();
    final double grosorBorde = double.tryParse(configSeccion['grosor_borde']?.toString() ?? '0') ?? 0.0;

    Widget resultado = child;

    if (hexFondo != null && hexFondo.isNotEmpty || grosorBorde > 0 || radioCustom >= 0) {
      resultado = Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.all(padExtra),
        decoration: BoxDecoration(
          color: (hexFondo != null && hexFondo.isNotEmpty) ? hexAColor(hexFondo) : null,
          borderRadius: BorderRadius.circular(radioCustom >= 0 ? radioCustom : 16),
          border: grosorBorde > 0
              ? Border.all(color: hexAColor(hexBorde, const Color(0xFFFBB400)), width: grosorBorde)
              : null,
        ),
        clipBehavior: radioCustom >= 0 ? Clip.antiAlias : Clip.none,
        child: resultado,
      );
    } else if (padExtra > 0) {
      resultado = Padding(padding: EdgeInsets.all(padExtra), child: resultado);
    }

    if (altoFijo >= 40) {
      resultado = SizedBox(height: altoFijo, child: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(), child: resultado));
    }

    if (anchoFactor < 0.99) {
      resultado = FractionallySizedBox(widthFactor: anchoFactor.clamp(0.5, 1.0), child: resultado);
    }

    if (escala != 1.0) {
      resultado = Transform.scale(scale: escala, child: resultado);
    }

    if (margenVert > 0) {
      resultado = Padding(padding: EdgeInsets.symmetric(vertical: margenVert), child: resultado);
    }

    if (!modoEdit) return resultado;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFBB400), width: 1.8),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFBB400).withAlpha(45), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra flotante compacta estilo Stitch Modify
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(
              color: Color(0xFF101C2F),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.drag_indicator, color: Color(0xFFFBB400), size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${index + 1}. $nombreSeccion',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFFD7E3FD), fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index > 0)
                      InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onSubir();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          child: Icon(Icons.keyboard_arrow_up, color: Color(0xFFA9C7FF), size: 19),
                        ),
                      ),
                    if (index < total - 1)
                      InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onBajar();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          child: Icon(Icons.keyboard_arrow_down, color: Color(0xFFA9C7FF), size: 19),
                        ),
                      ),
                    InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        abrirEditorProfundoStitch(
                          context: context,
                          idSeccion: idSeccion,
                          nombreSeccion: nombreSeccion,
                          configActual: configSeccion,
                          vistaPrevia: child,
                          onSubir: onSubir,
                          onBajar: onBajar,
                          onQuitar: onQuitar,
                          onDuplicar: onDuplicar,
                          onGuardar: onGuardarConfig,
                        );
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
                            Icon(Icons.tune, color: Color(0xFF071326), size: 13),
                            SizedBox(width: 3),
                            Text('EDITAR', style: TextStyle(color: Color(0xFF071326), fontSize: 9.5, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        onQuitar();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.close, color: Color(0xFFFFB4AB), size: 17),
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
              abrirEditorProfundoStitch(
                context: context,
                idSeccion: idSeccion,
                nombreSeccion: nombreSeccion,
                configActual: configSeccion,
                vistaPrevia: child,
                onSubir: onSubir,
                onBajar: onBajar,
                onQuitar: onQuitar,
                onDuplicar: onDuplicar,
                onGuardar: onGuardarConfig,
              );
            },
            child: resultado,
          ),
        ],
      ),
    );
  }

  static void abrirEditorProfundoStitch({
    required BuildContext context,
    required String idSeccion,
    required String nombreSeccion,
    required Map configActual,
    required Widget vistaPrevia,
    required Function onSubir,
    required Function onBajar,
    required Function onQuitar,
    required Function onDuplicar,
    required Function(Map) onGuardar,
  }) {
    final Map cfg = Map.from(configActual);
    int tabActiva = 0; // 0 = Textos/Datos, 1 = Colores HEX/RGB, 2 = Dimensiones/Bordes
    String targetColorKey = 'color_acento_hex';

    final ctrlTitulo = TextEditingController(text: cfg['titulo']?.toString() ?? '');
    final ctrlSubtitulo = TextEditingController(text: cfg['subtitulo']?.toString() ?? '');
    final ctrlBadge = TextEditingController(text: cfg['badge']?.toString() ?? '');
    final ctrlBoton = TextEditingController(text: cfg['boton_txt']?.toString() ?? '');
    final ctrlValor = TextEditingController(text: cfg['valor_destacado']?.toString() ?? '');
    final ctrlImg = TextEditingController(text: cfg['imagen_url']?.toString() ?? '');
    final ctrlHex = TextEditingController(text: cfg[targetColorKey]?.toString() ?? '#FBB400');

    Color colorRgbActual = hexAColor(ctrlHex.text, const Color(0xFFFBB400));
    int rVal = colorRgbActual.red;
    int gVal = colorRgbActual.green;
    int bVal = colorRgbActual.blue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF071326),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctxM, setModal) {
            final double escala = double.tryParse(cfg['escala']?.toString() ?? '1.0') ?? 1.0;
            final double anchoPorc = double.tryParse(cfg['ancho_porc']?.toString() ?? '100') ?? 100.0;
            final double altoFijo = double.tryParse(cfg['alto_fijo']?.toString() ?? '0') ?? 0.0;
            final double padExtra = double.tryParse(cfg['padding_extra']?.toString() ?? '0') ?? 0.0;
            final double margenVert = double.tryParse(cfg['margen_vertical']?.toString() ?? '0') ?? 0.0;
            final double radioBorde = double.tryParse(cfg['radio_borde']?.toString() ?? '16') ?? 16.0;
            final double grosorBorde = double.tryParse(cfg['grosor_borde']?.toString() ?? '0') ?? 0.0;

            void sincronizarRgbHaciaHex() {
              final String hexNuevo = '#'
                  '${rVal.toRadixString(16).padLeft(2, '0')}'
                  '${gVal.toRadixString(16).padLeft(2, '0')}'
                  '${bVal.toRadixString(16).padLeft(2, '0')}'
                  .toUpperCase();
              ctrlHex.text = hexNuevo;
              cfg[targetColorKey] = hexNuevo;
            }

            return SafeArea(
              child: Container(
                height: MediaQuery.of(ctxM).size.height * 0.90,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabecera del Inspector Stitch Studio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBB400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.auto_fix_high, color: Color(0xFF071326), size: 18),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'STITCH STUDIO INSPECTOR PRO',
                                      style: TextStyle(color: Color(0xFFFBB400), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                                    ),
                                    Text(
                                      nombreSeccion,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Color(0xFFD7E3FD), fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctxM),
                          icon: const Icon(Icons.close, color: Color(0xFFFFB4AB)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Acciones rapidas de posicion (Subir, Bajar, Duplicar, Quitar)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF295186))),
                            icon: const Icon(Icons.arrow_upward, size: 15, color: Color(0xFFA9C7FF)),
                            label: const Text('Subir', style: TextStyle(color: Color(0xFFD7E3FD), fontSize: 11)),
                            onPressed: () {
                              onSubir();
                              Navigator.pop(ctxM);
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF295186))),
                            icon: const Icon(Icons.arrow_downward, size: 15, color: Color(0xFFA9C7FF)),
                            label: const Text('Bajar', style: TextStyle(color: Color(0xFFD7E3FD), fontSize: 11)),
                            onPressed: () {
                              onBajar();
                              Navigator.pop(ctxM);
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFBB400))),
                            icon: const Icon(Icons.copy, size: 15, color: Color(0xFFFBB400)),
                            label: const Text('Duplicar', style: TextStyle(color: Color(0xFFFBB400), fontSize: 11)),
                            onPressed: () {
                              onDuplicar();
                              Navigator.pop(ctxM);
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFFB4AB))),
                          icon: const Icon(Icons.delete_outline, size: 15, color: Color(0xFFFFB4AB)),
                          label: const Text('Quitar', style: TextStyle(color: Color(0xFFFFB4AB), fontSize: 11)),
                          onPressed: () {
                            onQuitar();
                            Navigator.pop(ctxM);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Selector de las 3 Pestanas del Editor
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101C2F),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModal(() => tabActiva = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: tabActiva == 0 ? const Color(0xFF00509D) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('✏️ 1. Textos y Fotos', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModal(() => tabActiva = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: tabActiva == 1 ? const Color(0xFF00509D) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('🎨 2. Colores HEX/RGB', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModal(() => tabActiva = 2),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: tabActiva == 2 ? const Color(0xFF00509D) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('📐 3. Dimensiones', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Contenido de cada pestana
                    Expanded(
                      child: ListView(
                        children: [
                          if (tabActiva == 0) ...[
                            _campoEditor('Título Principal del Bloque:', ctrlTitulo, (v) => setModal(() => cfg['titulo'] = v)),
                            _campoEditor('Subtítulo / Descripción:', ctrlSubtitulo, (v) => setModal(() => cfg['subtitulo'] = v), maxLines: 2),
                            _campoEditor('Texto de Insignia / Badge Superior:', ctrlBadge, (v) => setModal(() => cfg['badge'] = v)),
                            _campoEditor('Texto del Botón de Acción:', ctrlBoton, (v) => setModal(() => cfg['boton_txt'] = v)),
                            _campoEditor('Monto / Cifra / Contador Destacado (Ej: 480 pts, 14.2k, 70 BS):', ctrlValor, (v) => setModal(() => cfg['valor_destacado'] = v)),
                            _campoEditor('URL de Imagen o Fotografía (https://...):', ctrlImg, (v) => setModal(() => cfg['imagen_url'] = v)),
                          ],

                          if (tabActiva == 1) ...[
                            const Text('1. ¿Qué parte del bloque deseas colorear?', style: TextStyle(color: Color(0xFFA9C7FF), fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                {'key': 'color_acento_hex', 'label': '✨ Botón / Acento'},
                                {'key': 'color_fondo_hex', 'label': '🎴 Fondo Bloque'},
                                {'key': 'color_texto_hex', 'label': '🔤 Texto / Título'},
                                {'key': 'color_borde_hex', 'label': '🖼️ Borde Exterior'},
                              ].map((item) {
                                final String k = item['key']!;
                                final bool sel = targetColorKey == k;
                                return ChoiceChip(
                                  label: Text(item['label']!, style: TextStyle(color: sel ? const Color(0xFF071326) : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  selected: sel,
                                  selectedColor: const Color(0xFFFBB400),
                                  backgroundColor: const Color(0xFF142033),
                                  onSelected: (_) {
                                    setModal(() {
                                      targetColorKey = k;
                                      ctrlHex.text = cfg[targetColorKey]?.toString() ?? '#FBB400';
                                      final c = hexAColor(ctrlHex.text);
                                      rVal = c.red;
                                      gVal = c.green;
                                      bVal = c.blue;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: hexAColor(ctrlHex.text),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: ctrlHex,
                                    style: const TextStyle(color: Color(0xFFFBB400), fontFamily: 'monospace', fontSize: 15, fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      labelText: 'Código de Color HEX (#RRGGBB)',
                                      labelStyle: const TextStyle(color: Colors.white70, fontSize: 11),
                                      filled: true,
                                      fillColor: const Color(0xFF101C2F),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onChanged: (v) {
                                      setModal(() {
                                        cfg[targetColorKey] = v.trim();
                                        final c = hexAColor(v.trim());
                                        rVal = c.red;
                                        gVal = c.green;
                                        bVal = c.blue;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text('2. Mezclador de Colores en Vivo (Barras R / G / B):', style: TextStyle(color: Color(0xFFA9C7FF), fontSize: 11, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                const SizedBox(width: 24, child: Text('R', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
                                Expanded(
                                  child: Slider(
                                    value: rVal.toDouble(),
                                    min: 0,
                                    max: 255,
                                    activeColor: Colors.redAccent,
                                    onChanged: (v) => setModal(() {
                                      rVal = v.round();
                                      sincronizarRgbHaciaHex();
                                    }),
                                  ),
                                ),
                                Text('$rVal', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 24, child: Text('G', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))),
                                Expanded(
                                  child: Slider(
                                    value: gVal.toDouble(),
                                    min: 0,
                                    max: 255,
                                    activeColor: Colors.greenAccent,
                                    onChanged: (v) => setModal(() {
                                      gVal = v.round();
                                      sincronizarRgbHaciaHex();
                                    }),
                                  ),
                                ),
                                Text('$gVal', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 24, child: Text('B', style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold))),
                                Expanded(
                                  child: Slider(
                                    value: bVal.toDouble(),
                                    min: 0,
                                    max: 255,
                                    activeColor: Colors.lightBlueAccent,
                                    onChanged: (v) => setModal(() {
                                      bVal = v.round();
                                      sincronizarRgbHaciaHex();
                                    }),
                                  ),
                                ),
                                Text('$bVal', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('3. Paleta Rápida Google Stitch:', style: TextStyle(color: Color(0xFFA9C7FF), fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: paletaStitchOficial.map((p) {
                                final Map mp = Map.from(p as Map);
                                final String hx = mp['hex'].toString();
                                final Color col = hexAColor(hx);
                                return InkWell(
                                  onTap: () {
                                    setModal(() {
                                      ctrlHex.text = hx;
                                      cfg[targetColorKey] = hx;
                                      rVal = col.red;
                                      gVal = col.green;
                                      bVal = col.blue;
                                    });
                                  },
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
                                        Text('${mp['nombre']} ($hx)', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          if (tabActiva == 2) ...[
                            _sliderDimension(
                              titulo: '🔍 Escala General del Componente',
                              valorTexto: '${(escala * 100).round()}%',
                              valor: escala.clamp(0.70, 1.30),
                              min: 0.70,
                              max: 1.30,
                              onChanged: (v) => setModal(() => cfg['escala'] = v.toStringAsFixed(2)),
                            ),
                            _sliderDimension(
                              titulo: '↔️ Ancho del Componente (%)',
                              valorTexto: '${anchoPorc.round()}%',
                              valor: anchoPorc.clamp(60.0, 100.0),
                              min: 60.0,
                              max: 100.0,
                              onChanged: (v) => setModal(() => cfg['ancho_porc'] = v.round().toString()),
                            ),
                            _sliderDimension(
                              titulo: '↕️ Altura Fija (0 = Automática)',
                              valorTexto: altoFijo < 40 ? 'Auto' : '${altoFijo.round()} px',
                              valor: altoFijo.clamp(0.0, 650.0),
                              min: 0.0,
                              max: 650.0,
                              onChanged: (v) => setModal(() => cfg['alto_fijo'] = v.round().toString()),
                            ),
                            _sliderDimension(
                              titulo: '🔲 Radio de Esquinas Redondeadas',
                              valorTexto: '${radioBorde.round()} px',
                              valor: radioBorde.clamp(0.0, 36.0),
                              min: 0.0,
                              max: 36.0,
                              onChanged: (v) => setModal(() => cfg['radio_borde'] = v.round().toString()),
                            ),
                            _sliderDimension(
                              titulo: '🖼️ Grosor del Borde Perimetral',
                              valorTexto: '${grosorBorde.toStringAsFixed(1)} px',
                              valor: grosorBorde.clamp(0.0, 5.0),
                              min: 0.0,
                              max: 5.0,
                              onChanged: (v) => setModal(() => cfg['grosor_borde'] = v.toStringAsFixed(1)),
                            ),
                            _sliderDimension(
                              titulo: '📦 Relleno Interno (Padding Extra)',
                              valorTexto: '${padExtra.round()} px',
                              valor: padExtra.clamp(0.0, 28.0),
                              min: 0.0,
                              max: 28.0,
                              onChanged: (v) => setModal(() => cfg['padding_extra'] = v.round().toString()),
                            ),
                            _sliderDimension(
                              titulo: '↕️ Separación Vertical (Margen)',
                              valorTexto: '${margenVert.round()} px',
                              valor: margenVert.clamp(0.0, 32.0),
                              min: 0.0,
                              max: 32.0,
                              onChanged: (v) => setModal(() => cfg['margen_vertical'] = v.round().toString()),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFFB4AB))),
                              icon: const Icon(Icons.restart_alt, color: Color(0xFFFFB4AB)),
                              label: const Text('RESTABLECER DIMENSIONES Y COLORES DE ESTE BLOQUE', style: TextStyle(color: Color(0xFFFFB4AB), fontSize: 11, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                onGuardar({});
                                Navigator.pop(ctxM);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBB400),
                          foregroundColor: const Color(0xFF071326),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.save, size: 18),
                        label: const Text('APLICAR Y GUARDAR EN SUPABASE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                        onPressed: () {
                          onGuardar(cfg);
                          Navigator.pop(ctxM);
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

  static Widget _campoEditor(String label, TextEditingController ctrl, Function(String) onChanged, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFA9C7FF), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF101C2F),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  static Widget _sliderDimension({
    required String titulo,
    required String valorTexto,
    required double valor,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titulo, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
              Text(valorTexto, style: const TextStyle(color: Color(0xFFFBB400), fontSize: 12, fontWeight: FontWeight.w900)),
            ],
          ),
          Slider(
            value: valor,
            min: min,
            max: max,
            activeColor: const Color(0xFFFBB400),
            inactiveColor: const Color(0xFF1F2A3E),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}