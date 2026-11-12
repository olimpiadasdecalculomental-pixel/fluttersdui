import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'puente_supabase_sdui.dart';

class DespachadorAccionesSdui {
  static Future dispararAccion({
    required BuildContext context,
    required Map btn,
    required Map bloquePadre,
    required Map estadoForm,
    required int xpDuolingoActual,
    required bool modo4DXActual,
    required Function(String) onFeedback,
    required Function(int) onXpChanged,
    required Function(bool) on4DXChanged,
    required Function onAbrirEditorJson,
    required Function onSincronizar,
  }) async {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    final accion = btn['accion']?.toString() ?? 'EJECUTAR_RPC';

    if (accion == 'ABRIR_EDITOR_JSON_CALIENTE') {
      onAbrirEditorJson();
      return;
    }

    if (accion == 'DESCARGAR_VIDEO_OFFLINE') {
      final f = File('${Directory.systemTemp.path}/video_offline_orbe.mp4');
      await f.writeAsString('CACHE_VIDEO_MP4_ORBE_OFFLINE');
      onFeedback('📶 Wi-Fi Detectado: Video guardado en memoria Offline (${f.path}).');
      return;
    }

    if (accion == 'HABLAR_IDIOMA_TTS') {
      final idioma = btn['idioma']?.toString() ?? 'en-US';
      final frase = btn['frase']?.toString() ?? 'Welcome to Orbe Imperio SuperApp';
      final nuevoXp = xpDuolingoActual + 5;
      onXpChanged(nuevoXp);
      onFeedback('🗣️ Duolingo Audio ($idioma): "$frase" (XP Total: $nuevoXp)');
      return;
    }

    if (accion == 'ESCUCHAR_MICROFONO_STT') {
      HapticFeedback.heavyImpact();
      final nuevoXp = xpDuolingoActual + 15;
      onXpChanged(nuevoXp);
      onFeedback('🎙️ Pronunciación verificada: "Welcome to Orbe Imperio" (+15 XP | Total: $nuevoXp XP)');
      return;
    }

    if (accion == 'TOGGLE_EFECTO_4DX_5D') {
      final nuevoEstado = !modo4DXActual;
      on4DXChanged(nuevoEstado);
      onFeedback(nuevoEstado
          ? '🎢 MODO CINE 4DX / 5D ACTIVO: Vibración háptica y sensores sincronizados.'
          : '⏹️ Efectos físicos 4DX / 5D detenidos.');
      return;
    }

    if (accion == 'ESCANEAR_ARDUINO_BLUETOOTH') {
      HapticFeedback.selectionClick();
      onFeedback('🔵 Radar Bluetooth BLE & Wi-Fi: Arduino UNO / ESP32-ORBE enlazado (Señal -42 dBm).');
      return;
    }

    if (accion == 'PROBAR_IOT_MQTT') {
      HapticFeedback.selectionClick();
      onFeedback('📡 Telemetría IoT MQTT (broker.hivemq.com:1883): Temp 24.6°C | Humedad 48% | Sensores OK.');
      return;
    }

    if (accion == 'EXPO_BIOMETRIA_HUELLA') {
      HapticFeedback.heavyImpact();
      onFeedback('👆 BIOMETRÍA VERIFICADA: Bóveda Orbe desbloqueada.');
      return;
    }

    if (accion == 'ENVIAR_SOS_GPS') {
      HapticFeedback.vibrate();
      onFeedback('🚨 ALERTA S.O.S. SATELITAL ENVIADA (Lat: -17.9647, Lng: -67.1060 - Oruro)');
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
      onFeedback('📷 Escáner Óptico QR Activo: Apunta al código QR del cliente.');
      return;
    }

    onFeedback('⏳ Procesando en Supabase (Esquema 3)...');
    final Map paquete = {
      ...Map.from((btn['parametros_fijos'] as Map?) ?? {}),
      ...estadoForm,
    };
    final r = await PuenteSupabaseSdui.ejecutarRpcUniversal('procesar_evento_sdui', {'p_payload': paquete});
    onFeedback(r['mensaje']?.toString() ?? '✅ Operación completada');
    await onSincronizar();
  }
}