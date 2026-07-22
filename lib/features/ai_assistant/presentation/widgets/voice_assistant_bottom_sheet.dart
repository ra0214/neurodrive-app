import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/global_providers.dart';

class VoiceAssistantBottomSheet extends ConsumerWidget {
  const VoiceAssistantBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceVM = ref.watch(voiceAssistantViewModelProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador visual de voz
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: voiceVM.isListening ? Colors.redAccent.withValues(alpha: 0.2) : theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              voiceVM.isListening ? Icons.mic : Icons.psychology,
              size: 40,
              color: voiceVM.isListening ? Colors.redAccent : theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            voiceVM.isListening ? "Escuchando..." : (voiceVM.isProcessing ? "Procesando..." : "Asistente NeuroDrive"),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: voiceVM.isListening ? Colors.redAccent : theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Texto reconocido o respuesta de la IA
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              voiceVM.lastWords,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Botón de acción
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: voiceVM.isListening ? Colors.redAccent : theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                if (voiceVM.isListening) {
                  ref.read(voiceAssistantViewModelProvider).stopListening();
                } else {
                  ref.read(voiceAssistantViewModelProvider).startListening();
                }
              },
              child: Text(
                voiceVM.isListening ? "DETENER" : "HABLAR AHORA",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
