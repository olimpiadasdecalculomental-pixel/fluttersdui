import 'dart:async';
import 'dart:convert';
import 'dart:io';

const String SUPABASE_URL = 'https://alxbydjpoxoavasklwpd.supabase.co';
const String SUPABASE_KEY = 'sb_publishable_Kc8wekwUqIs78ILNF-j-Qg_LNMYRhn0';

class PuenteSupabaseSdui {
  static File archivoCacheLocal() {
    return File('${Directory.systemTemp.path}/cache_contrato_esq3_ms.json');
  }

  static Future ejecutarRpcUniversal(String nombreRpc, Map payload) async {
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

  static Future leerContratoCacheado() async {
    try {
      final f = archivoCacheLocal();
      if (await f.exists()) {
        final txt = await f.readAsString();
        if (txt.isNotEmpty) {
          return Map.from(jsonDecode(txt) as Map);
        }
      }
    } catch (_) {}
    return null;
  }

  static Future sincronizarConNube() async {
    final check = await ejecutarRpcUniversal('esq3_rpc_verificar_version', {
      'p_modulo': 'MODULO_MAESTRO_V1',
      'p_version_cliente': 0,
    });
    if (check['requiere_descarga'] == true && check['contrato'] != null) {
      final nuevoContrato = Map.from(check['contrato'] as Map);
      try {
        await archivoCacheLocal().writeAsString(jsonEncode(nuevoContrato));
      } catch (_) {}
      return nuevoContrato;
    }
    return null;
  }
}