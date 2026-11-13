import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Ms11StitchDiseno1Muro extends StatefulWidget {
  final Map bloque;
  const Ms11StitchDiseno1Muro({super.key, required this.bloque});

  @override
  State createState() => _Ms11StitchDiseno1MuroState();
}

class _Ms11StitchDiseno1MuroState extends State with SingleTickerProviderStateMixin {
  late AnimationController _vinylCtrl;
  bool _isLiked = false;
  bool _isFollowed = false;
  bool _showDiceModal = false;
  bool _showAnonTooltip = false;
  bool _spinningDice = false;
  int _diceValue = 6;
  int _navIndex = 0;

  static const Color cSurface = Color(0xFF071326);
  static const Color cSurfaceLowest = Color(0xFF030E21);
  static const Color cSurfaceLow = Color(0xFF101C2F);
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
    _vinylCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _vinylCtrl.dispose();
    super.dispose();
  }

  void _lanzarDadoStitch() {
    HapticFeedback.mediumImpact();
    setState(() => _spinningDice = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      final rnd = math.Random().nextInt(6) + 1;
      setState(() {
        _spinningDice = false;
        _diceValue = rnd;
        _showDiceModal = true;
      });
      HapticFeedback.heavyImpact();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map b = widget.bloque;
    final String avatarUrl = b['avatar_perfil_url']?.toString() ??
        'https://lh3.googleusercontent.com/aida/ALJJyrDJc05woFyW27izHWa68BsjEXCpRu6P4FlsytinWUlclP0ZD1zMKHXSdNpEFMS4m85L3AdI2m37GhWhAbJc_tqIwRNAZ6AmYPVlOy9bNXT25drLVeXaiHEa-3pcW2KvcvSnXz8oyBHN2bH0BGt6MVQCEkEd6BBijq1EQQdQa6I7tIZZug6lhpytkn2ai31KTmgPOgA99xT_M8mVOkQZ7MGa68wTRzPRxBbeHvFi7E8E';
    final String videoBgUrl = b['video_bg_url']?.toString() ??
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAzkbVETd8U6n0rkXQSMlREA8aZEjR18epUA2BD_YO7PAL4VW15ANS8bUKder-D7btF1xcS_yZTr4LyqSgc-LouZ2HOgc9za70VxcrVygqOZTmF-XfzJUF5GUkNafJhnSC0WG9slLpBR1OW7CphxQfZespFPWuHCse5i1eIcWIrPGZuHO0YJzE6jAhOU1biLZdyvjcnbD8qCEqcLKKw7Wa9o0WWVfqKERfhl3RcM8k';
    final String escudoUrl = b['escudo_club_url']?.toString() ??
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAo2s6PA4vlfi1cXQO0XuPKWqXOrLWVSyZCGRyilUjqdxm3_wj6EGnm6V9PFHPT74DjP6uQfbP0AEOKYTLhgtt2Oe9v0dEBRRmmgiRN0WXlZQIp-Bv3iMGsI6cbW4kuRXjuGaKmaOGwGiDBTutUtm-Sp-LjUlbkrr48-LhNb3__6f-K5pz_2scJ7bdu3n_NAOrbDMNJaqqLd31Pvl6bfw9sT54bxGN7wXCap5_h170';

    final double topPad = MediaQuery.of(context).padding.top;
    final double botPad = MediaQuery.of(context).padding.bottom;

    return Container(
      color: cSurface,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: topPad + 64 + 6,
                bottom: botPad + 92,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. TOP FLOATING HUD: LANZAMIENTO ACTIVO + EL MIRON
                  Padding(
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
                            boxShadow: [
                              BoxShadow(color: Colors.black.withAlpha(70), blurRadius: 12, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.casino, color: cSecondaryContainer, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                (b['hud_titulo']?.toString() ?? 'LANZAMIENTO ACTIVO').toUpperCase(),
                                                style: const TextStyle(
                                                  color: cSecondary,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.6,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: const BoxDecoration(
                                                  color: cSecondaryContainer,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 1),
                                          RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              style: const TextStyle(fontSize: 12, color: cOnSurfaceVariant),
                                              children: [
                                                TextSpan(
                                                  text: b['hud_pts']?.toString() ?? '+40 pts',
                                                  style: const TextStyle(color: cSecondaryFixed, fontWeight: FontWeight.bold),
                                                ),
                                                const TextSpan(text: ' acumulados • '),
                                                TextSpan(
                                                  text: b['hud_device']?.toString() ?? '#89F2A',
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
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _showAnonTooltip = !_showAnonTooltip);
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: cSurfaceContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.visibility_off_outlined, color: cTertiary, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'El Mirón',
                                        style: TextStyle(color: cTertiary, fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 2. MAIN VERTICAL VIDEO VIEWPORT (9:16 FULL CARD EXPERIENCE)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 590),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withAlpha(140), blurRadius: 24, offset: const Offset(0, 8)),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                videoBgUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xFF002855), Color(0xFF071326)],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.sports_soccer, color: cSecondary, size: 64),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      cSurface,
                                      Colors.transparent,
                                      cSurface.withAlpha(178),
                                    ],
                                    stops: const [0.0, 0.45, 1.0],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      cSurface.withAlpha(102),
                                      Colors.transparent,
                                      cSurface.withAlpha(153),
                                    ],
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
                                      decoration: BoxDecoration(
                                        color: cSurfaceLowest.withAlpha(178),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(color: cError, shape: BoxShape.circle),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            b['badge_vivo']?.toString() ?? 'EN VIVO BERMÚDEZ',
                                            style: const TextStyle(
                                              color: cOnSurface,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: cSurfaceHigh.withAlpha(153),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.equalizer, color: cSecondary, size: 16),
                                          const SizedBox(width: 6),
                                          Text(
                                            b['badge_audio']?.toString() ?? 'AUDIO HISTÓRICO',
                                            style: const TextStyle(
                                              color: cOnSurfaceVariant,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
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
                                  mainAxisSize: MainAxisSize.min,
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
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [cSecondary, cPrimary, cSurface],
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                escudoUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Image.asset(
                                                  'logo.png',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: cSecondary),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                HapticFeedback.selectionClick();
                                                setState(() => _isFollowed = !_isFollowed);
                                              },
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: _isFollowed ? cSurfaceBright : cSecondaryContainer,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  _isFollowed ? Icons.done : Icons.add,
                                                  size: 14,
                                                  color: _isFollowed ? cSecondary : cOnSecondaryContainer,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        setState(() => _isLiked = !_isLiked);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: cSurfaceHigh.withAlpha(178),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _isLiked ? Icons.favorite : Icons.favorite_border,
                                              color: _isLiked ? cError : cOnSurface,
                                              size: 26,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _isLiked ? (b['likes_activo']?.toString() ?? '14.3k') : (b['likes_inicial']?.toString() ?? '14.2k'),
                                            style: const TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Column(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: cSurfaceHigh.withAlpha(178),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.chat_bubble, color: cOnSurface, size: 22),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          b['comentarios_count']?.toString() ?? '842',
                                          style: const TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Column(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: cSurfaceHigh.withAlpha(178),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.share, color: cOnSurface, size: 22),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          b['compartidos_count']?.toString() ?? '3.1k',
                                          style: const TextStyle(color: cOnSurface, fontSize: 12, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: Stack(
                                        children: [
                                          RotationTransition(
                                            turns: _vinylCtrl,
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: cSurfaceLowest,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.album, color: cSecondary, size: 22),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: const BoxDecoration(
                                                color: cSecondaryContainer,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.music_note, color: cOnSecondaryContainer, size: 9),
                                            ),
                                          ),
                                        ],
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          b['autor_handle']?.toString() ?? '@clubsanjose_oficial',
                                          style: const TextStyle(
                                            color: cOnSurface,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.verified, color: cPrimary, size: 18),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        style: const TextStyle(color: cOnSurface, fontSize: 14, height: 1.35),
                                        children: [
                                          TextSpan(
                                            text: b['video_caption']?.toString() ??
                                                '¡Gol agónico en Oruro! Ruge el gigante de los Andes ⚽💙 ',
                                          ),
                                          TextSpan(
                                            text: b['video_hashtags']?.toString() ??
                                                '#SanJose #OruroEsSanto #OrgulloSanto',
                                            style: const TextStyle(
                                              color: cSecondaryFixed,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.graphic_eq, color: cSecondary, size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Banda Poopó - Morenada Central de San José (Audio Oficial)',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: cOnSurfaceVariant,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
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
                  ),

                  // 3. INTERACTIVE GAMIFIED FLOATING CENTERPIECE: "TIRAR DADO SANTO"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [cPrimaryContainer, cSurfaceHigh, cSurfaceContainer],
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(90), blurRadius: 16, offset: const Offset(0, 6)),
                        ],
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
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [cSecondary, cSecondaryContainer, cOnSecondaryContainer],
                                          ),
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
                                                child: Text(
                                                  b['dado_titulo']?.toString() ?? 'Tirar Dado Santo',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: cOnSurface,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: cSecondaryContainer,
                                                  borderRadius: BorderRadius.circular(999),
                                                ),
                                                child: Text(
                                                  (b['dado_badge']?.toString() ?? '1 AL 6').toUpperCase(),
                                                  style: const TextStyle(
                                                    color: cOnSecondaryContainer,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            b['dado_subtitulo']?.toString() ??
                                                '¡Sube tu captura y gana puntos y cupones instantáneos!',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: cOnSurfaceVariant, fontSize: 11.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cSecondaryContainer,
                                  foregroundColor: cOnSecondaryContainer,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                ),
                                onPressed: _lanzarDadoStitch,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Lanzar', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                                    SizedBox(width: 4),
                                    Icon(Icons.touch_app, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                b['progreso_texto']?.toString() ?? 'Próxima recompensa épica (Camiseta Oficial)',
                                style: const TextStyle(color: cOnSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                b['progreso_tiros']?.toString() ?? '4/6 Tiros',
                                style: const TextStyle(color: cSecondary, fontSize: 10, fontWeight: FontWeight.w800),
                              ),
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
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [cPrimary, cSecondaryContainer],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FIXED TOP HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: EdgeInsets.only(top: topPad, left: 16, right: 16),
                  height: topPad + 64,
                  decoration: BoxDecoration(
                    color: cSurface.withAlpha(216),
                    boxShadow: [
                      BoxShadow(color: cSurfaceLowest.withAlpha(153), blurRadius: 24, offset: const Offset(0, 4)),
                    ],
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
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [cSecondaryContainer, cPrimary, Colors.transparent],
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                avatarUrl,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'logo.png',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.person, color: cOnSurface, size: 24),
                                ),
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
                                    b['header_titulo']?.toString() ?? 'SAN JOSÉ',
                                    style: const TextStyle(
                                      color: cOnSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    b['header_anio']?.toString() ?? '1942',
                                    style: const TextStyle(
                                      color: cPrimary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: cSecondary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    b['header_rango']?.toString() ?? 'SOCIO VIP',
                                    style: const TextStyle(
                                      color: cSecondaryContainer,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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
                            decoration: BoxDecoration(
                              color: cSurfaceHigh.withAlpha(230),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.stars, color: cSecondaryContainer, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  b['header_puntos']?.toString() ?? '350',
                                  style: const TextStyle(
                                    color: cOnSurface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Text(
                                  'pts',
                                  style: TextStyle(
                                    color: cSecondaryContainer,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.verified_user_outlined, color: cOnSurfaceVariant, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // TOOLTIP MODAL: MODO ANONIMO (EL MIRON)
          if (_showAnonTooltip)
            Positioned(
              top: topPad + 76,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cSurfaceHigh,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(160), blurRadius: 24, offset: const Offset(0, 8)),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cTertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.shield_outlined, color: cOnTertiaryContainer, size: 24),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Modo Anónimo (El Mirón)',
                                style: TextStyle(color: cOnSurface, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              InkWell(
                                onTap: () => setState(() => _showAnonTooltip = false),
                                child: const Icon(Icons.close, color: cOnSurfaceVariant, size: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: cOnSurfaceVariant, fontSize: 12, height: 1.4),
                              children: [
                                TextSpan(
                                  text: 'Estás navegando sin vincular tu número de socio oficial. Tus puntos de transmisión y cupones de dados se reservan en el dispositivo temporal ',
                                ),
                                TextSpan(
                                  text: '#89F2A',
                                  style: TextStyle(color: cSecondary, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '.'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Protección anti-rastreo activa',
                                style: TextStyle(color: cOutline, fontSize: 10, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'ASOCIAR A MI CARNET',
                                style: TextStyle(
                                  color: cSecondaryContainer,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                ),
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

          // INTERACTIVE DICE RESULT MODAL
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
                    decoration: BoxDecoration(
                      color: cSurfaceHigh,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(180), blurRadius: 28),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: cSecondaryContainer,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: cSecondaryContainer.withAlpha(90), blurRadius: 20),
                            ],
                          ),
                          child: Text(
                            '$_diceValue',
                            style: const TextStyle(
                              color: cOnSecondaryContainer,
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '¡TIRO PERFECTO!',
                          style: TextStyle(
                            color: cSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '¡Ganaste +120 Puntos!',
                          style: TextStyle(
                            color: cOnSurface,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cupón desbloqueado: 20% de descuento en la Tienda Oficial Calle Bolívar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cOnSurfaceVariant, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cPrimaryContainer,
                              foregroundColor: cOnPrimaryContainer,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => setState(() => _showDiceModal = false),
                            child: const Text(
                              'Guardar en mi Bóveda',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // FIXED BOTTOM NAVIGATION BAR
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
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF002855).withAlpha(76), blurRadius: 24, offset: const Offset(0, -4)),
                    ],
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
        width: 64,
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
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badgeTxt,
                        style: TextStyle(color: badgeFg, fontSize: 8.5, fontWeight: FontWeight.w800),
                      ),
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
            Text(
              label,
              style: TextStyle(
                color: col,
                fontSize: 10,
                fontWeight: activo ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}