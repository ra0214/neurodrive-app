import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmergencyAlertScreen extends StatelessWidget {
  final String operatorName;
  final DateTime incidentTime;

  const EmergencyAlertScreen({
    super.key, 
    this.operatorName = "Carlos Mendoza", 
    required this.incidentTime,
  });

  @override
  Widget build(BuildContext context) {
    final String timeFormatted = DateFormat('HH:mm:ss').format(incidentTime);

    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C), // Rojo intenso de alerta
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 100, color: Colors.yellowAccent),
              const SizedBox(height: 24),
              const Text(
                '¡ALERTA CRÍTICA!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white30),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Se ha detectado somnolencia crítica en el operador:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      operatorName.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.white24, height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, color: Colors.yellowAccent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Hora del incidente: $timeFormatted',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Botón de Llamada de Emergencia
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Aquí iría la lógica para abrir el marcador telefónico
                  },
                  icon: const Icon(Icons.phone_in_talk, size: 28),
                  label: const Text('LLAMAR A EMERGENCIAS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('IGNORAR ALERTA', style: TextStyle(color: Colors.white54)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
