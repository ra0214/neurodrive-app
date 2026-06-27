import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:safe_device/safe_device.dart';

class SecurityService {
  static const _channel = MethodChannel('com.neurodrive.security/checks');

  /// Configura la protección contra capturas de pantalla y grabaciones.
  static Future<void> setupScreenProtection() async {
    try {
      if (Platform.isAndroid) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      }
    } catch (e) {
      debugPrint('Error configurando protección de pantalla: $e');
    }
  }

  /// Verifica si el dispositivo es seguro para ejecutar la aplicación.
  static Future<String?> checkDeviceSecurity() async {
    if (kDebugMode) return null;

    try {
      // 1. Verificar Depuración USB (Android)
      if (Platform.isAndroid) {
        final bool? isUsbDebuggingEnabled = await _channel.invokeMethod<bool>('isUsbDebuggingEnabled');
        if (isUsbDebuggingEnabled == true) {
          return 'Se ha detectado la Depuración USB activa. Por políticas de seguridad, debe desactivarla en los ajustes del sistema para continuar.';
        }
      }

      // 2. Verificar Fake GPS
      final bool isMockLocation = await SafeDevice.isMockLocation;
      if (isMockLocation) {
        return 'Se ha detectado el uso de ubicaciones simuladas (Fake GPS). El uso de estas herramientas no está permitido.';
      }

      // 3. Verificar Root/Jailbreak
      final bool isJailBroken = await SafeDevice.isJailBroken;
      if (isJailBroken) {
        return 'Este dispositivo no cumple con los requisitos de seguridad (Root/Jailbreak detectado).';
      }

    } catch (e) {
      debugPrint('Error en la verificación de seguridad: $e');
    }

    return null;
  }
}
