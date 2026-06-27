import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:safe_device/safe_device.dart';

class SecurityService {
  static const _channel = MethodChannel('com.neurodrive.security/checks');

  /// Configura la protección contra capturas de pantalla (Solo Android)
  static Future<void> setupScreenProtection() async {
    if (kIsWeb) return; // No hace nada en Web
    
    try {
      // Usamos defaultTargetPlatform para evitar errores de dart:io en Web
      if (defaultTargetPlatform == TargetPlatform.android) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      }
    } catch (e) {
      debugPrint('Error configurando protección de pantalla: $e');
    }
  }

  /// Verifica si el dispositivo es seguro (Solo Móvil)
  static Future<String?> checkDeviceSecurity() async {
    if (kDebugMode || kIsWeb) return null; // No bloquea en modo Debug o Web

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final bool? isUsbDebuggingEnabled = await _channel.invokeMethod<bool>('isUsbDebuggingEnabled');
        if (isUsbDebuggingEnabled == true) {
          return 'Se ha detectado la Depuración USB activa. Por políticas de seguridad, debe desactivarla.';
        }
      }

      final bool isMockLocation = await SafeDevice.isMockLocation;
      if (isMockLocation) {
        return 'Se ha detectado el uso de Fake GPS.';
      }
    } catch (e) {
      debugPrint('Error en la verificación de seguridad: $e');
    }

    return null;
  }
}
