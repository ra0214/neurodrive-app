import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/providers/global_providers.dart';

class FatigueDetectionScreen extends ConsumerStatefulWidget {
  const FatigueDetectionScreen({super.key});

  @override
  ConsumerState<FatigueDetectionScreen> createState() => _FatigueDetectionScreenState();
}

class _FatigueDetectionScreenState extends ConsumerState<FatigueDetectionScreen> {
  CameraController? _cameraController;
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
      if (mounted) setState(() => _hasPermission = true);
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
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
      final controller = ref.read(fatigueControllerProvider);
      final faces = await controller.faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) {
        controller.processFace(faces.first);
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
    final controller = ref.watch(fatigueControllerProvider);
    
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
          _buildHUD(controller),
        ],
      ),
    );
  }

  Widget _buildHUD(dynamic controller) {
    final isCritical = controller.nivelFatiga == "Rojo";
    final statusColor = controller.nivelFatiga == "Verde" 
        ? Colors.greenAccent 
        : (isCritical ? Colors.redAccent : Colors.orangeAccent);

    return Positioned(
      bottom: 40, left: 20, right: 20,
      child: AnimatedContainer(
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
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)
              ),
              const SizedBox(height: 16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric("ESTADO", controller.nivelFatiga, isCritical ? Colors.white : statusColor),
                _buildMetric("PARPADEO", "${controller.duracionParpadeoMs} ms", isCritical ? Colors.white : Colors.cyanAccent),
              ],
            ),
            const SizedBox(height: 16),
            if (isCritical) 
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red),
                  onPressed: () => controller.stopAlarm(),
                  child: const Text("DETENER ALARMA", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
