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
      context.read<FeedbackProvider>().fetchFeedbacks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FeedbackProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.feedbacks.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyan));
          }
          if (provider.errorMessage != null && provider.feedbacks.isEmpty) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: () => provider.fetchFeedbacks(),
                  child: const Text("Reintentar"),
                )
              ],
            ));
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchFeedbacks(),
            child: ListView.builder(
              itemCount: provider.feedbacks.length,
              itemBuilder: (context, index) => FeedbackCard(feedback: provider.feedbacks[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () => _showAddFeedbackModal(context),
        child: const Icon(Icons.add_comment, color: Colors.black),
      ),
    );
  }

  void _showAddFeedbackModal(BuildContext context) {
    final rutaController = TextEditingController();
    final comentarioController = TextEditingController();
    int selectedPeligro = 3;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0E21),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Publicar Alerta de Ruta", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan)),
              const SizedBox(height: 15),
              TextField(
                controller: rutaController,
                decoration: const InputDecoration(labelText: "Nombre de la Ruta", labelStyle: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(height: 20),
              const Text("Nivel de Peligro", style: TextStyle(color: Colors.white54)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(
                    selectedPeligro > index ? Icons.warning_rounded : Icons.warning_amber_rounded,
                    color: selectedPeligro > index ? Colors.redAccent : Colors.white24,
                  ),
                  onPressed: () => setModalState(() => selectedPeligro = index + 1),
                )),
              ),
              TextField(
                controller: comentarioController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Tu comentario", labelStyle: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.black),
                  onPressed: context.watch<FeedbackProvider>().isLoading 
                    ? null 
                    : () async {
                      const mockToken = "TOKEN_DE_SESION"; 
                      const mockIdAutor = 104;

                      final success = await context.read<FeedbackProvider>().createFeedback(
                        idAutor: mockIdAutor,
                        ruta: rutaController.text,
                        peligro: selectedPeligro,
                        comentario: comentarioController.text,
                        token: mockToken,
                      );

                      if (success) {
                        if (mounted) Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reseña publicada con éxito")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al publicar")));
                      }
                    },
                  child: const Text("PUBLICAR"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
