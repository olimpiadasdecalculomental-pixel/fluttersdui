import sys
import re
import shutil
import pathlib
import subprocess

LT = chr(60)
GT = chr(62)

def configurar_android():
    logo = pathlib.Path('logo.png')
    res_dir = pathlib.Path('android/app/src/main/res')
    if logo.exists() and res_dir.exists():
        for mipmap in res_dir.glob('mipmap-*'):
            if mipmap.is_dir():
                for nombre in ['ic_launcher.png', 'ic_launcher_round.png']:
                    destino = mipmap / nombre
                    if destino.exists() or nombre == 'ic_launcher.png':
                        shutil.copyfile(logo, destino)

    manifest = pathlib.Path('android/app/src/main/AndroidManifest.xml')
    if manifest.exists():
        txt = manifest.read_text(encoding='utf-8')
        permisos = [
            'android.permission.INTERNET',
            'android.permission.ACCESS_NETWORK_STATE',
            'android.permission.ACCESS_WIFI_STATE',
            'android.permission.BLUETOOTH',
            'android.permission.BLUETOOTH_ADMIN',
            'android.permission.BLUETOOTH_SCAN',
            'android.permission.BLUETOOTH_CONNECT',
            'android.permission.CAMERA',
            'android.permission.RECORD_AUDIO',
            'android.permission.ACCESS_FINE_LOCATION',
            'android.permission.ACCESS_COARSE_LOCATION',
            'android.permission.VIBRATE',
            'android.permission.USE_BIOMETRIC',
        ]
        lineas_xml = ''
        for p in permisos:
            lineas_xml += f'    {LT}uses-permission android:name="{p}"/{GT}\n'
        tag_app = f'{LT}application'
        if 'android.permission.CAMERA' not in txt and tag_app in txt:
            txt = txt.replace(tag_app, lineas_xml + '    ' + tag_app, 1)
            manifest.write_text(txt, encoding='utf-8')

    for ruta_g in ['android/app/build.gradle', 'android/app/build.gradle.kts']:
        gp = pathlib.Path(ruta_g)
        if gp.exists():
            gtxt = gp.read_text(encoding='utf-8')
            gtxt = gtxt.replace('minSdk = flutter.minSdkVersion', 'minSdk = 23')
            gtxt = gtxt.replace('minSdkVersion flutter.minSdkVersion', 'minSdkVersion 23')
            gtxt = gtxt.replace('compileSdk = flutter.compileSdkVersion', 'compileSdk = 35')
            gp.write_text(gtxt, encoding='utf-8')

def escribir_pubspec_garantizado():
    contenido = '''name: motor_universal_flutter
description: SuperApp SDUI Modular por Microservicios (Esquema 3 - Flutter 3.50)
publish_to: 'none'
version: 5.0.0+1

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.2
  shared_preferences: ^2.3.3
  path: ^1.9.0
  crypto: ^3.0.6
  web_socket_channel: ^3.0.1
  latlong2: ^0.9.1
  math_expressions: ^2.6.0
  equations: ^5.0.2
  units_converter: ^3.0.2
  confetti: ^0.8.0
  flutter_animate: ^4.5.0
  flutter_riverpod: ^2.6.1
  drag_and_drop_lists: ^0.4.2
  flutter_svg: ^2.0.14
  pdf: ^3.11.1
  url_launcher: ^6.3.1
  google_generative_ai: ^0.4.6

dependency_overrides:
  petitparser: ^6.0.2
  intl: ^0.19.0
  meta: ^1.15.0
  collection: ^1.18.0
  http: ^1.2.2
  web: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - logo.png
'''
    pathlib.Path('pubspec.yaml').write_text(contenido, encoding='utf-8')

def resolver_pubspec():
    p = pathlib.Path('pubspec.yaml')
    for intento in range(25):
        print(f'=== Intento {intento + 1} de flutter pub get ===')
        res = subprocess.run(['flutter', 'pub', 'get'], capture_output=True, text=True)
        print(res.stdout)
        if res.returncode == 0:
            print('EXITO: flutter pub get completado.')
            return
        err = res.stderr + '\n' + res.stdout
        print(err)
        txt = p.read_text(encoding='utf-8')
        candidatos = re.findall(r'motor_universal_flutter depends on ([a-z0-9_]+)', err)
        if not candidatos:
            m_both = re.search(r'depends on both ([a-z0-9_]+) and ([a-z0-9_]+)', err)
            if m_both:
                candidatos = [m_both.group(2), m_both.group(1)]
        ajustado = False
        for pkg in candidatos:
            if pkg == 'flutter':
                continue
            nuevo = re.sub(rf'^\s+{pkg}:\s*\^?[^\n]+$', f'  # {pkg}: auto-ajustado', txt, flags=re.M)
            if nuevo != txt:
                p.write_text(nuevo, encoding='utf-8')
                print(f'Auto-ajustando paquete en conflicto: {pkg}')
                ajustado = True
                break
        if not ajustado:
            break

    print('Aplicando perfil garantizado de librerias compatibles con Flutter 3.50...')
    escribir_pubspec_garantizado()
    subprocess.run(['flutter', 'pub', 'get'], check=True)

def compilar_apk():
    res = subprocess.run(['flutter', 'build', 'apk', '--release', '--no-tree-shake-icons'])
    if res.returncode != 0:
        print('Recompilando con perfil limpio libre de conflictos NDK/Gradle...')
        escribir_pubspec_garantizado()
        subprocess.run(['flutter', 'pub', 'get'], check=True)
        subprocess.run(['flutter', 'build', 'apk', '--release', '--no-tree-shake-icons'], check=True)

if __name__ == '__main__':
    accion = sys.argv[1] if len(sys.argv) != 1 else 'android'
    if accion == 'android':
        configurar_android()
    elif accion == 'pub':
        resolver_pubspec()
    elif accion == 'apk':
        compilar_apk()