import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:safe_device/safe_device.dart';

class SecurityService {
  static const _channel = MethodChannel('com.neurodrive.security/checks');

  /// Configura la protección contra capturas de pantalla
  static Future<void> setupScreenProtection() async {
    if (kIsWeb) return; 
    
    try {
      // screen_protector es compatible con tu versión de Flutter
      await ScreenProtector.preventScreenshotOn();
    } catch (e) {
      debugPrint('Error configurando protección de pantalla: $e');
    }
  }

  /// Verifica si el dispositivo es seguro (Solo Móvil)
  static Future<String?> checkDeviceSecurity() async {
    if (kDebugMode || kIsWeb) return null;

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
