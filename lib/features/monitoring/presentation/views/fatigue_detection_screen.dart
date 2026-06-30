import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/security/token_storage.dart';

// --- CONTROLADOR DE LÓGICA Y TELEMETRÍA ---
class FatigueController extends ChangeNotifier {
  final TokenStorage _tokenStorage = TokenStorage();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Configuración de ML Kit optimizada para rendimiento
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true, // Requerido para probabilidad de ojos
      performanceMode: FaceDetectorMode.fast, // Priorizar velocidad/batería
    ),
  );

  // Estados de detección de parpadeo
  bool _isEyesClosed = false;
  DateTime? _blinkStart;
  final List<DateTime> _longBlinksTimestamps = []; // Ventana móvil (Sliding Window)

  // Métricas en tiempo real
  int duracionParpadeoMs = 0;
  double longBlinksPerMin = 0.0;
  String nivelFatiga = "Verde";
  bool _isAlarmPlaying = false;

  // Control de envío al Backend
  Timer? _periodicTimer;
  final String _baseUrl = "http://173.212.202.138:8080";

  FatigueController() {
    // Regla: Envío automático cada 30 segundos
    _periodicTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _sendTelemetryToBackend();
    });
    
    // Configurar el audio para que se repita
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  /// Procesa el rostro detectado por ML Kit
  void processFace(Face face) {
    final double? leftOpenProb = face.leftEyeOpenProbability;
    final double? rightOpenProb = face.rightEyeOpenProbability;

    if (leftOpenProb == null || rightOpenProb == null) return;

    // LÓGICA DE ALGORITMO DE TELEMETRÍA
    // Umbral de cierre: < 0.2
    if (!_isEyesClosed && leftOpenProb < 0.2 && rightOpenProb < 0.2) {
      _isEyesClosed = true;
      _blinkStart = DateTime.now();
    } 
    // Umbral de apertura: > 0.6
    else if (_isEyesClosed && leftOpenProb > 0.6 && rightOpenProb > 0.6) {
      _isEyesClosed = false;
      if (_blinkStart != null) {
        final DateTime end = DateTime.now();
        duracionParpadeoMs = end.difference(_blinkStart!).inMilliseconds;
        
        _analyzeBlink(duracionParpadeoMs);
        notifyListeners();
      }
    }
  }

  void _analyzeBlink(int duration) {
    // Si el parpadeo es lento (> 300ms), es signo de fatiga
    if (duration > 300) {
      _longBlinksTimestamps.add(DateTime.now());
      nivelFatiga = duration > 500 ? "Rojo" : "Amarillo";
      
      // DISPARAR ALARMA SI ES ROJO (Estado Crítico)
      if (nivelFatiga == "Rojo") {
        playAlarm();
      }

      // Regla: Envío inmediato si se detecta parpadeo lento
      _sendTelemetryToBackend();
    } else {
      nivelFatiga = "Verde";
      stopAlarm(); // Detener alarma si el estado vuelve a ser normal
    }

    _updateSlidingWindow();
  }

  /// Inicia la alarma sonora a volumen máximo
  Future<void> playAlarm() async {
    if (_isAlarmPlaying) return;
    try {
      _isAlarmPlaying = true;
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('audio/alarm.mp3'));
      debugPrint(">>> NeuroDrive: ALARMA ACTIVADA <<<");
    } catch (e) {
      debugPrint("Error al reproducir alarma: $e");
    }
  }

  /// Detiene la alarma sonora
  Future<void> stopAlarm() async {
    if (!_isAlarmPlaying) return;
    try {
      await _audioPlayer.stop();
      _isAlarmPlaying = false;
      debugPrint(">>> NeuroDrive: Alarma desactivada");
    } catch (e) {
      debugPrint("Error al detener alarma: $e");
    }
  }

  /// Mantiene solo los parpadeos de los últimos 60 segundos
  void _updateSlidingWindow() {
    final now = DateTime.now();
    _longBlinksTimestamps.removeWhere(
      (timestamp) => now.difference(timestamp).inSeconds > 60
    );
    longBlinksPerMin = _longBlinksTimestamps.length.toDouble();
  }

  /// Envío al Backend en Go
  Future<void> _sendTelemetryToBackend() async {
    try {
      final token = await _tokenStorage.getToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse("$_baseUrl/log-alertas"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "id_dispositivo": 1,
          "nivel_fatiga": nivelFatiga,
          "duracion_parpadeo_ms": duracionParpadeoMs,
          "long_blinks_per_min": longBlinksPerMin
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(">>> NeuroDrive: Telemetría enviada ($nivelFatiga)");
      }
    } catch (e) {
      debugPrint(">>> Error enviando telemetría: $e");
    }
  }

  @override
  void dispose() {
    _faceDetector.close();
    _periodicTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

// --- PANTALLA PRINCIPAL ---
class FatigueDetectionScreen extends StatefulWidget {
  const FatigueDetectionScreen({super.key});

  @override
  State<FatigueDetectionScreen> createState() => _FatigueDetectionScreenState();
}

class _FatigueDetectionScreenState extends State<FatigueDetectionScreen> {
  CameraController? _cameraController;
  final FatigueController _controller = FatigueController();
  bool _isProcessing = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => _hasPermission = true);
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front
    );

    _cameraController = CameraController(
      frontCam,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    try {
      await _cameraController!.initialize();
      _cameraController!.startImageStream((image) {
        if (_isProcessing) return;
        _isProcessing = true;
        _processCameraImage(image);
      });
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error inicializando cámara: $e");
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    final inputImage = _convertCameraImage(image);
    if (inputImage == null) {
      _isProcessing = false;
      return;
    }

    try {
      final faces = await _controller._faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) {
        _controller.processFace(faces.first);
      }
    } catch (e) {
      debugPrint("Error procesando imagen: $e");
    } finally {
      _isProcessing = false;
    }
  }

  InputImage? _convertCameraImage(CameraImage image) {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation270deg,
        format: Platform.isAndroid ? InputImageFormat.nv21 : InputImageFormat.bgra8888,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return const Scaffold(body: Center(child: Text("Se requiere permiso de cámara")));
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),

          // HUD DE TELEMETRÍA
          Positioned(
            bottom: 40, left: 20, right: 20,
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                final isCritical = _controller.nivelFatiga == "Rojo";
                final statusColor = _controller.nivelFatiga == "Verde" 
                    ? Colors.greenAccent 
                    : (isCritical ? Colors.redAccent : Colors.orangeAccent);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isCritical 
                        ? Colors.red.withValues(alpha: 0.8) 
                        : Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: statusColor, width: isCritical ? 4 : 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCritical) ...[
                        const Icon(Icons.warning_rounded, color: Colors.white, size: 48),
                        const Text(
                          "¡ALERTA DE FATIGA!",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHUDMetric("ESTADO", _controller.nivelFatiga, isCritical ? Colors.white : statusColor),
                          _buildHUDMetric("PARPADEO", "${_controller.duracionParpadeoMs} ms", isCritical ? Colors.white : Colors.cyanAccent),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 8),
                      Text(
                        "MICRO-SUEÑOS (ÚLT. MINUTO): ${_controller.longBlinksPerMin.toInt()}",
                        style: TextStyle(
                          color: isCritical ? Colors.white : Colors.white70, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 16
                        ),
                      ),
                      if (isCritical) 
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                            onPressed: () => _controller.stopAlarm(),
                            child: const Text("DETENER ALARMA", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHUDMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.2)),
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w900)),
      ],
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _controller.dispose();
    super.dispose();
  }
}
