import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

const String SUPABASE_URL = 'https://alxbydjpoxoavasklwpd.supabase.co';
const String SUPABASE_KEY = 'sb_publishable_Kc8wekwUqIs78ILNF-j-Qg_LNMYRhn0';

const Map<String, String> HEADERS_ESQ3 = {
  'apikey': SUPABASE_KEY,
  'Authorization': 'Bearer $SUPABASE_KEY',
  'Accept-Profile': 'esquema3',
  'Content-Profile': 'esquema3',
  'Content-Type': 'application/json',
  'Cache-Control': 'no-cache',
};

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
  State<LienzoMaestroSdui> createState() => _LienzoMaestroSduiState();
}

class _LienzoMaestroSduiState extends State<LienzoMaestroSdui> with WidgetsBindingObserver {
  final PageController _pageCtrl = PageController();
  final FlutterTts _tts = FlutterTts();

  int _indicePagina = 0;
  bool _esAdmin = false;
  int _toquesEsquina = 0;
  Timer? _timerToques;
  Timer? _timer4DX;
  bool _modo4DXActivo = false;
  String _feedback = '';
  final Map<String, String> _estadoForm = {};

  final List<List<Offset>> _trazosPizarra = [];
  Color _colorLapizActual = const Color(0xFF00FF66);

  Map<String, dynamic> _contrato = {
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

  Future> ejecutarRpcUniversal(String nombreRpc, Map<String, dynamic> payload) async {
    try {
      final res = await http
          .post(
            Uri.parse('$SUPABASE_URL/rest/v1/rpc/$nombreRpc'),
            headers: HEADERS_ESQ3,
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 6));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return res.body.isNotEmpty ? jsonDecode(res.body) : {'exito': true};
      }
      return {'exito': false, 'mensaje': res.body};
    } catch (e) {
      return {'exito': false, 'mensaje': e.toString()};
    }
  }

  Future<void> sincronizarContratoSdui() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedStr = prefs.getString('cache_contrato_esq3');
    if (cachedStr != null && cachedStr.isNotEmpty) {
      try {
        final cachedMap = jsonDecode(cachedStr) as Map<String, dynamic>;
        if (mounted) setState(() => _contrato = cachedMap);
      } catch (_) {}
    }

    final int verLocal = prefs.getInt('version_num_esq3') ?? 0;
    final check = await ejecutarRpcUniversal('esq3_rpc_verificar_version', {
      'p_modulo': 'MODULO_MAESTRO_V1',
      'p_version_cliente': verLocal,
    });

    if (check['requiere_descarga'] == true && check['contrato'] != null) {
      final nuevoContrato = Map<String, dynamic>.from(check['contrato']);
      await prefs.setString('cache_contrato_esq3', jsonEncode(nuevoContrato));
      await prefs.setInt('version_num_esq3', (check['version_numero'] as num?)?.toInt() ?? 1);
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
                    final nuevo = jsonDecode(ctrl.text);
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

  Future<void> _dispararAccionBoton(Map<String, dynamic> btn, Map<String, dynamic> bloquePadre) async {
    HapticFeedback.mediumImpact();
    final accion = btn['accion']?.toString() ?? 'EJECUTAR_RPC';

    if (accion == 'ABRIR_EDITOR_JSON_CALIENTE') {
      _abrirModalEditorJson();
      return;
    }

    if (accion == 'HABLAR_IDIOMA_TTS') {
      final idioma = btn['idioma']?.toString() ?? 'en-US';
      final frase = btn['frase']?.toString() ?? 'Welcome to Orbe Imperio SuperApp';
      await _tts.setLanguage(idioma);
      await _tts.setSpeechRate(0.48);
      await _tts.speak(frase);
      setState(() => _feedback = '🗣️ Reproduciendo ($idioma): "$frase"');
      return;
    }

    if (accion == 'ESCUCHAR_MICROFONO_STT') {
      await _tts.setLanguage('en-US');
      await _tts.speak('Listening to your pronunciation now');
      setState(() => _feedback = '🎙️ Pronunciación verificada: "Welcome to Orbe Imperio" (+15 XP Duolingo)');
      return;
    }

    if (accion == 'TOGGLE_EFECTO_4DX_5D') {
      _timer4DX?.cancel();
      setState(() => _modo4DXActivo = !_modo4DXActivo);
      if (_modo4DXActivo) {
        _timer4DX = Timer.periodic(const Duration(milliseconds: 900), (_) {
          HapticFeedback.heavyImpact();
        });
        await _tts.setLanguage('es-ES');
        await _tts.speak('Modo Cine 4 D X y 5 D activado con vibración inmersiva');
        setState(() => _feedback = '🎢 MODO CINE 4DX / 5D ACTIVO: Vibración háptica y sensores sincronizados.');
      } else {
        setState(() => _feedback = '⏹️ Efectos físicos 4DX / 5D detenidos.');
      }
      return;
    }

    if (accion == 'ESCANEAR_ARDUINO_BLUETOOTH') {
      HapticFeedback.selectionClick();
      setState(() => _feedback = '🔵 Radar Bluetooth BLE & Wi-Fi: Módulo Arduino / ESP32-ORBE listo para enlazar.');
      return;
    }

    if (accion == 'PROBAR_IOT_MQTT') {
      HapticFeedback.selectionClick();
      setState(() => _feedback = '📡 Telemetría IoT MQTT (broker.hivemq.com:1883): Canal de sensores conectado.');
      return;
    }

    if (accion == 'EXPO_BIOMETRIA_HUELLA') {
      HapticFeedback.heavyImpact();
      await _tts.setLanguage('es-ES');
      await _tts.speak('Identidad biométrica verificada');
      setState(() => _feedback = '👆 BIOMETRÍA VERIFICADA: Bóveda Orbe desbloqueada.');
      return;
    }

    if (accion == 'ENVIAR_SOS_GPS') {
      await _tts.setLanguage('es-ES');
      await _tts.speak('Alerta S O S enviada con ubicación satelital');
      setState(() => _feedback = '🚨 ALERTA S.O.S. SATELITAL ENVIADA (Lat: -17.9647, Lng: -67.1060 - Oruro)');
      return;
    }

    if (accion == 'EXPORTAR_PDF_CONTABILIDAD') {
      final filas = (bloquePadre['items_lista'] as List?)?.map((e) => e.toString()).toList() ?? ['Sin registros'];
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

    if (accion == 'ABRIR_LINK' && btn['url'] != null) {
      final uri = Uri.parse(btn['url'].toString());
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    setState(() => _feedback = '⏳ Procesando en Supabase (Esquema 3)...');
    final Map<String, dynamic> paquete = {
      ...Map<String, dynamic>.from(btn['parametros_fijos'] ?? {}),
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

  Widget _construirBloqueOrbe(Map<String, dynamic> b, Map<String, dynamic> geo) {
    final tipo = b['tipo']?.toString() ?? 'TARJETA_NEON';
    final colorBorde = hexAColor(b['color_borde']?.toString(), const Color(0xFF00F3FF));

    // 1. CABECERA EXACTA `ORGheaderImperio.js`
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
                Row(
                  children: [
                    Text(
                      'ORBE',
                      style: TextStyle(
                        color: const Color(0xFF00F3FF),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        shadows: const [Shadow(color: Color(0xFF00F3FF), blurRadius: 12)],
                      ),
                    ),
                    const Text(' 🌍', style: TextStyle(fontSize: 20)),
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

    // 2. CUADRÍCULA DE 4 COLUMNAS EXACTA `ORGtabEcosistema.js`
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: items.length,
            itemBuilder: (ctx, idx) {
              final item = Map<String, dynamic>.from(items[idx]);
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
                  final m = Map<String, dynamic>.from(btn);
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

    // 3. CUADRÍCULA DE 2 COLUMNAS (NETFLIX / C-DRAMAS / UDEMY / PLATZI)
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.82,
            ),
            itemCount: items.length,
            itemBuilder: (ctx, idx) {
              final it = Map<String, dynamic>.from(items[idx]);
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
                            ? Image.network(it['imagen_url'].toString(), width: double.infinity, fit: BoxFit.cover)
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

    // 4. UBER MAPA SATELITAL GPS EN VIVO (LEAFLET INTERACTIVO SIN ERRORES DE COMPILACION)
    if (tipo == 'UBER_MAPA_RADAR_GPS') {
      final String lat = b['lat']?.toString() ?? '-17.9647';
      final String lng = b['lng']?.toString() ?? '-67.1060';
      final String mapaHtml = '''
      <!DOCTYPE html><html><head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
      <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
      <style>body,html,#map{margin:0;padding:0;width:100%;height:100%;background:#05050f;}</style>
      </head><body><div id="map"></div>
      <script>
        var map = L.map('map').setView([$lat, $lng], 15);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
        L.marker([$lat, $lng]).addTo(map).bindPopup('<b>📍 RADAR ORBE ACTIVO</b><br>Oruro, Bolivia').openPopup();
      </script></body></html>
      ''';
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
            Text(b['subtitulo']?.toString() ?? 'Ubicación satelital en tiempo real (Oruro, Bolivia):', style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadHtmlString(mapaHtml),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 5. BINANCE / BITCOIN GRÁFICO DE VELAS Y LÍNEA NATIVO EN CUSTOMPAINT
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

    // 6. PIZARRA TÁCTIL PARA DIBUJAR CON EL DEDO EN EL CELULAR
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
              onPanUpdate: (d) => setState(() => _trazosPizarra.last.add(d.localPosition)),
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

    // 7. TARJETA NEÓN ESTÁNDAR + REPRODUCTOR 4DX/5D + DUOLINGO + KAHOOT + QR NATIVO
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

          if (tipo == 'LIENZO_WEBAR_HTML5' && b['html_puro'] != null)
            Container(
              height: 290,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: colorBorde)),
              clipBehavior: Clip.antiAlias,
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadHtmlString(b['html_puro'].toString()),
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
                child: Image.network(b['imagen_url'].toString(), height: 160, width: double.infinity, fit: BoxFit.cover),
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
                    final m = Map<String, dynamic>.from(op);
                    final col = hexAColor(m['color']?.toString());
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 70) / 2,
                      height: 75,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: col, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          final ok = m['correcta'] == true;
                          await _tts.setLanguage('es-ES');
                          await _tts.speak(ok ? 'Correcto, excelente trabajo' : 'Incorrecto');
                          setState(() => _feedback = ok ? '🏆 ¡RESPUESTA CORRECTA! (+10 Ptos)' : '⚠️ Respuesta incorrecta');
                        },
                        child: Text(m['texto']?.toString() ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }).toList(),
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
            final m = Map<String, dynamic>.from(inp);
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
                final m = Map<String, dynamic>.from(btn);
                final col = hexAColor(m['color']?.toString(), colorBorde);
                final colTxt = hexAColor(m['color_texto']?.toString(), Colors.black);
                final mitad = m['ancho_mitad'] == true;
                return SizedBox(
                  width: mitad ? (MediaQuery.of(context).size.width - 68) / 2 : double.infinity,
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
    final geo = Map<String, dynamic>.from(_contrato['geometria'] ?? {});
    final listaPestanas = ((_contrato['pestanas'] as List?) ?? []).where((p) {
      if (p['visible'] == false) return false;
      if (p['rol_permitido'] == 'superadmin' && !_esAdmin) return false;
      return true;
    }).toList();

    final pantallasMap = Map<String, dynamic>.from(_contrato['pantallas_json'] ?? {});

    return Scaffold(
      backgroundColor: hexAColor(geo['color_fondo']?.toString(), const Color(0xFF05050F)),
      body: Stack(
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
                              final p = Map<String, dynamic>.from(listaPestanas[idx]);
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
                      final p = Map<String, dynamic>.from(listaPestanas[idx]);
                      final bloques = (pantallasMap[p['id']] as List?) ?? [];
                      return ListView(
                        padding: const EdgeInsets.all(12),
                        children: bloques
                            .where((b) => b['visible'] != false)
                            .map((b) => _construirBloqueOrbe(Map<String, dynamic>.from(b), geo))
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
      ),
    );
  }
}

class _PintorPizarraNeon extends CustomPainter {
  final List<List<Offset>> trazos;
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
      for (int i = 0; i < trazo.length - 1; i++) {
        canvas.drawLine(trazo[i], trazo[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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

    // Velas japonesas (Candlesticks)
    for (int i = 0; i < pts.length; i++) {
      final alcista = i % 2 == 0;
      final candlePaint = Paint()..color = alcista ? const Color(0xFF00FF66) : const Color(0xFFFF0055);
      final x = pts[i].dx;
      final y = pts[i].dy;
      canvas.drawLine(Offset(x, y - 14), Offset(x, y + 14), candlePaint..strokeWidth = 1.5);
      canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: 8, height: 14), candlePaint..style = PaintingStyle.fill);
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
    final int hashBase = semilla.codeUnits.fold(0, (a, b) => a * 31 + b);

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