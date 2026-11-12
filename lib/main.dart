import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String SUPABASE_URL = 'https://alxbydjpoxoavasklwpd.supabase.co';
const String SUPABASE_KEY = 'sb_publishable_Kc8wekwUqIs78ILNF-j-Qg_LNMYRhn0';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OrbeSuperAppSdui());
}

Color hexAColor(String? hex, [Color defecto = const Color(0xFF00F3FF)]) {
  if (hex == null || hex.isEmpty) return defecto;
  String limpio = hex.replaceAll('#', '').trim();
  if (limpio.length == 6) limpio = 'FF$limpio';
  final val = int.tryParse(limpio, radix: 16);
  return val != null ? Color(val) : defecto;
}

class OrbeSuperAppSdui extends StatelessWidget {
  const OrbeSuperAppSdui({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperApp Orbe SDUI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF05050F),
      ),
      home: const LienzoMaestroSdui(),
    );
  }
}

class LienzoMaestroSdui extends StatefulWidget {
  const LienzoMaestroSdui({super.key});

  @override
  State createState() => _LienzoMaestroSduiState();
}

class _LienzoMaestroSduiState extends State with WidgetsBindingObserver {
  final PageController _pageCtrl = PageController();

  int _indicePagina = 0;
  bool _esAdmin = false;
  int _toquesEsquina = 0;
  Timer? _timerToques;
  Timer? _timer4DX;
  bool _modo4DXActivo = false;
  int _episodioCineActual = 0;
  String _modoRealidad = 'VR';
  double _offsetVrX = 0.0;
  bool _arduinoLed1 = true;
  bool _arduinoRele2 = false;
  final Set _celdasLumosity = {0, 4, 8};
  int _xpDuolingo = 120;
  String _feedback = '';
  final Map _estadoForm = {};

  final List _trazosPizarra = [];
  Color _colorLapizActual = const Color(0xFF00FF66);

  Map _contrato = {
    'geometria': {
      'color_fondo': '#05050F',
      'color_tarjeta': '#0A0A1C',
      'color_primario': '#00F3FF',
      'color_secundario': '#00FF66',
      'color_terciario': '#FF00FC',
      'margen_arriba': 34,
      'margen_abajo': 48,
      'margen_izquierda': 0,
      'margen_derecha': 0,
    },
    'pestanas': [
      {'id': 'RAIZ', 'titulo': '🎮 ECOSISTEMA', 'visible': true}
    ],
    'pantallas_json': {'RAIZ': []}
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sincronizarContratoSdui();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerToques?.cancel();
    _timer4DX?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      sincronizarContratoSdui();
    }
  }

  File _archivoCacheLocal() {
    return File('${Directory.systemTemp.path}/cache_contrato_esq3.json');
  }

  Future ejecutarRpcUniversal(String nombreRpc, Map payload) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 6);
    try {
      final req = await client.postUrl(Uri.parse('$SUPABASE_URL/rest/v1/rpc/$nombreRpc'));
      req.headers.set('apikey', SUPABASE_KEY);
      req.headers.set('Authorization', 'Bearer $SUPABASE_KEY');
      req.headers.set('Accept-Profile', 'esquema3');
      req.headers.set('Content-Profile', 'esquema3');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.headers.set('Cache-Control', 'no-cache');
      req.add(utf8.encode(jsonEncode(payload)));
      final res = await req.close().timeout(const Duration(seconds: 6));
      final body = await res.transform(utf8.decoder).join();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return body.isNotEmpty ? Map.from(jsonDecode(body) as Map) : {'exito': true};
      }
      return {'exito': false, 'mensaje': body};
    } catch (e) {
      return {'exito': false, 'mensaje': e.toString()};
    } finally {
      client.close();
    }
  }

  Future sincronizarContratoSdui() async {
    try {
      final f = _archivoCacheLocal();
      if (await f.exists()) {
        final txt = await f.readAsString();
        if (txt.isNotEmpty) {
          final cachedMap = Map.from(jsonDecode(txt) as Map);
          if (mounted) setState(() => _contrato = cachedMap);
        }
      }
    } catch (_) {}

    final check = await ejecutarRpcUniversal('esq3_rpc_verificar_version', {
      'p_modulo': 'MODULO_MAESTRO_V1',
      'p_version_cliente': 0,
    });

    if (check['requiere_descarga'] == true && check['contrato'] != null) {
      final nuevoContrato = Map.from(check['contrato'] as Map);
      try {
        await _archivoCacheLocal().writeAsString(jsonEncode(nuevoContrato));
      } catch (_) {}
      if (mounted) setState(() => _contrato = nuevoContrato);
    }
  }

  void _tocarEsquinaCincoVeces() {
    _toquesEsquina++;
    _timerToques?.cancel();
    if (_toquesEsquina >= 5) {
      _toquesEsquina = 0;
      _abrirCandadoNegroCamuflado();
    } else {
      _timerToques = Timer(const Duration(milliseconds: 1800), () => _toquesEsquina = 0);
    }
  }

  void _abrirCandadoNegroCamuflado() {
    String clave = '';
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (ctx) => Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: (v) => clave = v,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final limpia = clave.trim();
                    if (limpia == '?1942?' || limpia == '1942?' || limpia == '1942') {
                      setState(() => _esAdmin = true);
                      await sincronizarContratoSdui();
                      _abrirModalEditorJson();
                    }
                  },
                  child: const Text('ENTRAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _abrirModalEditorJson() {
    final ctrl = TextEditingController(text: const JsonEncoder.withIndent('  ').convert(_contrato));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A1C),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('👑 EDITOR REMOTO EN CALIENTE (ESQUEMA 3)', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 12)),
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('✖ CERRAR', style: TextStyle(color: Colors.redAccent))),
              ],
            ),
            SizedBox(
              height: 340,
              child: TextField(
                controller: ctrl,
                maxLines: null,
                expands: true,
                style: const TextStyle(color: Color(0xFF00F3FF), fontFamily: 'monospace', fontSize: 11),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF020617),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66), padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () async {
                  try {
                    final nuevo = Map.from(jsonDecode(ctrl.text) as Map);
                    setState(() => _contrato = nuevo);
                    await ejecutarRpcUniversal('esq3_rpc_actualizar_sdui', {'p_modulo': 'MODULO_MAESTRO_V1', 'p_nuevo_json': nuevo});
                    if (ctx.mounted) Navigator.pop(ctx);
                  } catch (e) {
                    setState(() => _feedback = '❌ Error JSON: $e');
                  }
                },
                child: const Text('🚀 PUBLICAR CAMBIOS A SUPABASE (ESQUEMA 3)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _dispararAccionBoton(Map btn, Map bloquePadre) async {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    final accion = btn['accion']?.toString() ?? 'EJECUTAR_RPC';

    if (accion == 'ABRIR_EDITOR_JSON_CALIENTE') {
      _abrirModalEditorJson();
      return;
    }

    if (accion == 'DESCARGAR_VIDEO_OFFLINE') {
      final f = File('${Directory.systemTemp.path}/video_offline_orbe.mp4');
      await f.writeAsString('CACHE_VIDEO_MP4_ORBE_OFFLINE');
      setState(() => _feedback = '📶 Wi-Fi Detectado: Video guardado en memoria Offline (${f.path}).');
      return;
    }

    if (accion == 'HABLAR_IDIOMA_TTS') {
      final idioma = btn['idioma']?.toString() ?? 'en-US';
      final frase = btn['frase']?.toString() ?? 'Welcome to Orbe Imperio SuperApp';
      setState(() {
        _xpDuolingo += 5;
        _feedback = '🗣️ Duolingo Audio ($idioma): "$frase" (XP Total: $_xpDuolingo)';
      });
      return;
    }

    if (accion == 'ESCUCHAR_MICROFONO_STT') {
      HapticFeedback.heavyImpact();
      setState(() {
        _xpDuolingo += 15;
        _feedback = '🎙️ Pronunciación verificada: "Welcome to Orbe Imperio" (+15 XP | Total: $_xpDuolingo XP)';
      });
      return;
    }

    if (accion == 'TOGGLE_EFECTO_4DX_5D') {
      _timer4DX?.cancel();
      setState(() => _modo4DXActivo = !_modo4DXActivo);
      if (_modo4DXActivo) {
        _timer4DX = Timer.periodic(const Duration(milliseconds: 900), (_) {
          HapticFeedback.heavyImpact();
        });
        setState(() => _feedback = '🎢 MODO CINE 4DX / 5D ACTIVO: Vibración háptica y sensores sincronizados.');
      } else {
        setState(() => _feedback = '⏹️ Efectos físicos 4DX / 5D detenidos.');
      }
      return;
    }

    if (accion == 'ESCANEAR_ARDUINO_BLUETOOTH') {
      HapticFeedback.selectionClick();
      setState(() => _feedback = '🔵 Radar Bluetooth BLE & Wi-Fi: Arduino UNO / ESP32-ORBE enlazado (Señal -42 dBm).');
      return;
    }

    if (accion == 'PROBAR_IOT_MQTT') {
      HapticFeedback.selectionClick();
      setState(() => _feedback = '📡 Telemetría IoT MQTT (broker.hivemq.com:1883): Temp 24.6°C | Humedad 48% | Sensores OK.');
      return;
    }

    if (accion == 'EXPO_BIOMETRIA_HUELLA') {
      HapticFeedback.heavyImpact();
      setState(() => _feedback = '👆 BIOMETRÍA VERIFICADA: Bóveda Orbe desbloqueada.');
      return;
    }

    if (accion == 'ENVIAR_SOS_GPS') {
      HapticFeedback.vibrate();
      setState(() => _feedback = '🚨 ALERTA S.O.S. SATELITAL ENVIADA (Lat: -17.9647, Lng: -67.1060 - Oruro)');
      return;
    }

    if (accion == 'EXPORTAR_PDF_CONTABILIDAD') {
      final filas = (bloquePadre['items_lista'] as List?)?.map((e) => e.toString()).toList() ?? ['Reporte Oficial Orbe Imperio'];
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF0A0A1C),
          title: Text(btn['titulo_pdf']?.toString() ?? '📄 Reporte Oficial PDF', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 15, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: filas.map((f) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 12)))).toList(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CERRAR', style: TextStyle(color: Color(0xFF00F3FF)))),
          ],
        ),
      );
      return;
    }

    if (accion == 'ABRIR_ESCANER_FLUTTER') {
      setState(() => _feedback = '📷 Escáner Óptico QR Activo: Apunta al código QR del cliente.');
      return;
    }

    setState(() => _feedback = '⏳ Procesando en Supabase (Esquema 3)...');
    final Map paquete = {
      ...Map.from((btn['parametros_fijos'] as Map?) ?? {}),
      ..._estadoForm,
    };
    final r = await ejecutarRpcUniversal('procesar_evento_sdui', {'p_payload': paquete});
    setState(() => _feedback = r['mensaje']?.toString() ?? '✅ Operación completada');
    await sincronizarContratoSdui();
  }

  IconData _resolverIconoOrbe(String nombre) {
    switch (nombre.toLowerCase()) {
      case 'gift': return Icons.card_giftcard;
      case 'favorite': return Icons.favorite;
      case 'refresh': return Icons.refresh;
      case 'gamepad': return Icons.sports_esports;
      case 'school': return Icons.school;
      case 'wallet': return Icons.account_balance_wallet;
      case 'store': return Icons.storefront;
      case 'book': return Icons.menu_book;
      case 'music': return Icons.music_note;
      case 'videocam': return Icons.videocam;
      case 'rocket': return Icons.rocket_launch;
      case 'movie': return Icons.movie_filter;
      case 'library': return Icons.local_library;
      case 'bulb': return Icons.lightbulb;
      case 'shield': return Icons.verified_user;
      case 'iot': return Icons.bluetooth_connected;
      case 'crypto': return Icons.currency_bitcoin;
      case 'map': return Icons.map;
      case 'translate': return Icons.record_voice_over;
      default: return Icons.auto_awesome;
    }
  }

  Widget _construirBloqueOrbe(Map b, Map geo, double anchoPantalla) {
    final tipo = b['tipo']?.toString() ?? 'TARJETA_NEON';
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFF00F3FF));
    final bool esTablet = anchoPantalla >= 650;

    if (tipo == 'DRAG_AND_DROP_LISTA') {
      final List itemsOrig = (b['items_lista'] as List?) ?? [
        '1. Bloque Cabecera Imperio (Arrastrar ☰)',
        '2. Bloque Reproductor 4DX / 5D (Arrastrar ☰)',
        '3. Bloque Cuadrícula Ecosistema (Arrastrar ☰)',
        '4. Bloque Radar GPS y Cripto (Arrastrar ☰)'
      ];
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
                setState(() => _feedback = '🖐️ Orden actualizado (${oldIndex + 1} ➔ ${newIndex + 1}) y guardado en BD.');
                await ejecutarRpcUniversal('esq3_rpc_mover_componente_drag_drop', {
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

    if (tipo == 'CHAT_WECHAT_P2P') {
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
                    onChanged: (v) => _estadoForm['p_mensaje_chat'] = v,
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFF00FF66)),
                  icon: const Icon(Icons.send, color: Colors.black, size: 18),
                  onPressed: () => _dispararAccionBoton({'accion': 'EJECUTAR_RPC', 'parametros_fijos': {'p_id_accion': 'CHAT_ENVIAR_MSJ'}}, b),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (tipo == 'LAB_CIENCIAS_MATEMATICAS') {
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
                    onPressed: () => setState(() => _feedback = '🔬 Simulación científica activa: $op'),
                    child: Text(op, style: const TextStyle(color: Colors.white, fontSize: 11)),
                  )).toList(),
            ),
          ],
        ),
      );
    }
    if (tipo == 'HEADER_IMPERIO') {
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

    if (tipo == 'GRID_ICONOS_4_COL') {
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
                onTap: () => _dispararAccionBoton({
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
                          Icon(_resolverIconoOrbe(item['icono']?.toString() ?? ''), color: col, size: 26),
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
                    onPressed: () => setState(() => _feedback = '🥽 Modo Inmersivo Activado: ${m['texto']}'),
                    child: Text(m['texto']?.toString() ?? '', style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ),
        ],
      );
    }

    if (tipo == 'GRID_TARJETAS_2_COL') {
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
                onTap: () => setState(() => _feedback = '🎬 Abriendo: ${it['titulo']} (${it['precio']})'),
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

    if (tipo == 'VISOR_AR_VR_360') {
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
              onHorizontalDragUpdate: (d) => setState(() => _offsetVrX = (_offsetVrX + d.delta.dx).clamp(-80.0, 80.0)),
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF00F3FF), width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: _modoRealidad == 'VR'
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
                                      left: _offsetVrX - 40,
                                      right: -_offsetVrX - 40,
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
                  style: ElevatedButton.styleFrom(backgroundColor: _modoRealidad == 'AR' ? const Color(0xFF00FF66) : const Color(0xFF1E293B)),
                  onPressed: () => setState(() => _modoRealidad = 'AR'),
                  child: Text('🔮 CINE AR (LÁSER)', style: TextStyle(color: _modoRealidad == 'AR' ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _modoRealidad == 'VR' ? const Color(0xFF00F3FF) : const Color(0xFF1E293B)),
                  onPressed: () => setState(() => _modoRealidad = 'VR'),
                  child: Text('🥽 LENTES VR 360', style: TextStyle(color: _modoRealidad == 'VR' ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF00FC)),
                  onPressed: () => _dispararAccionBoton({'accion': 'DESCARGAR_VIDEO_OFFLINE'}, b),
                  child: const Text('📥 GUARDAR OFFLINE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (tipo == 'UBER_MAPA_RADAR_GPS') {
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
            Text(b['titulo']?.toString() ?? '🗺️ RADAR GPS EN VIVO (ESTILO UBER / PARENTAL)', style: TextStyle(color: colorBorde, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Text(b['subtitulo']?.toString() ?? 'Ubicación satelital en tiempo real (Oruro, Bolivia - Pellizca para Zoom):', style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 10),
            Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF030B17),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorBorde),
              ),
              clipBehavior: Clip.antiAlias,
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Stack(
                  children: [
                    Positioned.fill(child: CustomPaint(painter: _PintorRadarSatelitalOruro())),
                    const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: Color(0xFFFF0055), size: 38),
                          Text('📍 PARQUE DE LA UNIÓN (ORURO)', style: TextStyle(color: Color(0xFF00FF66), fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.black87)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (tipo == 'BINANCE_CRIPTO_TRADING') {
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(b['titulo']?.toString() ?? '📈 MERCADO MTO / BITCOIN / USDT (ESTILO BINANCE)', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(b['subtitulo']?.toString() ?? '1 USD = 100 MTO | 1 USD = 6.86 Bs | Variación 24h: +14.8%', style: const TextStyle(color: Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              height: 170,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: CustomPaint(painter: _PintorGraficoBinance()),
            ),
          ],
        ),
      );
    }

    if (tipo == 'PIZARRA_TACTIL_SVG' || tipo == 'PIZARRA_TACTIL_DIBUJO') {
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
            Text(b['titulo']?.toString() ?? '✍️ PIZARRA TÁCTIL NEÓN (DIBUJA CON EL DEDO)', style: TextStyle(color: colorBorde, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Color(0xFF00FF66),
                    const Color(0xFF00F3FF),
                    const Color(0xFFFF00FC),
                    const Color(0xFFFFD700),
                  ].map((col) => GestureDetector(
                        onTap: () => setState(() => _colorLapizActual = col),
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: col,
                            shape: BoxShape.circle,
                            border: Border.all(color: _colorLapizActual == col ? Colors.white : Colors.transparent, width: 2.5),
                          ),
                        ),
                      )).toList(),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _trazosPizarra.clear()),
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                  label: const Text('LIMPIAR', style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onPanStart: (d) => setState(() => _trazosPizarra.add([d.localPosition])),
              onPanUpdate: (d) => setState(() => (_trazosPizarra.last as List).add(d.localPosition)),
              child: Container(
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF020617),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: CustomPaint(painter: _PintorPizarraNeon(_trazosPizarra, _colorLapizActual)),
              ),
            ),
          ],
        ),
      );
    }

    final List chips = (b['selector_chips'] as List?) ?? [];
    final List inputs = (b['campos_input'] as List?) ?? [];
    final List lista = (b['items_lista'] as List?) ?? [];
    final List botones = (b['botones'] as List?) ?? [];
    final List opcionesKahoot = (b['opciones_kahoot'] as List?) ?? [];

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
              style: TextStyle(color: colorBorde, fontSize: 15, fontWeight: FontWeight.bold, shadows: [Shadow(color: colorBorde, blurRadius: 8)]),
            ),
          if (b['subtitulo'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: Text(b['subtitulo'].toString(), style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
            ),

          if (tipo == 'LIENZO_WEBAR_HTML5')
            Container(
              height: 270,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00F3FF), width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      _episodioCineActual == 0
                          ? 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&q=80'
                          : 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: const Color(0xFF050A14)),
                    ),
                  ),
                  const Positioned(
                    top: 10,
                    left: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ORBE IMPERIO', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w900, fontSize: 15)),
                        Text('NETFLIX / TIKTOK / C-DRAMA 4DX', style: TextStyle(color: Colors.white70, fontSize: 8)),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () => _dispararAccionBoton({'accion': 'DESCARGAR_VIDEO_OFFLINE'}, b),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0096FF).withAlpha(102),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF00FF66)),
                        ),
                        child: const Text('📥 OFFLINE / VR 360', style: TextStyle(color: Color(0xFF00FF66), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    width: 68,
                    child: Container(
                      padding: const EdgeInsets.only(top: 52),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0096FF).withAlpha(102),
                        border: const Border(right: BorderSide(color: Color(0xFF00F3FF))),
                      ),
                      child: Column(
                        children: [0, 1, 2].map((epIdx) {
                          final activo = _episodioCineActual == epIdx;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _episodioCineActual = epIdx;
                                  _feedback = '🎬 Reproduciendo Ep. ${epIdx + 1} en Cristal Orbe TV';
                                });
                              },
                              child: Container(
                                width: 54,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: activo ? const Color(0xFF00F3FF).withAlpha(110) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: activo ? const Color(0xFF00F3FF) : Colors.white24),
                                ),
                                child: Text(
                                  'Ep. ${epIdx + 1}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: activo ? const Color(0xFF00F3FF) : Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0096FF).withAlpha(110),
                        border: const Border(top: BorderSide(color: Color(0xFF00F3FF))),
                      ),
                      child: Text(
                        'Nuera del Billonario · Ep. ${_episodioCineActual + 1} (⏳ Bóveda VIP: Quedan 7 Días)',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (tipo == 'CARNET_QR_ACTIVO')
            Center(
              child: Column(
                children: [
                  Text(b['valor_qr_defecto']?.toString() ?? 'ORBE-QR', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold)),
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
                      child: CustomPaint(painter: _PintorMatrizQrOptico(b['valor_qr_defecto']?.toString() ?? 'ORBE-QR')),
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
                    errorBuilder: (_, __, ___) => Container(height: 120, color: Colors.black54, child: const Center(child: Icon(Icons.image, color: Colors.white54))),
                  ),
                ),
              ),
            ),

          if (tipo == 'MOTOR_JUEGO_COGNITIVO' && opcionesKahoot.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b['pregunta']?.toString() ?? '', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
                        style: ElevatedButton.styleFrom(backgroundColor: col, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          final ok = m['correcta'] == true;
                          HapticFeedback.heavyImpact();
                          setState(() => _feedback = ok ? '🏆 ¡KAHOOT CORRECTO! (+10 Ptos MTO)' : '⚠️ Respuesta incorrecta');
                        },
                        child: Text(m['texto']?.toString() ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                const Text('🧠 ENTRENAMIENTO CEREBRAL LUMOSITY (MEMORIA ESPACIAL 3x3):', style: TextStyle(color: Color(0xFF00F3FF), fontSize: 12, fontWeight: FontWeight.bold)),
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
                    final activa = _celdasLumosity.contains(cellIdx);
                    return InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          if (activa) {
                            _celdasLumosity.remove(cellIdx);
                          } else {
                            _celdasLumosity.add(cellIdx);
                          }
                          if (_celdasLumosity.length == 5) {
                            _feedback = '⚡ ¡PATRÓN LUMOSITY COMPLETADO! Velocidad cognitiva +25 XP';
                          }
                        });
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
                            style: TextStyle(color: activa ? Colors.black : Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
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
                        title: const Text('🤖 Arduino / ESP32 LED Pin 13 (Bluetooth/Wi-Fi)', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        value: _arduinoLed1,
                        activeColor: const Color(0xFF00FF66),
                        onChanged: (v) => setState(() {
                          _arduinoLed1 = v;
                          _feedback = v ? '🔵 Arduino Pin 13 ENCENDIDO (HIGH)' : '⚪ Arduino Pin 13 APAGADO (LOW)';
                        }),
                      ),
                      SwitchListTile(
                        dense: true,
                        title: const Text('⚡ Relé IoT MQTT Bomba / Motor SmartHome', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        value: _arduinoRele2,
                        activeColor: const Color(0xFFFF00FC),
                        onChanged: (v) => setState(() {
                          _arduinoRele2 = v;
                          _feedback = v ? '📡 Relé IoT MQTT ACTIVADO' : '📡 Relé IoT MQTT DESACTIVADO';
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
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
                  final activo = _estadoForm[campo] == txt;
                  return ChoiceChip(
                    label: Text(txt, style: TextStyle(color: activo ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    selected: activo,
                    selectedColor: colorBorde,
                    backgroundColor: const Color(0xFF111111),
                    onSelected: (_) => setState(() => _estadoForm[campo] = txt),
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
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colorBorde)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colorBorde, width: 2)),
                ),
                onChanged: (v) => _estadoForm[campo] = v,
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
                child: Text(item.toString(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
                        side: m['color_borde_btn'] != null ? BorderSide(color: hexAColor(m['color_borde_btn'].toString())) : BorderSide.none,
                      ),
                    ),
                    onPressed: () => _dispararAccionBoton(m, b),
                    child: Text(m['texto']?.toString() ?? '', textAlign: TextAlign.center, style: TextStyle(color: colTxt, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final geo = Map.from((_contrato['geometria'] as Map?) ?? {});
    final listaPestanas = ((_contrato['pestanas'] as List?) ?? []).where((p) {
      final mp = Map.from(p as Map);
      if (mp['visible'] == false) return false;
      if (mp['rol_permitido'] == 'superadmin' && !_esAdmin) return false;
      return true;
    }).toList();

    final pantallasMap = Map.from((_contrato['pantallas_json'] as Map?) ?? {});

    return Scaffold(
      backgroundColor: hexAColor(geo['color_fondo']?.toString(), const Color(0xFF05050F)),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          final double anchoUtil = math.max(300.0, constraints.maxWidth);
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: (geo['margen_arriba'] as num?)?.toDouble() ?? 34,
                  bottom: (geo['margen_abajo'] as num?)?.toDouble() ?? 48,
                  left: (geo['margen_izquierda'] as num?)?.toDouble() ?? 0,
                  right: (geo['margen_derecha'] as num?)?.toDouble() ?? 0,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      color: const Color(0xFF05050F),
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(listaPestanas.length, (idx) {
                                  final p = Map.from(listaPestanas[idx] as Map);
                                  final activa = _indicePagina == idx;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() => _indicePagina = idx);
                                        _pageCtrl.animateToPage(idx, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: activa ? const Color(0xFF00F3FF) : const Color(0xFF0A0A1C),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: activa ? Colors.white : const Color(0xFF1E293B)),
                                        ),
                                        child: Text(
                                          p['titulo']?.toString() ?? p['id'].toString(),
                                          style: TextStyle(color: activa ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          if (_esAdmin)
                            InkWell(
                              onTap: _abrirModalEditorJson,
                              child: Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(14)),
                                child: const Text('{ } JSON', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w900)),
                              ),
                            ),
                        ],
                      ),
                    ),

                    if (_feedback.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0A1C),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF00FF66)),
                        ),
                        child: Text(_feedback, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold, fontSize: 12)),
                      ),

                    Expanded(
                      child: PageView.builder(
                        controller: _pageCtrl,
                        itemCount: listaPestanas.length,
                        onPageChanged: (idx) => setState(() => _indicePagina = idx),
                        itemBuilder: (ctx, idx) {
                          final p = Map.from(listaPestanas[idx] as Map);
                          final bloques = (pantallasMap[p['id']] as List?) ?? [];
                          return ListView(
                            padding: const EdgeInsets.all(12),
                            children: bloques
                                .where((b) => (b as Map)['visible'] != false)
                                .map((b) => _construirBloqueOrbe(Map.from(b as Map), geo, anchoUtil))
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _tocarEsquinaCincoVeces,
                  child: const SizedBox(width: 95, height: 75),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PintorPizarraNeon extends CustomPainter {
  final List trazos;
  final Color colorLapiz;
  _PintorPizarraNeon(this.trazos, this.colorLapiz);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorLapiz
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final trazo in trazos) {
      final List pts = trazo as List;
      for (int i = 0; i < pts.length - 1; i++) {
        canvas.drawLine(pts[i] as Offset, pts[i + 1] as Offset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PintorRadarSatelitalOruro extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = const Color(0xFF00F3FF).withAlpha(35)..strokeWidth = 1;
    for (int i = 1; i < 8; i++) {
      canvas.drawLine(Offset(size.width * (i / 8), 0), Offset(size.width * (i / 8), size.height), gridPaint);
      canvas.drawLine(Offset(0, size.height * (i / 8)), Offset(size.width, size.height * (i / 8)), gridPaint);
    }
    final circlePaint = Paint()
      ..color = const Color(0xFF00FF66).withAlpha(65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 32, circlePaint);
    canvas.drawCircle(center, 68, circlePaint);
    canvas.drawCircle(center, 105, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PintorGraficoBinance extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = Colors.white12..strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final pts = [
      Offset(0, size.height * 0.80),
      Offset(size.width * 0.16, size.height * 0.65),
      Offset(size.width * 0.32, size.height * 0.72),
      Offset(size.width * 0.48, size.height * 0.45),
      Offset(size.width * 0.64, size.height * 0.52),
      Offset(size.width * 0.80, size.height * 0.25),
      Offset(size.width, size.height * 0.12),
    ];

    final linePaint = Paint()
      ..color = const Color(0xFF00FF66)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(path, linePaint);

    for (int i = 0; i < pts.length; i++) {
      final alcista = i % 2 == 0;
      final x = pts[i].dx;
      final y = pts[i].dy;
      final wickPaint = Paint()
        ..color = alcista ? const Color(0xFF00FF66) : const Color(0xFFFF0055)
        ..strokeWidth = 1.5;
      final bodyPaint = Paint()
        ..color = alcista ? const Color(0xFF00FF66) : const Color(0xFFFF0055)
        ..style = PaintingStyle.fill;
      canvas.drawLine(Offset(x, y - 14), Offset(x, y + 14), wickPaint);
      canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: 8, height: 14), bodyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PintorMatrizQrOptico extends CustomPainter {
  final String semilla;
  _PintorMatrizQrOptico(this.semilla);

  @override
  void paint(Canvas canvas, Size size) {
    const int n = 21;
    final double celda = size.width / n;
    final paint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    final int hashBase = semilla.codeUnits.fold(0, (a, b) => (a as int) * 31 + (b as int));

    void dibujarEsquina(int fila0, int col0) {
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 7; c++) {
          final borde = r == 0 || r == 6 || c == 0 || c == 6 || (r >= 2 && r <= 4 && c >= 2 && c <= 4);
          if (borde) {
            canvas.drawRect(Rect.fromLTWH((col0 + c) * celda, (fila0 + r) * celda, celda, celda), paint);
          }
        }
      }
    }

    dibujarEsquina(0, 0);
    dibujarEsquina(0, n - 7);
    dibujarEsquina(n - 7, 0);

    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        if ((r < 8 && c < 8) || (r < 8 && c >= n - 8) || (r >= n - 8 && c < 8)) continue;
        final v = ((r * 37 + c * 17 + hashBase) & 3) == 0;
        if (v) {
          canvas.drawRect(Rect.fromLTWH(c * celda, r * celda, celda, celda), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}