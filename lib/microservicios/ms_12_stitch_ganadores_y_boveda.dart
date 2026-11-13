import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/escudo_aislamiento.dart';

class Ms12StitchGanadoresYBoveda {
  static const Color cSurface = Color(0xFF071326);
  static const Color cSurfaceLowest = Color(0xFF030E21);
  static const Color cSurfaceLow = Color(0xFF101C2F);
  static const Color cSurfaceContainer = Color(0xFF142033);
  static const Color cSurfaceHigh = Color(0xFF1F2A3E);
  static const Color cSurfaceHighest = Color(0xFF2A3549);
  static const Color cSurfaceVariant = Color(0xFF2A3549);
  static const Color cOnSurface = Color(0xFFD7E3FD);
  static const Color cOnSurfaceVariant = Color(0xFFC2C6D3);
  static const Color cOutline = Color(0xFF8C919C);
  static const Color cPrimary = Color(0xFFA9C7FF);
  static const Color cOnPrimary = Color(0xFF003062);
  static const Color cPrimaryContainer = Color(0xFF00509D);
  static const Color cOnPrimaryContainer = Color(0xFFA4C5FF);
  static const Color cSecondary = Color(0xFFFFD795);
  static const Color cSecondaryContainer = Color(0xFFFBB400);
  static const Color cOnSecondaryContainer = Color(0xFF694900);
  static const Color cSecondaryFixedDim = Color(0xFFFFBA27);
  static const Color cTertiary = Color(0xFFA7C8FF);

  // ===========================================================================
  // SECCIONES DE DISEÑO 5_3.txt: GANADORES DIARIOS Y TOMBOLA 06:00 AM
  // ===========================================================================
  static Widget construirSeccionGanadores({
    required String idSec,
    required Map cfg,
    required String hrs,
    required String min,
    required String seg,
    required List d,
    required Function(String) onToast,
  }) {
    final Color acento = hexAColor(cfg['color_acento_hex']?.toString(), cSecondaryContainer);
    final Color txtCol = hexAColor(cfg['color_texto_hex']?.toString(), cOnSurface);

    if (idSec.startsWith('gan_reloj')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cSurfaceHigh,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(90), blurRadius: 16)],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: cSurfaceLowest.withAlpha(204), borderRadius: BorderRadius.circular(999)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.casino, color: acento, size: 15),
                    const SizedBox(width: 6),
                    Text(
                      cfg['badge']?.toString() ?? 'SORTEO AUTOMATIZADO 06:00 AM',
                      style: const TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cfg['titulo']?.toString() ?? 'PRÓXIMA TÓMBOLA SANTA',
                style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: cSurfaceLowest.withAlpha(230), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _cajaReloj(cfg['valor_destacado']?.toString() ?? hrs, 'HRS'),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text(':', style: TextStyle(color: cSecondary, fontSize: 22, fontWeight: FontWeight.bold))),
                    _cajaReloj(min, 'MIN'),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text(':', style: TextStyle(color: cSecondary, fontSize: 22, fontWeight: FontWeight.bold))),
                    _cajaReloj(seg, 'SEG'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cfg['subtitulo']?.toString() ?? 'Generación criptográfica de boletos por aportes confirmados',
                textAlign: TextAlign.center,
                style: const TextStyle(color: cOnSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('gan_premio')) {
      final String img = cfg['imagen_url']?.toString() ??
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCJ-oE4cIBMfeuqLBNAuYoVl-21SUEgErUtcmNZbWV9O4OaM6uBtxsd7BMBEnRZBfudHeZ5X9HUID6_bBdnLgGuFzG3NFmzmVt3zSQpBd_qDEaeMZwS9B_DX-QAmGKRB7la3unxl0rx7GyyTva0tjMudhs-tedsWx4kteJliL2bPNAx3IgB8K1AlJug-yDe8Wzt0L7BGYQfLoVTRUK1e_wLqIA0j7I0AElQz8U_ZgU';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(colors: [cSurfaceContainer, cSurfaceHigh]),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  img,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: cSurfaceLowest, child: const Icon(Icons.workspace_premium, color: cSecondary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: acento, borderRadius: BorderRadius.circular(999)),
                          child: Text(cfg['badge']?.toString() ?? 'PREMIO ESTRELLA', style: const TextStyle(color: cOnSecondaryContainer, fontSize: 9.5, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 6),
                        const Text('HOY 19:42', style: TextStyle(color: cTertiary, fontSize: 10, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(cfg['titulo']?.toString() ?? 'Camiseta Oficial Autografiada', style: TextStyle(color: txtCol, fontSize: 17, fontWeight: FontWeight.w700)),
                    Text(cfg['subtitulo']?.toString() ?? '+ 2 Cupones Franquicia Santo Express', style: const TextStyle(color: cOnSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('gan_esfera')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cSurfaceLow, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: cSecondary, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(cfg['titulo']?.toString() ?? 'ESFERA CUÁNTICA EN VIVO', style: TextStyle(color: txtCol, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(999)),
                    child: Text(cfg['badge']?.toString() ?? 'Boloña #748-SJ', style: const TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 112,
                decoration: BoxDecoration(color: cSurfaceLowest, borderRadius: BorderRadius.circular(8)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _bolaDigito('${d[0]}', 'BOL-1', false, acento),
                        const SizedBox(width: 8),
                        _bolaDigito('${d[1]}', 'BOL-2', false, acento),
                        const SizedBox(width: 8),
                        _bolaDigito('${d[2]}', 'BOL-3', false, acento),
                        const SizedBox(width: 8),
                        _bolaDigito('${d[3]}', 'SANTO', true, acento),
                      ],
                    ),
                    Positioned(
                      bottom: 6,
                      child: Row(
                        children: [
                          const Icon(Icons.sync, color: cPrimary, size: 12),
                          const SizedBox(width: 4),
                          Text(cfg['subtitulo']?.toString() ?? 'Mezclando 4,120 números activos', style: const TextStyle(color: cPrimary, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('gan_cta')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cPrimaryContainer, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.help_outline, color: cSecondary, size: 18),
                  const SizedBox(width: 6),
                  Text(cfg['titulo']?.toString() ?? '¿Cómo entrar a la tómbola?', style: TextStyle(color: txtCol, fontSize: 17, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                cfg['subtitulo']?.toString() ?? 'Sube tus comprobantes de aporte o cuota. Cada 10 Bs. equivale a 1 tirada de dado cuántico que añade números a tu carnet de sorteo diario.',
                style: const TextStyle(color: cOnPrimaryContainer, fontSize: 12, height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: acento, foregroundColor: cOnSecondaryContainer, padding: const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: () => onToast('Comprobante listo para subir a la tómbola'),
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: Text(cfg['boton_txt']?.toString() ?? 'Subir Comprobante', style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: cSurfaceHigh.withAlpha(160), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                    onPressed: () => onToast('Sorteo diario 06:00 AM auditado'),
                    child: const Text('Bases'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('gan_top10')) {
      final List ganadores = [
        {'pos': '1º', 'ini': 'HO', 'nom': 'Hincha_Orureño_77', 'premio': 'Polera Conmemorativa 1942', 'hora': '06:01 AM', 'tk': '#4819-A', 'top': true},
        {'pos': '2º', 'ini': 'CM', 'nom': 'Carlos M. (Socio 114)', 'premio': 'Menú Combo Santo en Pollos Aliados', 'hora': '06:01 AM', 'tk': '#0192-K', 'top': false},
        {'pos': '3º', 'ini': '📱', 'nom': 'Device_98B2', 'premio': 'Entrada Preferencial vs Blooming', 'hora': '06:02 AM', 'tk': '#7731-X', 'top': false},
        {'pos': '4º', 'ini': 'RQ', 'nom': 'Raúl Quirquincho', 'premio': 'Gorra Oficial Bordada Azul y Blanco', 'hora': '06:02 AM', 'tk': '', 'top': false},
        {'pos': '5º', 'ini': '👤', 'nom': 'Anon_Oruro_V', 'premio': 'Vale de 50 Bs en Tienda Oficial', 'hora': '06:03 AM', 'tk': '', 'top': false},
        {'pos': '6º', 'ini': 'JS', 'nom': 'Javier S. O.', 'premio': 'Pack Bebidas Energéticas Sponsor', 'hora': '06:03 AM', 'tk': '', 'top': false},
        {'pos': '7º', 'ini': '⚽', 'nom': 'Device_FA41', 'premio': 'Bufanda Clásica Hinchada Santa', 'hora': '06:04 AM', 'tk': '', 'top': false},
        {'pos': '8º', 'ini': 'MV', 'nom': 'Maria V. Tarifa', 'premio': 'Pase Doble Curva Sur vs Wilstermann', 'hora': '06:04 AM', 'tk': '', 'top': false},
        {'pos': '9º', 'ini': 'FP', 'nom': "Fernando P. 'Minero'", 'premio': 'Sticker Pack Vinilo + Llavero Metálico', 'hora': '06:05 AM', 'tk': '', 'top': false},
        {'pos': '10º', 'ini': '💎', 'nom': 'Device_00CC', 'premio': 'Bono 100 Puntos Bóveda de Recompensas', 'hora': '06:05 AM', 'tk': '', 'top': false},
      ];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.military_tech, color: cSecondary, size: 22),
                    const SizedBox(width: 6),
                    Text(cfg['titulo']?.toString() ?? 'Top 10 Ganadores de Hoy', style: TextStyle(color: txtCol, fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(999)),
                  child: Text(cfg['badge']?.toString() ?? 'Auditado', style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...ganadores.map((g) {
              final bool es1 = g['top'] == true;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: es1 ? cSurfaceHigh : cSurfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: es1 ? acento : cSurfaceVariant, shape: BoxShape.circle),
                      child: Text(g['pos'].toString(), style: TextStyle(color: es1 ? cOnSecondaryContainer : cOnSurface, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: cSurfaceLowest, shape: BoxShape.circle),
                      child: Text(g['ini'].toString(), style: const TextStyle(color: cSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g['nom'].toString(), style: const TextStyle(color: cOnSurface, fontSize: 13, fontWeight: FontWeight.w700)),
                          Text(g['premio'].toString(), style: TextStyle(color: es1 ? cSecondary : cOnSurfaceVariant, fontSize: 11.5)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(g['hora'].toString(), style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10)),
                        if (g['tk'].toString().isNotEmpty)
                          Text(g['tk'].toString(), style: const TextStyle(color: cTertiary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cSurfaceLow, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.handshake, color: acento, size: 18),
                    const SizedBox(width: 6),
                    Text(cfg['titulo']?.toString() ?? 'FRANQUICIAS ALIADAS DE LA JORNADA', style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700)),
                  ],
                ),
                const Text('Red Oficial', style: TextStyle(color: cTertiary, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _itemSponsor(Icons.restaurant, 'Pollos Aliados', '2x1 Combos', cSecondary),
                const SizedBox(width: 8),
                _itemSponsor(Icons.local_cafe, 'Café La Mina', 'Pase VIP', cPrimary),
                const SizedBox(width: 8),
                _itemSponsor(Icons.local_gas_station, 'Estación Pagador', 'Puntos x2', cSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _cajaReloj(String numTxt, String lbl) {
    return Column(
      children: [
        Text(numTxt, style: const TextStyle(color: cSecondary, fontSize: 26, fontWeight: FontWeight.w800)),
        Text(lbl, style: const TextStyle(color: cOnSurfaceVariant, fontSize: 9, fontWeight: FontWeight.w700)),
      ],
    );
  }

  static Widget _bolaDigito(String d, String lbl, bool esSanto, Color acento) {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: esSanto ? acento : cSurfaceHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(d, style: TextStyle(color: esSanto ? cOnSecondaryContainer : cSecondary, fontSize: 24, fontWeight: FontWeight.w800)),
          Text(lbl, style: TextStyle(color: esSanto ? cOnSecondaryContainer : cOnSurfaceVariant, fontSize: 8, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  static Widget _itemSponsor(IconData ic, String nom, String sub, Color col) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: cSurfaceHigh, shape: BoxShape.circle),
              child: Icon(ic, color: col, size: 18),
            ),
            const SizedBox(height: 4),
            Text(nom, overflow: TextOverflow.ellipsis, style: const TextStyle(color: cOnSurface, fontSize: 11, fontWeight: FontWeight.w600)),
            Text(sub, style: TextStyle(color: col, fontSize: 9.5, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SECCIONES DE DISEÑO 2_3.txt: BOVEDA DE PREMIOS QR Y CUPONES DIARIOS
  // ===========================================================================
  static Widget construirSeccionBoveda({
    required String idSec,
    required Map cfg,
    required String intervaloPin,
    required int segQr,
    required String codigoQr,
    required bool bovedaBlindada,
    required Function(String) onCambiarIntervalo,
    required Function onAbrirModalBlindar,
    required Function(String) onToast,
  }) {
    final Color acento = hexAColor(cfg['color_acento_hex']?.toString(), cSecondaryContainer);
    final Color txtCol = hexAColor(cfg['color_texto_hex']?.toString(), cOnSurface);

    if (idSec.startsWith('bov_alerta')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: acento, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.shield_outlined, color: cOnSecondaryContainer, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cfg['badge']?.toString() ?? 'PROTOCOLO DE RESGUARDO', style: TextStyle(color: acento, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                        const SizedBox(height: 4),
                        Text(cfg['titulo']?.toString() ?? 'Protege tus Recompensas', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(
                          cfg['subtitulo']?.toString() ?? 'Tu Bóveda contiene 1 Premio Activo y 3 Cupones. Crea tu Usuario + PIN de 4 dígitos para no perderlos si cambias o formateas de celular.',
                          style: const TextStyle(color: cOnSurfaceVariant, fontSize: 12, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bovedaBlindada ? cSurfaceHighest : acento,
                    foregroundColor: bovedaBlindada ? cSecondary : cOnSecondaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: bovedaBlindada ? null : () => onAbrirModalBlindar(),
                  icon: Icon(bovedaBlindada ? Icons.verified_user : Icons.lock_reset, size: 20),
                  label: Text(
                    bovedaBlindada ? 'Bóveda Blindada y Protegida' : (cfg['boton_txt']?.toString() ?? 'Blindar Bóveda Ahora'),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('bov_saldos')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('BILLETERA SANTA', style: TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700)),
                        Icon(Icons.stars, color: cSecondary, size: 18),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(cfg['valor_destacado']?.toString() ?? '480', style: const TextStyle(color: cSecondary, fontSize: 26, fontWeight: FontWeight.w800)),
                        const SizedBox(width: 4),
                        const Text('pts', style: TextStyle(color: cSecondaryFixedDim, fontSize: 10, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const Text('Disponibles p/ canje', style: TextStyle(color: cOnSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CADUCIDAD PIN', style: TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700)),
                        Icon(Icons.timer, color: cPrimary, size: 18),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(intervaloPin, style: const TextStyle(color: cPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Autenticación activa', style: TextStyle(color: cOnSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (idSec.startsWith('bov_timer')) {
      final opciones = ['1 Hora', '6 Horas', '24 Horas', 'Siempre'];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.security_update_good, color: cPrimary, size: 20),
                      const SizedBox(width: 8),
                      Text(cfg['titulo']?.toString() ?? 'FRECUENCIA DE BLOQUEO PIN', style: TextStyle(color: txtCol, fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: cPrimaryContainer, borderRadius: BorderRadius.circular(999)),
                    child: Text(cfg['badge']?.toString() ?? 'SEGURO', style: const TextStyle(color: cOnPrimaryContainer, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: cSurfaceLowest, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: opciones.map((op) {
                    final bool sel = intervaloPin == op;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onCambiarIntervalo(op),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: sel ? cPrimary : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            op,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: sel ? cOnPrimary : cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('bov_qr')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.military_tech, color: cSecondary, size: 22),
                    const SizedBox(width: 6),
                    Text('Mis Premios Activos (QR)', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(999)),
                  child: Text('1 Reclamo Listo', style: TextStyle(color: acento, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(colors: [cSurfaceHigh, cSurfaceContainer, cSurfaceLowest]),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: cSurfaceHighest, borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.workspace_premium, color: cSecondary, size: 24),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('PASE VIP DIGITAL', style: TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                              Text(cfg['titulo']?.toString() ?? '1x Polera Oficial 2025', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                              Text(cfg['subtitulo']?.toString() ?? 'Talla L • Edición Homenaje Minero', style: const TextStyle(color: cPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: acento, borderRadius: BorderRadius.circular(6)),
                        child: Text(cfg['badge']?.toString() ?? 'VÁLIDO', style: const TextStyle(color: cOnSecondaryContainer, fontSize: 10, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: cSurfaceLowest.withAlpha(230), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: cOnSurface, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.qr_code_2, color: cSurfaceLowest, size: 150),
                        ),
                        const SizedBox(height: 10),
                        const Text('CÓDIGO DE CANJE DINÁMICO', style: TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cfg['valor_destacado']?.toString() ?? codigoQr, style: const TextStyle(color: cSecondary, fontSize: 22, fontFamily: 'monospace', fontWeight: FontWeight.w800, letterSpacing: 2)),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: codigoQr));
                                onToast('Código copiado: $codigoQr');
                              },
                              icon: const Icon(Icons.content_copy, color: cOnSurfaceVariant, size: 18),
                            ),
                          ],
                        ),
                        Text('Se regenera en ${segQr}s', style: const TextStyle(color: cSecondaryFixedDim, fontSize: 10, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: cPrimaryContainer, foregroundColor: cOnPrimaryContainer, padding: const EdgeInsets.symmetric(vertical: 11)),
                          onPressed: () => onToast('QR listo para validación en tienda'),
                          icon: const Icon(Icons.storefront, size: 18),
                          label: const Text('Mostrar en Tienda', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: cSurfaceHighest, foregroundColor: cOnSurface, padding: const EdgeInsets.symmetric(vertical: 11)),
                          onPressed: () => onToast('Introduce el carnet o usuario de destino'),
                          icon: const Icon(Icons.send_to_mobile, size: 18),
                          label: const Text('Transferir a Hincha', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final List cupones = [
      {'ic': Icons.restaurant, 'off': '20% DESCUENTO', 'lug': '• Oruro Centro', 'nom': 'Pollos Copacabana Oruro', 'desc': 'Válido en consumo presencial combo Santo', 'ser': 'SN-772910', 'exp': 'Expira: Hoy 23:59', 'col': cSecondary},
      {'ic': Icons.shopping_bag, 'off': 'VALE 50 BS', 'lug': '• Sede Club', 'nom': 'Tienda Oficial Santo', 'desc': 'Aplicable a indumentaria oficial 2025', 'ser': 'SN-903124', 'exp': 'Expira: en 3 días', 'col': cPrimary},
      {'ic': Icons.sports_bar, 'off': '2x1 CHOPP', 'lug': '• Fan Zone', 'nom': 'Cervecería Tradición Quirquincha', 'desc': 'Día del partido vs Wilstermann', 'ser': 'SN-441029', 'exp': 'Expira: Domingo', 'col': cSecondary},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.confirmation_number, color: cPrimary, size: 22),
                  const SizedBox(width: 6),
                  Text(cfg['titulo']?.toString() ?? 'Mis Cupones Diarios', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
              Text(cfg['badge']?.toString() ?? '3 Activos', style: const TextStyle(color: cPrimary, fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          ...cupones.map((c) {
            final Color col = c['col'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(8)),
                        child: Icon(c['ic'] as IconData, color: col, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(c['off'].toString(), style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.w800)),
                                const SizedBox(width: 4),
                                Text(c['lug'].toString(), style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10)),
                              ],
                            ),
                            Text(c['nom'].toString(), style: const TextStyle(color: cOnSurface, fontSize: 16, fontWeight: FontWeight.w700)),
                            Text(c['desc'].toString(), style: const TextStyle(color: cOnSurfaceVariant, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.qr_code_2, color: cPrimary, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: cSurfaceLow, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Serie: ${c['ser']}', style: TextStyle(color: col, fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                        Text(c['exp'].toString(), style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}