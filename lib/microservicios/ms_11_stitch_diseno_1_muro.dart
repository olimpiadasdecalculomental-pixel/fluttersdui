import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/escudo_aislamiento.dart';
import '../nucleo/puente_supabase_sdui.dart';
import '../nucleo/inspector_stitch.dart';
import 'ms_12_stitch_ganadores_y_boveda.dart';
import 'ms_13_stitch_socio_y_auditoria.dart';

class Ms11StitchDiseno1Muro extends StatefulWidget {
  final Map bloque;
  const Ms11StitchDiseno1Muro({super.key, required this.bloque});

  @override
  State createState() => _Ms11StitchDiseno1MuroState();
}

class _Ms11StitchDiseno1MuroState extends State with SingleTickerProviderStateMixin {
  late AnimationController _vinylCtrl;
  Timer? _timerSegundos;
  Timer? _timerTumbler;
  final math.Random _rng = math.Random();

  int _navIndex = 0; // 0=Muro, 1=Ganadores, 2=Boveda, 3=Aportes/Auditoria, 4=Zona Socio
  bool _modoStitchEdit = false;

  bool _isLiked = false;
  bool _isFollowed = false;
  bool _showDiceModal = false;
  bool _showAnonTooltip = false;
  bool _spinningDice = false;
  int _diceValue = 6;

  int _hrs = 5;
  int _min = 42;
  int _seg = 18;
  List _digitosEsfera = [8, 3, 9, 5];

  String _intervaloPin = '6 Horas';
  int _segQr = 45;
  String _codigoQr = 'SJ-8821-QR';
  bool _bovedaBlindada = false;
  bool _showBlindarModal = false;

  String _rolAuditoria = 'admin';
  int _stockPoleras = 14;
  String _tokenDetectado = 'Token #SJ-9942 - Socio Pleno';
  int _dadoProb = 1;
  bool _reglaDual = true;

  String _tabSocio = 'parlamento';
  String _votoSeleccionado = 'favor';
  bool _votoEmitido = false;
  bool _ticketExtraReclamado = false;

  String _toastMsg = '';

  final Map _ordenPorPestana = {
    'muro': ['muro_hud', 'muro_video', 'muro_dado'],
    'ganadores': ['gan_reloj', 'gan_premio', 'gan_esfera', 'gan_cta', 'gan_top10', 'gan_sponsors'],
    'boveda': ['bov_alerta', 'bov_saldos', 'bov_timer', 'bov_qr', 'bov_cupones'],
    'aportes': ['aud_switch', 'aud_sync', 'aud_escaner', 'aud_tribunal', 'aud_gestor'],
    'socio': ['soc_hero', 'soc_tabs', 'soc_parlamento', 'soc_credencial', 'soc_aportes', 'soc_sorteos'],
  };

  final Map _customSecciones = {};

  static const Map _nombresSeccion = {
    'muro_hud': 'HUD Lanzamiento Activo + El Mirón',
    'muro_video': 'Video 9:16 En Vivo Bermúdez + Riel TikTok',
    'muro_dado': 'Centro Tirar Dado Santo (1 al 6)',
    'gan_reloj': 'Reloj Sorteo Automatizado 06:00 AM',
    'gan_premio': 'Premio Estrella Camiseta Autografiada',
    'gan_esfera': 'Esfera Cuántica en Vivo (4,120 números)',
    'gan_cta': 'Tarjeta ¿Cómo entrar a la tómbola?',
    'gan_top10': 'Lista Top 10 Ganadores de Hoy',
    'gan_sponsors': 'Mosaico Franquicias Aliadas',
    'bov_alerta': 'Alerta Protocolo de Resguardo PIN',
    'bov_saldos': 'Tarjetas Billetera Santa (480 pts) y PIN',
    'bov_timer': 'Selector Frecuencia de Bloqueo PIN',
    'bov_qr': 'Tarjeta VIP Holográfica QR (Polera 2025)',
    'bov_cupones': 'Lista Mis Cupones Diarios (3 Activos)',
    'aud_switch': 'Selector Admin Central vs Tienda Aliada',
    'aud_sync': 'Banner Nodo Oruro Central En Línea',
    'aud_escaner': 'Módulo 1: Escáner de Entrega de Premios',
    'aud_tribunal': 'Módulo 2: Tribunal de Comprobantes (2 Col)',
    'aud_gestor': 'Módulo 3: Gestor Paramétrico (270/70 BS)',
    'soc_hero': 'Banner Héroe Socio Vitalicio #1942',
    'soc_tabs': 'Pestañas Parlamento / Credencial / Sorteos',
    'soc_parlamento': 'Parlamento Santo (+51% Quórum)',
    'soc_credencial': 'Credencial Digital Holográfica + QR',
    'soc_aportes': 'Estado de Cuenta & Aportes (Al Día)',
    'soc_sorteos': 'Sorteo Exclusivo Camiseta Firmada',
  };

  static const Color cSurface = Color(0xFF071326);
  static const Color cSurfaceLowest = Color(0xFF030E21);
  static const Color cSurfaceContainer = Color(0xFF142033);
  static const Color cSurfaceHigh = Color(0xFF1F2A3E);
  static const Color cSurfaceHighest = Color(0xFF2A3549);
  static const Color cSurfaceBright = Color(0xFF2E394E);
  static const Color cOnSurface = Color(0xFFD7E3FD);
  static const Color cOnSurfaceVariant = Color(0xFFC2C6D3);
  static const Color cOutline = Color(0xFF8C919C);
  static const Color cPrimary = Color(0xFFA9C7FF);
  static const Color cPrimaryContainer = Color(0xFF00509D);
  static const Color cOnPrimaryContainer = Color(0xFFA4C5FF);
  static const Color cSecondary = Color(0xFFFFD795);
  static const Color cSecondaryContainer = Color(0xFFFBB400);
  static const Color cOnSecondaryContainer = Color(0xFF694900);
  static const Color cSecondaryFixed = Color(0xFFFFDEA9);
  static const Color cTertiary = Color(0xFFA7C8FF);
  static const Color cTertiaryContainer = Color(0xFF295186);
  static const Color cOnTertiaryContainer = Color(0xFFA1C5FF);
  static const Color cError = Color(0xFFFFB4AB);

  @override
  void initState() {
    super.initState();
    _cargarConfigInicialDesdeBloque();
    _vinylCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

    _timerSegundos = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_seg > 0) {
          _seg--;
        } else {
          _seg = 59;
          if (_min > 0) {
            _min--;
          } else {
            _min = 59;
            _hrs = _hrs > 0 ? _hrs - 1 : 23;
          }
        }
        _segQr--;
        if (_segQr <= 0) {
          _segQr = 60;
          _codigoQr = 'SJ-${1000 + _rng.nextInt(9000)}-QR';
        }
      });
    });

    _timerTumbler = Timer.periodic(const Duration(milliseconds: 220), (_) {
      if (!mounted || _navIndex != 1) return;
      setState(() {
        _digitosEsfera = [_rng.nextInt(10), _rng.nextInt(10), _rng.nextInt(10), _rng.nextInt(10)];
      });
    });
  }

  void _cargarConfigInicialDesdeBloque() {
    final Map b = (widget as Ms11StitchDiseno1Muro).bloque;
    if (b['custom_secciones'] is Map) {
      final Map cs = Map.from(b['custom_secciones'] as Map);
      cs.forEach((k, v) {
        if (v is Map) _customSecciones[k.toString()] = Map.from(v);
      });
    }
    if (b['orden_secciones'] is Map) {
      final Map os = Map.from(b['orden_secciones'] as Map);
      os.forEach((k, v) {
        if (v is List) _ordenPorPestana[k.toString()] = v.map((e) => e.toString()).toList();
      });
    }
  }

  @override
  void dispose() {
    _vinylCtrl.dispose();
    _timerSegundos?.cancel();
    _timerTumbler?.cancel();
    super.dispose();
  }

  void _mostrarToast(String msg) {
    HapticFeedback.selectionClick();
    setState(() => _toastMsg = msg);
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted && _toastMsg == msg) setState(() => _toastMsg = '');
    });
  }

  Future _sincronizarEdicionConSupabase() async {
    final Map b = Map.from((widget as Ms11StitchDiseno1Muro).bloque);
    b['custom_secciones'] = _customSecciones;
    b['orden_secciones'] = _ordenPorPestana;

    final Map contratoNuevo = {
      'geometria': {
        'modo_clon_stitch_puro': true,
        'color_fondo': '#071326',
        'color_tarjeta': '#142033',
        'color_primario': '#A9C7FF',
        'color_secundario': '#FBB400',
        'color_terciario': '#00509D',
        'margen_arriba': 0,
        'margen_abajo': 0,
        'margen_izquierda': 0,
        'margen_derecha': 0,
      },
      'pestanas': [
        {'id': 'RAIZ', 'titulo': 'Muro', 'visible': true}
      ],
      'pantallas_json': {
        'RAIZ': [b]
      }
    };

    await PuenteSupabaseSdui.ejecutarRpcUniversal('esq3_rpc_actualizar_sdui', {
      'p_modulo': 'MODULO_MAESTRO_V1',
      'p_nuevo_json': contratoNuevo,
    });
    _mostrarToast('💾 Cambios de Stitch Studio guardados en Supabase');
  }

  void _lanzarDadoStitch() {
    HapticFeedback.mediumImpact();
    setState(() => _spinningDice = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _spinningDice = false;
        _diceValue = _rng.nextInt(6) + 1;
        _showDiceModal = true;
      });
      HapticFeedback.heavyImpact();
    });
  }

  String _clavePestanaActual() {
    switch (_navIndex) {
      case 0: return 'muro';
      case 1: return 'ganadores';
      case 2: return 'boveda';
      case 3: return 'aportes';
      default: return 'socio';
    }
  }

  void _restaurarPestanaActual() {
    final String k = _clavePestanaActual();
    final Map originales = {
      'muro': ['muro_hud', 'muro_video', 'muro_dado'],
      'ganadores': ['gan_reloj', 'gan_premio', 'gan_esfera', 'gan_cta', 'gan_top10', 'gan_sponsors'],
      'boveda': ['bov_alerta', 'bov_saldos', 'bov_timer', 'bov_qr', 'bov_cupones'],
      'aportes': ['aud_switch', 'aud_sync', 'aud_escaner', 'aud_tribunal', 'aud_gestor'],
      'socio': ['soc_hero', 'soc_tabs', 'soc_parlamento', 'soc_credencial', 'soc_aportes', 'soc_sorteos'],
    };
    setState(() {
      _ordenPorPestana[k] = List.from(originales[k] as List);
      for (final idSec in (originales[k] as List)) {
        _customSecciones.remove(idSec);
      }
    });
    _sincronizarEdicionConSupabase();
  }

  Widget _construirSeccionMuro(String idSec, Map cfg, Map b) {
    final Color acento = hexAColor(cfg['color_acento_hex']?.toString(), cSecondaryContainer);
    final Color txtCol = hexAColor(cfg['color_texto_hex']?.toString(), cOnSurface);

    if (idSec.startsWith('muro_hud')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: cSurfaceHighest.withAlpha(204),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.casino, color: acento, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    (cfg['titulo']?.toString() ?? b['hud_titulo']?.toString() ?? 'LANZAMIENTO ACTIVO').toUpperCase(),
                                    style: const TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(width: 6, height: 6, decoration: BoxDecoration(color: acento, shape: BoxShape.circle)),
                                ],
                              ),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 12, color: cOnSurfaceVariant),
                                  children: [
                                    TextSpan(
                                      text: cfg['valor_destacado']?.toString() ?? b['hud_pts']?.toString() ?? '+40 pts',
                                      style: const TextStyle(color: cSecondaryFixed, fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(text: ' acumulados • '),
                                    TextSpan(
                                      text: cfg['badge']?.toString() ?? b['hud_device']?.toString() ?? '#89F2A',
                                      style: const TextStyle(color: cOutline),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => _showAnonTooltip = !_showAnonTooltip),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_off_outlined, color: cTertiary, size: 16),
                          const SizedBox(width: 4),
                          Text(cfg['boton_txt']?.toString() ?? 'El Mirón', style: const TextStyle(color: cTertiary, fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (idSec.startsWith('muro_video')) {
      final String videoBgUrl = cfg['imagen_url']?.toString() ??
          b['video_bg_url']?.toString() ??
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAzkbVETd8U6n0rkXQSMlREA8aZEjR18epUA2BD_YO7PAL4VW15ANS8bUKder-D7btF1xcS_yZTr4LyqSgc-LouZ2HOgc9za70VxcrVygqOZTmF-XfzJUF5GUkNafJhnSC0WG9slLpBR1OW7CphxQfZespFPWuHCse5i1eIcWIrPGZuHO0YJzE6jAhOU1biLZdyvjcnbD8qCEqcLKKw7Wa9o0WWVfqKERfhl3RcM8k';
      final String escudoUrl = b['escudo_club_url']?.toString() ??
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAo2s6PA4vlfi1cXQO0XuPKWqXOrLWVSyZCGRyilUjqdxm3_wj6EGnm6V9PFHPT74DjP6uQfbP0AEOKYTLhgtt2Oe9v0dEBRRmmgiRN0WXlZQIp-Bv3iMGsI6cbW4kuRXjuGaKmaOGwGiDBTutUtm-Sp-LjUlbkrr48-LhNb3__6f-K5pz_2scJ7bdu3n_NAOrbDMNJaqqLd31Pvl6bfw9sT54bxGN7wXCap5_h170';

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 580),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    videoBgUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF002855), child: const Icon(Icons.sports_soccer, color: cSecondary, size: 64)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [cSurface, Colors.transparent, cSurface.withAlpha(178)],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(color: cSurfaceLowest.withAlpha(178), borderRadius: BorderRadius.circular(999)),
                          child: Row(
                            children: [
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: cError, shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Text(cfg['badge']?.toString() ?? 'EN VIVO BERMÚDEZ', style: const TextStyle(color: cOnSurface, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: cSurfaceHigh.withAlpha(153), borderRadius: BorderRadius.circular(999)),
                          child: const Row(
                            children: [
                              Icon(Icons.equalizer, color: cSecondary, size: 16),
                              SizedBox(width: 6),
                              Text('AUDIO HISTÓRICO', style: TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 88,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 54,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [cSecondary, cPrimary, cSurface])),
                                child: ClipOval(
                                  child: Image.network(escudoUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: cSecondary)),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () => setState(() => _isFollowed = !_isFollowed),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(color: _isFollowed ? cSurfaceBright : acento, shape: BoxShape.circle),
                                    child: Icon(_isFollowed ? Icons.done : Icons.add, size: 14, color: _isFollowed ? cSecondary : cOnSecondaryContainer),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () => setState(() => _isLiked = !_isLiked),
                          child: Column(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(color: cSurfaceHigh.withAlpha(178), shape: BoxShape.circle),
                                child: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? cError : cOnSurface, size: 26),
                              ),
                              const SizedBox(height: 2),
                              Text(_isLiked ? '14.3k' : (cfg['valor_destacado']?.toString() ?? '14.2k'), style: const TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Column(
                          children: [
                            Container(width: 44, height: 44, decoration: BoxDecoration(color: cSurfaceHigh.withAlpha(178), shape: BoxShape.circle), child: const Icon(Icons.chat_bubble, color: cOnSurface, size: 22)),
                            const SizedBox(height: 2),
                            const Text('842', style: TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Column(
                          children: [
                            Container(width: 44, height: 44, decoration: BoxDecoration(color: cSurfaceHigh.withAlpha(178), shape: BoxShape.circle), child: const Icon(Icons.share, color: cOnSurface, size: 22)),
                            const SizedBox(height: 2),
                            const Text('3.1k', style: TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        RotationTransition(
                          turns: _vinylCtrl,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(color: cSurfaceLowest, shape: BoxShape.circle),
                            child: const Icon(Icons.album, color: cSecondary, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 76,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(cfg['titulo']?.toString() ?? '@clubsanjose_oficial', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified, color: cPrimary, size: 18),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cfg['subtitulo']?.toString() ?? '¡Gol agónico en Oruro! Ruge el gigante de los Andes ⚽💙 #SanJose #OruroEsSanto #OrgulloSanto',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: cOnSurface, fontSize: 13.5),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          children: [
                            Icon(Icons.graphic_eq, color: cSecondary, size: 16),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text('Banda Poopó - Morenada Central de San José (Audio Oficial)', overflow: TextOverflow.ellipsis, style: TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(colors: [cPrimaryContainer, cSurfaceHigh, cSurfaceContainer]),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AnimatedRotation(
                        turns: _spinningDice ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 350),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(colors: [cSecondary, acento, cOnSecondaryContainer]),
                          ),
                          child: const Icon(Icons.casino, color: cSurface, size: 30),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(cfg['titulo']?.toString() ?? 'Tirar Dado Santo', overflow: TextOverflow.ellipsis, style: TextStyle(color: txtCol, fontSize: 17, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: acento, borderRadius: BorderRadius.circular(999)),
                                  child: Text(cfg['badge']?.toString() ?? '1 AL 6', style: const TextStyle(color: cOnSecondaryContainer, fontSize: 9, fontWeight: FontWeight.w900)),
                                ),
                              ],
                            ),
                            Text(cfg['subtitulo']?.toString() ?? '¡Sube tu captura y gana puntos y cupones instantáneos!', overflow: TextOverflow.ellipsis, style: const TextStyle(color: cOnSurfaceVariant, fontSize: 11.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: acento,
                    foregroundColor: cOnSecondaryContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _lanzarDadoStitch,
                  child: Row(
                    children: [
                      Text(cfg['boton_txt']?.toString() ?? 'Lanzar', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                      const SizedBox(width: 4),
                      const Icon(Icons.touch_app, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Próxima recompensa épica (Camiseta Oficial)', style: TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700)),
                Text(cfg['valor_destacado']?.toString() ?? '4/6 Tiros', style: const TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 6,
                width: double.infinity,
                color: cSurfaceLowest,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.66,
                  child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [cPrimary, acento]))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirSeccionPorId(String idSec, Map b) {
    final Map cfg = Map.from((_customSecciones[idSec] as Map?) ?? {});
    if (_navIndex == 0) {
      return _construirSeccionMuro(idSec, cfg, b);
    }
    if (_navIndex == 1) {
      return Ms12StitchGanadoresYBoveda.construirSeccionGanadores(
        idSec: idSec,
        cfg: cfg,
        hrs: _hrs.toString().padLeft(2, '0'),
        min: _min.toString().padLeft(2, '0'),
        seg: _seg.toString().padLeft(2, '0'),
        d: _digitosEsfera,
        onToast: _mostrarToast,
      );
    }
    if (_navIndex == 2) {
      return Ms12StitchGanadoresYBoveda.construirSeccionBoveda(
        idSec: idSec,
        cfg: cfg,
        intervaloPin: _intervaloPin,
        segQr: _segQr,
        codigoQr: _codigoQr,
        bovedaBlindada: _bovedaBlindada,
        onCambiarIntervalo: (op) {
          setState(() => _intervaloPin = op);
          _mostrarToast('Frecuencia configurada: $op');
        },
        onAbrirModalBlindar: () => setState(() => _showBlindarModal = true),
        onToast: _mostrarToast,
      );
    }
    if (_navIndex == 3) {
      return Ms13StitchSocioYAuditoria.construirSeccionAuditoria(
        idSec: idSec,
        cfg: cfg,
        rolAuditoria: _rolAuditoria,
        stockPoleras: _stockPoleras,
        tokenDetectado: _tokenDetectado,
        dadoProb: _dadoProb,
        reglaDual: _reglaDual,
        onCambiarRolAuditoria: (r) => setState(() => _rolAuditoria = r),
        onSimularEscaneo: () => setState(() => _tokenDetectado = 'Token #SJ-${1000 + _rng.nextInt(9000)} - Socio Activo'),
        onQuemarPremio: () {
          setState(() => _stockPoleras = math.max(0, _stockPoleras - 1));
          _mostrarToast('Premio redimido exitosamente (-1 Stock)');
        },
        onCambiarDadoProb: (v) => setState(() => _dadoProb = v),
        onToggleReglaDual: () => setState(() => _reglaDual = !_reglaDual),
        onToast: _mostrarToast,
      );
    }
    return Ms13StitchSocioYAuditoria.construirSeccionSocio(
      idSec: idSec,
      cfg: cfg,
      tabSocio: _tabSocio,
      votoSeleccionado: _votoSeleccionado,
      votoEmitido: _votoEmitido,
      ticketExtraReclamado: _ticketExtraReclamado,
      onCambiarTabSocio: (t) => setState(() => _tabSocio = t),
      onCambiarVoto: (v) => setState(() => _votoSeleccionado = v),
      onEmitirVoto: () {
        setState(() => _votoEmitido = true);
        _mostrarToast('Voto Registrado con Éxito · Hash: 0x9b42...1942SJ');
      },
      onReclamarTicket: () {
        setState(() => _ticketExtraReclamado = true);
        _mostrarToast('¡Ticket #SJ-1942-C Asignado a tu Carnet!');
      },
      onToast: _mostrarToast,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map b = (widget as Ms11StitchDiseno1Muro).bloque;
    final String avatarUrl = b['avatar_perfil_url']?.toString() ??
        'https://lh3.googleusercontent.com/aida/ALJJyrDJc05woFyW27izHWa68BsjEXCpRu6P4FlsytinWUlclP0ZD1zMKHXSdNpEFMS4m85L3AdI2m37GhWhAbJc_tqIwRNAZ6AmYPVlOy9bNXT25drLVeXaiHEa-3pcW2KvcvSnXz8oyBHN2bH0BGt6MVQCEkEd6BBijq1EQQdQa6I7tIZZug6lhpytkn2ai31KTmgPOgA99xT_M8mVOkQZ7MGa68wTRzPRxBbeHvFi7E8E';

    final double topPad = MediaQuery.of(context).padding.top;
    final double botPad = MediaQuery.of(context).padding.bottom;
    final String claveTab = _clavePestanaActual();
    final List listaIds = List.from((_ordenPorPestana[claveTab] as List?) ?? []);

    return Container(
      color: cSurface,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: topPad + 64 + (_modoStitchEdit ? 46 : 6),
                bottom: botPad + 92,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(listaIds.length, (idx) {
                  final String idSec = listaIds[idx].toString();
                  final String baseId = idSec.split('__copia')[0];
                  final String nombre = _nombresSeccion[baseId] ?? idSec;
                  final Map cfgActual = Map.from((_customSecciones[idSec] as Map?) ?? {});

                  return InspectorStitchSdui.envolverSeccionStitchPro(
                    context: context,
                    modoEdit: _modoStitchEdit,
                    idSeccion: idSec,
                    nombreSeccion: nombre,
                    index: idx,
                    total: listaIds.length,
                    configSeccion: cfgActual,
                    child: _construirSeccionPorId(idSec, b),
                    onSubir: () {
                      if (idx > 0) {
                        setState(() {
                          final item = listaIds.removeAt(idx);
                          listaIds.insert(idx - 1, item);
                          _ordenPorPestana[claveTab] = listaIds;
                        });
                        _sincronizarEdicionConSupabase();
                      }
                    },
                    onBajar: () {
                      if (idx < listaIds.length - 1) {
                        setState(() {
                          final item = listaIds.removeAt(idx);
                          listaIds.insert(idx + 1, item);
                          _ordenPorPestana[claveTab] = listaIds;
                        });
                        _sincronizarEdicionConSupabase();
                      }
                    },
                    onQuitar: () {
                      setState(() {
                        listaIds.removeAt(idx);
                        _ordenPorPestana[claveTab] = listaIds;
                      });
                      _sincronizarEdicionConSupabase();
                    },
                    onDuplicar: () {
                      setState(() {
                        final String nuevoId = '${baseId}__copia_${_rng.nextInt(999)}';
                        if (_customSecciones.containsKey(idSec)) {
                          _customSecciones[nuevoId] = Map.from(_customSecciones[idSec] as Map);
                        }
                        listaIds.insert(idx + 1, nuevoId);
                        _ordenPorPestana[claveTab] = listaIds;
                      });
                      _sincronizarEdicionConSupabase();
                    },
                    onGuardarConfig: (nuevaCfg) {
                      setState(() => _customSecciones[idSec] = nuevaCfg);
                      _sincronizarEdicionConSupabase();
                    },
                  );
                }),
              ),
            ),
          ),

          if (_modoStitchEdit)
            Positioned(
              top: topPad + 64,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF00509D),
                  border: Border(bottom: BorderSide(color: cSecondaryContainer, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_fix_high, color: cSecondaryContainer, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'STITCH STUDIO EDIT PRO: Toca cualquier bloque para editar',
                          style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: _restaurarPestanaActual,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: cSecondaryContainer, borderRadius: BorderRadius.circular(6)),
                        child: const Text('🔄 Restaurar', style: TextStyle(color: Color(0xFF071326), fontSize: 10, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: EdgeInsets.only(top: topPad, left: 16, right: 12),
                  height: topPad + 64,
                  decoration: BoxDecoration(
                    color: cSurface.withAlpha(216),
                    boxShadow: [BoxShadow(color: cSurfaceLowest.withAlpha(153), blurRadius: 24, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [cSecondaryContainer, cPrimary, Colors.transparent]),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                avatarUrl,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset('logo.png', width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, color: cOnSurface)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _navIndex == 3 ? 'AUDITORÍA DE PAGOS' : (b['header_titulo']?.toString() ?? 'SAN JOSÉ'),
                                    style: const TextStyle(color: cOnSurface, fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 0.6),
                                  ),
                                  const SizedBox(width: 6),
                                  if (_navIndex != 3)
                                    Text(b['header_anio']?.toString() ?? '1942', style: const TextStyle(color: cPrimary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: cSecondary, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  Text(b['header_rango']?.toString() ?? 'SOCIO VIP', style: const TextStyle(color: cSecondaryContainer, fontSize: 10, fontWeight: FontWeight.w700)),
                                  const Icon(Icons.expand_more, color: cSecondaryContainer, size: 12),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: cSurfaceHigh.withAlpha(230), borderRadius: BorderRadius.circular(999)),
                            child: Row(
                              children: [
                                const Icon(Icons.stars, color: cSecondaryContainer, size: 16),
                                const SizedBox(width: 4),
                                Text(b['header_puntos']?.toString() ?? '350', style: const TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w700)),
                                const SizedBox(width: 2),
                                const Text('pts', style: TextStyle(color: cSecondaryContainer, fontSize: 10, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              setState(() => _modoStitchEdit = !_modoStitchEdit);
                            },
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _modoStitchEdit ? cSecondaryContainer : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _modoStitchEdit ? Icons.edit_note : Icons.verified_user_outlined,
                                color: _modoStitchEdit ? cSurface : cOnSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_showAnonTooltip)
            Positioned(
              top: topPad + 76,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(160), blurRadius: 24)]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: cTertiaryContainer, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.shield_outlined, color: cOnTertiaryContainer, size: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Modo Anónimo (El Mirón)', style: TextStyle(color: cOnSurface, fontSize: 16, fontWeight: FontWeight.w700)),
                              InkWell(onTap: () => setState(() => _showAnonTooltip = false), child: const Icon(Icons.close, color: cOnSurfaceVariant, size: 18)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text('Estás navegando sin vincular tu número de socio oficial. Tus puntos de transmisión y cupones de dados se reservan en el dispositivo temporal #89F2A.', style: TextStyle(color: cOnSurfaceVariant, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_showDiceModal)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _showDiceModal = false),
                child: Container(
                  color: cSurface.withAlpha(204),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: 310,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: cSecondaryContainer, borderRadius: BorderRadius.circular(16)),
                          child: Text('$_diceValue', style: const TextStyle(color: cOnSecondaryContainer, fontSize: 40, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(height: 12),
                        const Text('¡TIRO PERFECTO!', style: TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                        const SizedBox(height: 4),
                        const Text('¡Ganaste +120 Puntos!', style: TextStyle(color: cOnSurface, fontSize: 22, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        const Text('Cupón desbloqueado: 20% de descuento en la Tienda Oficial Calle Bolívar.', textAlign: TextAlign.center, style: TextStyle(color: cOnSurfaceVariant, fontSize: 14)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: cPrimaryContainer, foregroundColor: cOnPrimaryContainer, padding: const EdgeInsets.symmetric(vertical: 14)),
                            onPressed: () {
                              setState(() {
                                _showDiceModal = false;
                                _navIndex = 2;
                              });
                            },
                            child: const Text('Guardar en mi Bóveda', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          if (_showBlindarModal)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _showBlindarModal = false),
                child: Container(
                  color: cSurfaceLowest.withAlpha(210),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: 330,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.enhanced_encryption, color: cSecondaryContainer),
                                SizedBox(width: 8),
                                Text('Blindaje de Bóveda', style: TextStyle(color: cOnSurface, fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            IconButton(onPressed: () => setState(() => _showBlindarModal = false), icon: const Icon(Icons.close, color: cOnSurfaceVariant)),
                          ],
                        ),
                        const Text('Asigna tu apodo de hincha y un PIN numérico de 4 dígitos para encriptar tu billetera.', style: TextStyle(color: cOnSurfaceVariant, fontSize: 12)),
                        const SizedBox(height: 12),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(hintText: 'Ej. MineroSanto_77', hintStyle: const TextStyle(color: Colors.white38), filled: true, fillColor: cSurfaceLowest, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(hintText: 'PIN 4 Dígitos (••••)', hintStyle: const TextStyle(color: Colors.white38), filled: true, fillColor: cSurfaceLowest, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: cSecondaryContainer, foregroundColor: cOnSecondaryContainer, padding: const EdgeInsets.symmetric(vertical: 13)),
                            onPressed: () {
                              setState(() {
                                _bovedaBlindada = true;
                                _showBlindarModal = false;
                              });
                              _mostrarToast('¡Bóveda blindada con éxito!');
                            },
                            icon: const Icon(Icons.verified),
                            label: const Text('Confirmar y Encriptar', style: TextStyle(fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          if (_toastMsg.isNotEmpty)
            Positioned(
              bottom: botPad + 92,
              left: 24,
              right: 24,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(color: cSecondaryContainer, borderRadius: BorderRadius.circular(999), boxShadow: [BoxShadow(color: Colors.black.withAlpha(140), blurRadius: 16)]),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: cOnSecondaryContainer, size: 18),
                      const SizedBox(width: 8),
                      Flexible(child: Text(_toastMsg, style: const TextStyle(color: cOnSecondaryContainer, fontSize: 12, fontWeight: FontWeight.w800))),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  height: botPad + 80,
                  padding: EdgeInsets.only(bottom: botPad, left: 4, right: 4),
                  decoration: BoxDecoration(
                    color: cSurface.withAlpha(230),
                    boxShadow: [BoxShadow(color: const Color(0xFF002855).withAlpha(76), blurRadius: 24, offset: const Offset(0, -4))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _construirItemNav(idx: 0, icono: Icons.play_circle_outline, label: 'Muro'),
                      _construirItemNav(idx: 1, icono: Icons.military_tech_outlined, label: 'Ganadores', badgeTxt: 'HOY', badgeBg: cSecondaryContainer, badgeFg: cOnSecondaryContainer),
                      _construirItemNav(idx: 2, icono: Icons.lock_outline, label: 'Bóveda', badgeTxt: 'QR', badgeBg: cPrimaryContainer, badgeFg: cOnPrimaryContainer),
                      _construirItemNav(idx: 3, icono: Icons.account_balance_wallet_outlined, label: 'Aportes'),
                      _construirItemNav(idx: 4, icono: Icons.badge_outlined, label: 'Zona Socio', miniLock: true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirItemNav({
    required int idx,
    required IconData icono,
    required String label,
    String? badgeTxt,
    Color? badgeBg,
    Color? badgeFg,
    bool miniLock = false,
  }) {
    final bool activo = _navIndex == idx;
    final Color col = activo ? cSecondary : cOnSurfaceVariant;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _navIndex = idx);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 66,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icono, color: col, size: 24),
                if (badgeTxt != null)
                  Positioned(
                    top: -4,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(999)),
                      child: Text(badgeTxt, style: TextStyle(color: badgeFg, fontSize: 8.5, fontWeight: FontWeight.w800)),
                    ),
                  ),
                if (miniLock)
                  const Positioned(
                    top: -2,
                    right: -4,
                    child: Icon(Icons.lock, color: cSecondaryContainer, size: 11),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: col, fontSize: 10, fontWeight: activo ? FontWeight.w800 : FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}