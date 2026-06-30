import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/feedback_provider.dart';
import '../widgets/feedback_card.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FeedbackProvider>().fetchFeedbacks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cyanColor = const Color(0xFF00F1FE);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'NeuroDrive',
          style: TextStyle(
            color: isDark ? cyanColor : theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<FeedbackProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchFeedbacks(),
            color: cyanColor,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                // TARJETA DE ACCIÓN SUPERIOR
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Comunidad y\nFeedback',
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            color: theme.colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAddFeedbackModal(context),
                        icon: const Icon(Icons.edit, size: 18, color: Colors.black),
                        label: const Text(
                          'Compartir', 
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cyanColor,
                          elevation: 4,
                          shadowColor: cyanColor.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Text(
                  'EXPERIENCIAS RECIENTES',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 20),

                if (provider.isLoading && provider.feedbacks.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Color(0xFF00F1FE)),
                  ))
                else if (provider.feedbacks.isEmpty)
                  Center(child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text("No hay alertas activas.", style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                  ))
                else
                  ...provider.feedbacks.map((fb) => FeedbackCard(feedback: fb)),
                
                const SizedBox(height: 80), // Espacio para el FAB
              ],
            ),
          );
        },
      ),
      // BOTÓN FLOTANTE
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: cyanColor,
        onPressed: () => _showAddFeedbackModal(context),
        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.black),
        label: const Text(
          "REPORTAR RUTA",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showAddFeedbackModal(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cyanColor = const Color(0xFF00F1FE);
    final rutaController = TextEditingController();
    final comentarioController = TextEditingController();
    int selectedPeligro = 3;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
      ),
      builder: (modalContext) => StatefulBuilder(
        builder: (stateContext, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(stateContext).viewInsets.bottom + 32,
            left: 24, right: 24, top: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cyanColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.add_alert_rounded, color: cyanColor),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        "Nueva Alerta",
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.w900, 
                          color: theme.colorScheme.onSurface
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(modalContext),
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                  )
                ],
              ),
              const SizedBox(height: 30),
              
              TextField(
                controller: rutaController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: "Nombre de la Ruta",
                  labelStyle: TextStyle(color: cyanColor.withValues(alpha: 0.8)),
                  prefixIcon: Icon(Icons.edit_road, color: cyanColor),
                  filled: true,
                  fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                "Nivel de Riesgo (Llamas)",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7), 
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final level = index + 1;
                  final isSelected = selectedPeligro >= level;
                  return IconButton(
                    icon: Icon(
                      Icons.local_fire_department_rounded,
                      size: 45,
                      color: isSelected ? Colors.orangeAccent : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                    onPressed: () => setModalState(() => selectedPeligro = level),
                  );
                }),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: comentarioController,
                maxLines: 3,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: "Detalles adicionales",
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                  hintText: "Ej: Tráfico lento, baches, clima...",
                  filled: true,
                  fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Consumer<FeedbackProvider>(
                builder: (context, provider, _) => SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cyanColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: provider.isLoading 
                      ? null 
                      : () async {
                        if (rutaController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(modalContext).showSnackBar(
                            const SnackBar(content: Text("El nombre de la ruta es obligatorio"))
                          );
                          return;
                        }

                        final success = await provider.createFeedback(
                          ruta: rutaController.text.trim(),
                          peligro: selectedPeligro,
                          comentario: comentarioController.text.trim(),
                        );

                        if (!mounted) return;

                        if (success) {
                          Navigator.pop(modalContext);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text("Reporte publicado exitosamente"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            )
                          );
                        } else {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(provider.errorMessage ?? "Error al publicar"),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            )
                          );
                        }
                      },
                    child: provider.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : const Text(
                          "COMPARTIR CON COMPAÑEROS", 
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
