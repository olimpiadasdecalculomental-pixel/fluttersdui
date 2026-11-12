import 'dart:convert';
import 'package:flutter/material.dart';
import 'puente_supabase_sdui.dart';

class ModalesCandadoYEditor {
  static void abrirCandadoNegroCamuflado({
    required BuildContext context,
    required Function alDesbloquearAdmin,
  }) {
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
                  onPressed: () {
                    Navigator.pop(ctx);
                    final limpia = clave.trim();
                    if (limpia == '?1942?' || limpia == '1942?' || limpia == '1942') {
                      alDesbloquearAdmin();
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

  static void abrirModalEditorJson({
    required BuildContext context,
    required Map contratoActual,
    required Function(Map) alActualizarContrato,
    required Function(String) alMostrarFeedback,
  }) {
    final ctrl = TextEditingController(text: const JsonEncoder.withIndent('  ').convert(contratoActual));
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
                    alActualizarContrato(nuevo);
                    await PuenteSupabaseSdui.ejecutarRpcUniversal('esq3_rpc_actualizar_sdui', {
                      'p_modulo': 'MODULO_MAESTRO_V1',
                      'p_nuevo_json': nuevo
                    });
                    if (ctx.mounted) Navigator.pop(ctx);
                  } catch (e) {
                    alMostrarFeedback('❌ Error JSON: $e');
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
}