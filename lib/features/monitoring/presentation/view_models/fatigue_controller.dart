import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/security/token_storage.dart';
import '../../data/sources/monitoring_api_service.dart';
import '../../data/models/monitoring_models.dart';

class FatigueController extends ChangeNotifier {
  final MonitoringApiService _apiService;
  final TokenStorage _tokenStorage = TokenStorage();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  String nivelFatiga = "Verde";
  int duracionParpadeoMs = 0;
  double longBlinksPerMin = 0.0;
  bool _isAlarmPlaying = false;
  
  DateTime? _blinkStart;
  bool _isEyesClosed = false;
  final List<DateTime> _longBlinksTimestamps = [];

  FatigueController(this._apiService) {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    Timer.periodic(const Duration(seconds: 30), (_) => _sendInference());
  }

  void processFace(Face face) {
    final double? leftOpen = face.leftEyeOpenProbability;
    final double? rightOpen = face.rightEyeOpenProbability;
    if (leftOpen == null || rightOpen == null) return;

    if (!_isEyesClosed && leftOpen < 0.2 && rightOpen < 0.2) {
      _isEyesClosed = true;
      _blinkStart = DateTime.now();
    } else if (_isEyesClosed && leftOpen > 0.6 && rightOpen > 0.6) {
      _isEyesClosed = false;
      if (_blinkStart != null) {
        duracionParpadeoMs = DateTime.now().difference(_blinkStart!).inMilliseconds;
        _analyzeBlink(duracionParpadeoMs);
        notifyListeners();
      }
    }
  }

  void _analyzeBlink(int duration) {
    if (duration > 300) {
      _longBlinksTimestamps.add(DateTime.now());
      if (duration > 500) {
        playAlarm();
      }
      _sendInference();
    } else {
      // SI EL PARPADEO ES NORMAL, DETENEMOS LA ALARMA
      stopAlarm();
    }
    _updateSlidingWindow();
  }

  Future<void> _sendInference() async {
    final idChofer = await _tokenStorage.getUserId();
    if (idChofer == null) return;

    try {
      final request = FatigueInferenceRequest(
        idChofer: idChofer,
        blinkDurationMs: duracionParpadeoMs.toDouble(),
        longBlinksPerMin: longBlinksPerMin,
        perclos1m: 0.1,
        earAvg: 0.3,
        earVariance: 0.02,
        eyelidClosingVel: 0.1,
        eyelidOpeningVel: 0.1,
        microsleepCount: 0,
        headPitchAvg: 0.0,
        headPitchVar: 0.0,
        headYawVar: 0.0,
        headRollVar: 0.0,
        headDropRate: 0,
        gazePitchVar: 0.0,
        gazeYawVar: 0.0,
        fixationDurationAvg: 300.0,
        saccadeFrequency: 1.0,
        pupilSizeVar: 0.01,
      );

      final response = await _apiService.inferFatiga(request);
      nivelFatiga = response.riskLevel;
      
      // SI EL SERVIDOR DICE QUE TODO ESTÁ BIEN, DETENEMOS ALARMA
      if (nivelFatiga.toLowerCase().contains("verde") || nivelFatiga.toLowerCase().contains("bajo")) {
        stopAlarm();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint("Error en inferencia: $e");
    }
  }

  Future<void> playAlarm() async {
    if (_isAlarmPlaying) return;
    _isAlarmPlaying = true;
    try {
      await _audioPlayer.play(AssetSource('audio/alarm.mp3'));
    } catch (e) {
      _isAlarmPlaying = false;
    }
  }

  Future<void> stopAlarm() async {
    if (!_isAlarmPlaying) return;
    await _audioPlayer.stop();
    _isAlarmPlaying = false;
    notifyListeners();
  }

  void _updateSlidingWindow() {
    final now = DateTime.now();
    _longBlinksTimestamps.removeWhere((t) => now.difference(t) > const Duration(minutes: 1));
    longBlinksPerMin = _longBlinksTimestamps.length.toDouble();
  }

  @override
  void dispose() {
    faceDetector.close();
    _audioPlayer.dispose();
    super.dispose();
  }
}
