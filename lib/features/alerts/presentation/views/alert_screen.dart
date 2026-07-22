import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/alerts_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertScreen extends ConsumerWidget {
  const AlertScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertInfo = ref.watch(alertInfoProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Column(
          children: [
            // Alert Icon Wrapper
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C), // Deep Red
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ]
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 90,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              '¡ALERTA CRÍTICA!',
              style: TextStyle(
                color: const Color(0xFFB71C1C),
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'MICROSUEÑO DETECTADO',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF102A43),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 32),
            // Stats Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D1E33) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'NIVEL FATIGA',
                          style: TextStyle(
                            color: Colors.blueGrey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${alertInfo.fatigueLevel}%',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 40, width: 1, color: Colors.grey.withValues(alpha: 0.3)),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'OJOS CERRADOS',
                          style: TextStyle(
                            color: Colors.blueGrey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${alertInfo.eyesClosedDuration}s',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Map/Rest Area Card
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D1E33) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.local_parking, color: Colors.teal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'ÁREA DE DESCANSO CERCANA',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.blueGrey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'A ${alertInfo.distanceToRestArea}m',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.network(
                        'https://static.comunicae.com/presses/0/1183204/1519728864_mapa_madrid.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal[800],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'AUTO-PILOTO ACTIVADO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Call Button
            SizedBox(
              width: double.infinity,
              height: 65,
              child: OutlinedButton.icon(
                onPressed: () => _makePhoneCall(alertInfo.emergencyContactPhone),
                icon: const Icon(Icons.phone_outlined, size: 28),
                label: const Text(
                  'LLAMAR A UN FAMILIAR',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00695C), // Dark Teal
                  side: const BorderSide(color: Color(0xFF00695C), width: 2.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Cancel Link
            TextButton(
              onPressed: () {},
              child: Text(
                'ESTOY DESPIERTO, CANCELAR ALERTA',
                style: TextStyle(
                  color: isDark ? Colors.white38 : Colors.blueGrey[400],
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
