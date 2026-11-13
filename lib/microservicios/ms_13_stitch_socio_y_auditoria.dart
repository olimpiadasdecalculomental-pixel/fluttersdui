import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/escudo_aislamiento.dart';

class Ms13StitchSocioYAuditoria {
  static const Color cSurface = Color(0xFF071326);
  static const Color cSurfaceLowest = Color(0xFF030E21);
  static const Color cSurfaceLow = Color(0xFF101C2F);
  static const Color cSurfaceContainer = Color(0xFF142033);
  static const Color cSurfaceHigh = Color(0xFF1F2A3E);
  static const Color cSurfaceHighest = Color(0xFF2A3549);
  static const Color cSurfaceBright = Color(0xFF2E394E);
  static const Color cOnSurface = Color(0xFFD7E3FD);
  static const Color cOnSurfaceVariant = Color(0xFFC2C6D3);
  static const Color cPrimary = Color(0xFFA9C7FF);
  static const Color cOnPrimary = Color(0xFF003062);
  static const Color cPrimaryContainer = Color(0xFF00509D);
  static const Color cOnPrimaryContainer = Color(0xFFA4C5FF);
  static const Color cSecondary = Color(0xFFFFD795);
  static const Color cSecondaryContainer = Color(0xFFFBB400);
  static const Color cOnSecondaryContainer = Color(0xFF694900);
  static const Color cTertiary = Color(0xFFA7C8FF);
  static const Color cTertiaryContainer = Color(0xFF295186);
  static const Color cError = Color(0xFFFFB4AB);
  static const Color cErrorContainer = Color(0xFF93000A);
  static const Color cOnErrorContainer = Color(0xFFFFDAD6);

  static Widget construirSeccionSocio({
    required String idSec,
    required Map cfg,
    required String tabSocio,
    required String votoSeleccionado,
    required bool votoEmitido,
    required bool ticketExtraReclamado,
    required Function(String) onCambiarTabSocio,
    required Function(String) onCambiarVoto,
    required Function onEmitirVoto,
    required Function onReclamarTicket,
    required Function(String) onToast,
  }) {
    final Color acento = hexAColor(cfg['color_acento_hex']?.toString(), cSecondaryContainer);
    final Color txtCol = hexAColor(cfg['color_texto_hex']?.toString(), cOnSurface);

    if (idSec.startsWith('soc_hero')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(colors: [cSurfaceHigh, cSurfaceContainer, cSurfaceLow]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: acento.withAlpha(50), shape: BoxShape.circle),
                      child: Icon(Icons.workspace_premium, color: acento, size: 28),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: acento.withAlpha(50), borderRadius: BorderRadius.circular(999)),
                                child: Text(cfg['badge']?.toString() ?? 'ACREDITADO ACTIVO', style: TextStyle(color: acento, fontSize: 9, fontWeight: FontWeight.w800)),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: cSurfaceBright.withAlpha(128), borderRadius: BorderRadius.circular(999)),
                                child: const Text('Auditado', style: TextStyle(color: cOnSurfaceVariant, fontSize: 9, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(cfg['titulo']?.toString() ?? 'Socio Vitalicio', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                          Text(cfg['subtitulo']?.toString() ?? 'Registro Histórico: #1942', style: const TextStyle(color: cSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('QUIRQUINCHO ID', style: TextStyle(color: cPrimary, fontSize: 9.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: cSurfaceLowest, borderRadius: BorderRadius.circular(8)),
                    child: Text(cfg['valor_destacado']?.toString() ?? 'SJ-42901-LP', style: const TextStyle(color: cOnSurface, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('soc_tabs')) {
      final items = [
        {'k': 'parlamento', 'ic': Icons.how_to_vote, 'lbl': 'Parlamento (+51%)'},
        {'k': 'credencial', 'ic': Icons.badge_outlined, 'lbl': 'Credencial'},
        {'k': 'beneficios', 'ic': Icons.stars_outlined, 'lbl': 'Sorteos VIP'},
      ];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: cSurfaceLow, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: items.map((it) {
              final bool sel = tabSocio == it['k'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onCambiarTabSocio(it['k'].toString()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? cPrimaryContainer : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(it['ic'] as IconData, size: 15, color: sel ? cOnPrimaryContainer : cOnSurfaceVariant),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            it['lbl'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: sel ? cOnPrimaryContainer : cOnSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    if (idSec.startsWith('soc_parlamento')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: cPrimary.withAlpha(50), shape: BoxShape.circle),
                        child: const Icon(Icons.gavel, color: cPrimary, size: 18),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cfg['titulo']?.toString() ?? 'Parlamento Santo', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                          const Text('Asamblea Virtual Vinculante en Vivo', style: TextStyle(color: cOnSurfaceVariant, fontSize: 11.5)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: acento.withAlpha(50), borderRadius: BorderRadius.circular(999)),
                    child: Text(cfg['badge']?.toString() ?? 'ACTIVA', style: TextStyle(color: acento, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('MOCIÓN N° 08-2025', style: TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                    const SizedBox(height: 4),
                    Text(
                      cfg['subtitulo']?.toString() ?? '“¿Aprobación de la indumentaria alternativa para Copa 2025 y contrato de sponsor textil oficial?”',
                      style: const TextStyle(color: cOnSurface, fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quórum calculado al 100% de socios', style: TextStyle(color: cOnSurfaceVariant, fontSize: 11.5)),
                  Text(cfg['valor_destacado']?.toString() ?? '3,420 socios habilitados', style: const TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: cSurfaceLowest, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progreso de Votación', style: TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold)),
                        Text('Participación: 80.5% (2,753 votos)', style: TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: SizedBox(
                        height: 14,
                        child: Row(
                          children: [
                            Expanded(flex: 624, child: Container(color: acento)),
                            Expanded(flex: 181, child: Container(color: cErrorContainer)),
                            Expanded(flex: 195, child: Container(color: cSurfaceHigh)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('▲ Meta 51% Quórum Superada', style: TextStyle(color: cSecondary, fontSize: 9.5, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _cajaVoto('A FAVOR', '62.4%', '2,134 votos', acento),
                        const SizedBox(width: 6),
                        _cajaVoto('EN CONTRA', '18.1%', '619 votos', cError),
                        const SizedBox(width: 6),
                        _cajaVoto('PENDIENTE', '19.5%', '667 socios', cTertiary),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onCambiarVoto('favor'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cSurfaceHigh,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: votoSeleccionado == 'favor' ? acento : Colors.transparent, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Icon(votoSeleccionado == 'favor' ? Icons.radio_button_checked : Icons.radio_button_off, color: acento, size: 18),
                            const SizedBox(width: 6),
                            const Text('A Favor', style: TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onCambiarVoto('contra'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cSurfaceHigh,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: votoSeleccionado == 'contra' ? cError : Colors.transparent, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Icon(votoSeleccionado == 'contra' ? Icons.radio_button_checked : Icons.radio_button_off, color: cError, size: 18),
                            const SizedBox(width: 6),
                            const Text('En Contra', style: TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: votoEmitido ? cSurfaceBright : acento,
                    foregroundColor: votoEmitido ? cOnSurface : cOnSecondaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: votoEmitido ? null : () => onEmitirVoto(),
                  icon: Icon(votoEmitido ? Icons.check_circle : Icons.fingerprint, size: 20),
                  label: Text(
                    votoEmitido ? 'Voto Auditado (Hash: 0x9b42...1942SJ)' : (cfg['boton_txt']?.toString() ?? 'Emitir Voto Certificado (Firma Digital)'),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('soc_credencial')) {
      final String fotoSocio = cfg['imagen_url']?.toString() ??
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCb5NY4n_ugH-ni34NAfQyVGYpraf_nTo7UO280JrhbSAkRR21bUKAIFFGNWpYsZMaN7B3Uw-VvTp2EoxGz_I4y_0rSOTp_2U_W0XGv7mQBM3K3ykJ_LOvZEdTRDCze_Vl9vfG0GB_WgQB57laQaWxloca3-f33GK3NYH4DONfr89_8wflkqm-FN2rZd2Bn9AT-vJ_2fXeAPa7CDk0b3206dDMHsjn2uEwFvj_tAK8';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(colors: [cSurfaceHighest, cPrimaryContainer, cSurfaceLowest]),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: acento, shape: BoxShape.circle),
                        child: const Text('V', style: TextStyle(color: cOnSecondaryContainer, fontSize: 18, fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CLUB SAN JOSÉ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                          Text('FUNDADO 1942 • ORURO', style: TextStyle(color: cSecondary, fontSize: 9.5, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: cSurfaceLowest.withAlpha(204), borderRadius: BorderRadius.circular(999)),
                    child: Text(cfg['badge']?.toString() ?? 'ESTADIO JESÚS BERMÚDEZ', style: const TextStyle(color: cSecondary, fontSize: 9, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      fotoSocio,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: cSurfaceHigh, child: const Icon(Icons.person, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cfg['titulo']?.toString() ?? 'Alejandro Choque M.', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w800)),
                        Text(cfg['subtitulo']?.toString() ?? 'SOCIO TITULAR VIP #1942', style: const TextStyle(color: cPrimary, fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                        const Text('Acceso Preferencial Tribuna General', style: TextStyle(color: cOnSurfaceVariant, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('VIGENCIA', style: TextStyle(color: Colors.white70, fontSize: 9.5)),
                      Text(cfg['valor_destacado']?.toString() ?? 'DIC 2025', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: acento, foregroundColor: cOnSecondaryContainer),
                    onPressed: () => onToast('QR Torniquete Puertas 3 y 4 listo'),
                    icon: const Icon(Icons.qr_code_2, size: 18),
                    label: Text(cfg['boton_txt']?.toString() ?? 'Pase Estadio Bermúdez', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('soc_aportes')) {
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
                      Icon(Icons.account_balance_wallet, color: acento, size: 20),
                      const SizedBox(width: 8),
                      Text(cfg['titulo']?.toString() ?? 'Estado de Cuenta & Aportes', style: TextStyle(color: txtCol, fontSize: 17, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: acento.withAlpha(50), borderRadius: BorderRadius.circular(999)),
                    child: Text(cfg['badge']?.toString() ?? 'AL DÍA', style: TextStyle(color: acento, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _filaAporte('Cuota de Inscripción', 'Aporte Único de Membresía', '270 BS', 'PAGADO', acento),
              const SizedBox(height: 6),
              _filaAporte('Mensualidad Ordinaria', 'Noviembre 2024 • Aporte Santo', cfg['valor_destacado']?.toString() ?? '70 BS', 'AL DÍA', cPrimary),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: cPrimaryContainer, foregroundColor: cOnPrimaryContainer),
                  onPressed: () => onToast('Adelanto de 70 BS iniciado'),
                  child: Text(cfg['boton_txt']?.toString() ?? 'Adelantar 70 BS (Vencimiento 15 Dic)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: acento, borderRadius: BorderRadius.circular(999)),
              child: Text(cfg['badge']?.toString() ?? 'SORTEO EXCLUSIVO DE SOCIOS', style: const TextStyle(color: cOnSecondaryContainer, fontSize: 10, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 8),
            Text(cfg['titulo']?.toString() ?? 'Camiseta Oficial Firmada por el Plantel Completo', style: TextStyle(color: txtCol, fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(cfg['subtitulo']?.toString() ?? 'Autógrafos certificados de los 26 futbolistas • Cierra en 3 días 14h', style: const TextStyle(color: cOnSurfaceVariant, fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              children: [
                _chipTicket('#SJ-1942-A'),
                const SizedBox(width: 6),
                _chipTicket('#SJ-1942-B'),
                if (ticketExtraReclamado) ...[
                  const SizedBox(width: 6),
                  _chipTicket('#SJ-1942-C'),
                ],
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ticketExtraReclamado ? cSurfaceBright : acento,
                  foregroundColor: ticketExtraReclamado ? cSecondary : cOnSecondaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: ticketExtraReclamado ? null : () => onReclamarTicket(),
                icon: Icon(ticketExtraReclamado ? Icons.check : Icons.confirmation_number, size: 18),
                label: Text(
                  ticketExtraReclamado ? '¡Ticket #SJ-1942-C Asignado a tu Carnet!' : (cfg['boton_txt']?.toString() ?? 'Reclamar Ticket Extra (Gratis Socio VIP)'),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _cajaVoto(String lbl, String porc, String votos, Color col) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: cSurfaceHigh.withAlpha(160), borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lbl, style: TextStyle(color: col, fontSize: 9.5, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(porc, style: const TextStyle(color: cOnSurface, fontSize: 16, fontWeight: FontWeight.w800)),
            Text(votos, style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  static Widget _filaAporte(String tit, String sub, String monto, String est, Color col) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tit, style: const TextStyle(color: cOnSurface, fontSize: 13, fontWeight: FontWeight.bold)),
              Text(sub, style: const TextStyle(color: cOnSurfaceVariant, fontSize: 11)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(monto, style: const TextStyle(color: cOnSurface, fontSize: 16, fontWeight: FontWeight.w800)),
              Text(est, style: TextStyle(color: col, fontSize: 9.5, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _chipTicket(String tk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: cSurfaceLowest, borderRadius: BorderRadius.circular(6)),
      child: Text(tk, style: const TextStyle(color: cSecondary, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
    );
  }

  static Widget construirSeccionAuditoria({
    required String idSec,
    required Map cfg,
    required String rolAuditoria,
    required int stockPoleras,
    required String tokenDetectado,
    required int dadoProb,
    required bool reglaDual,
    required Function(String) onCambiarRolAuditoria,
    required Function onSimularEscaneo,
    required Function onQuemarPremio,
    required Function(int) onCambiarDadoProb,
    required Function onToggleReglaDual,
    required Function(String) onToast,
  }) {
    final Color acento = hexAColor(cfg['color_acento_hex']?.toString(), cSecondaryContainer);
    final Color txtCol = hexAColor(cfg['color_texto_hex']?.toString(), cOnSurface);

    if (idSec.startsWith('aud_switch')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onCambiarRolAuditoria('admin'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: rolAuditoria == 'admin' ? cPrimaryContainer : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.admin_panel_settings, size: 18, color: rolAuditoria == 'admin' ? cOnPrimaryContainer : cOnSurfaceVariant),
                        const SizedBox(width: 6),
                        Text('Admin Central', style: TextStyle(color: rolAuditoria == 'admin' ? cOnPrimaryContainer : cOnSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onCambiarRolAuditoria('store'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: rolAuditoria == 'store' ? acento : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storefront, size: 18, color: rolAuditoria == 'store' ? cOnSecondaryContainer : cOnSurfaceVariant),
                        const SizedBox(width: 6),
                        Text('Tienda Aliada', style: TextStyle(color: rolAuditoria == 'store' ? cOnSecondaryContainer : cOnSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('aud_sync')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: cSurfaceLow, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: cSecondary, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(cfg['titulo']?.toString() ?? 'NODO ORURO CENTRAL • EN LÍNEA', style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700)),
                ],
              ),
              Text(cfg['badge']?.toString() ?? 'Auditoría v2.4', style: const TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      );
    }

    if (idSec.startsWith('aud_escaner')) {
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
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: cPrimaryContainer.withAlpha(102), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.qr_code_scanner, color: cPrimary, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cfg['titulo']?.toString() ?? 'Escáner de Premios', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                          Text(cfg['subtitulo']?.toString() ?? 'Bóveda Santa • Canje Presencial', style: const TextStyle(color: cOnSurfaceVariant, fontSize: 11.5)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: acento.withAlpha(50), borderRadius: BorderRadius.circular(999)),
                    child: Text(cfg['badge']?.toString() ?? 'PUNTO OFICIAL', style: const TextStyle(color: cSecondary, fontSize: 9.5, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.inventory_2, color: cSecondary, size: 20),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Inventario en Sucursal', style: TextStyle(color: cOnSurfaceVariant, fontSize: 10)),
                            Text('Poleras Oficiales 2024', style: TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                    Text('$stockPoleras / 50 disp.', style: const TextStyle(color: cSecondary, fontSize: 16, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 180,
                decoration: BoxDecoration(color: cSurfaceLowest, borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 135,
                      height: 135,
                      decoration: BoxDecoration(
                        border: Border.all(color: acento, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Icon(Icons.center_focus_weak, color: Colors.white38, size: 36)),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () => onSimularEscaneo(),
                        icon: const Icon(Icons.sync, color: cOnSurface),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: cSurfaceHigh.withAlpha(230), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified, color: cSecondary, size: 16),
                                const SizedBox(width: 6),
                                Text(tokenDetectado, style: const TextStyle(color: cOnSurface, fontSize: 10.5, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Text('LISTO', style: TextStyle(color: cPrimary, fontSize: 10, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: acento,
                    foregroundColor: cOnSecondaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => onQuemarPremio(),
                  icon: const Icon(Icons.local_fire_department, size: 20),
                  label: Text(cfg['boton_txt']?.toString() ?? 'Validar y Quemar de la Bóveda', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (rolAuditoria == 'store') return const SizedBox.shrink();

    if (idSec.startsWith('aud_tribunal')) {
      final String imgRecibo = cfg['imagen_url']?.toString() ??
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDKqD9D6jn6MviQ8Pf11VIhyzQCyd4b2ouxe0LcsZFccPvicG1oeid4qnfRSWkVCDGn84VnuhcumhqtrD__EnM89ZxlnPNl5ZFl1bALBeP7kdhNXypla5usVVczZZufuons6BhqXvNY-AKanrrXQUn2mlw6ff36VbTFzqjOWyXUS2jYQ6i6t34oklBQ3y-Ie-7OSZSwErHdMZmEyY-TFwV6jgP2I5oibhpVL0kNKsg';
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
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: cTertiaryContainer.withAlpha(128), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.gavel, color: cTertiary, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cfg['titulo']?.toString() ?? 'Tribunal de Comprobantes', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                          const Text('Verificación cruzada de aportes', style: TextStyle(color: cOnSurfaceVariant, fontSize: 11.5)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: cSurfaceHighest, borderRadius: BorderRadius.circular(999)),
                    child: Text(cfg['badge']?.toString() ?? 'Lote 12 pend.', style: const TextStyle(color: cTertiary, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: cSurfaceLow, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          const Text('RECIBO QR (#BNB-88319)', style: TextStyle(color: cOnSurfaceVariant, fontSize: 9.5, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: InteractiveViewer(
                              child: Image.network(
                                imgRecibo,
                                height: 135,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(height: 135, color: cSurfaceLowest, child: const Icon(Icons.receipt_long, color: cSecondary, size: 40)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: cSurfaceLow, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('DECLARACIÓN', style: TextStyle(color: cOnSurfaceVariant, fontSize: 9.5, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          const Text('Zenón Choque T.', style: TextStyle(color: cOnSurface, fontSize: 13, fontWeight: FontWeight.bold)),
                          const Text('Socio #1842', style: TextStyle(color: cPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: cSurfaceHigh, borderRadius: BorderRadius.circular(6)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Monto Declarado', style: TextStyle(color: cOnSurfaceVariant, fontSize: 10)),
                                Text(cfg['valor_destacado']?.toString() ?? '70.00 BS', style: const TextStyle(color: cSecondary, fontSize: 17, fontWeight: FontWeight.w800)),
                                const Text('Mensualidad', style: TextStyle(color: cOnSurfaceVariant, fontSize: 10)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Match: 100%', style: TextStyle(color: cTertiary, fontSize: 10, fontWeight: FontWeight.bold)),
                              Icon(Icons.check_circle, color: cSecondary, size: 15),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: cErrorContainer, foregroundColor: cOnErrorContainer, padding: const EdgeInsets.symmetric(vertical: 11)),
                      onPressed: () => onToast('Comprobante observado. Se solicitará reingreso.'),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Rechazar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: cPrimary, foregroundColor: cOnPrimary, padding: const EdgeInsets.symmetric(vertical: 11)),
                      onPressed: () => onToast('Aporte verificado y acreditado al Socio #1842'),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Aprobar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final String porcDado = ((dadoProb / 6.0) * 100.0).toStringAsFixed(1);
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
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: acento.withAlpha(65), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.tune, color: cSecondary, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cfg['titulo']?.toString() ?? 'Gestor Paramétrico', style: TextStyle(color: txtCol, fontSize: 18, fontWeight: FontWeight.w700)),
                        const Text('Reglas financieras y algoritmo lúdico', style: TextStyle(color: cOnSurfaceVariant, fontSize: 11.5)),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.lock_reset, color: cOnSurfaceVariant, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            _filaParametro('Cuota Inscripción Nueva', 'Aporte base carnet 2024', '270'),
            const SizedBox(height: 8),
            _filaParametro('Aporte Mensual Ordinario', 'Habilitación voto & sorteos', '70'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: cSurfaceLow, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Probabilidad del Dado Minero', style: TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w600)),
                      Text('$dadoProb en 6 ($porcDado%)', style: const TextStyle(color: cPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: dadoProb.toDouble(),
                    min: 1,
                    max: 6,
                    divisions: 5,
                    activeColor: cPrimary,
                    onChanged: (v) => onCambiarDadoProb(v.round()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: const Text('Regla Dual Automática', style: TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.bold)),
              subtitle: const Text('Aprobación inmediata con auditoría forense posterior.', style: TextStyle(color: cOnSurfaceVariant, fontSize: 11)),
              value: reglaDual,
              activeColor: cPrimary,
              onChanged: (_) => onToggleReglaDual(),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: cPrimaryContainer, foregroundColor: cOnPrimaryContainer, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: () => onToast('Parámetros guardados y replicados en el Parlamento Santo'),
                icon: const Icon(Icons.save, size: 18),
                label: Text(cfg['boton_txt']?.toString() ?? 'Actualizar Parámetros Centrales', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _filaParametro(String tit, String sub, String valBs) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: cSurfaceLow, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tit, style: const TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w600)),
              Text(sub, style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10.5)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: cSurfaceHighest, borderRadius: BorderRadius.circular(6)),
            child: Text('$valBs BS', style: const TextStyle(color: cSecondary, fontSize: 15, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}