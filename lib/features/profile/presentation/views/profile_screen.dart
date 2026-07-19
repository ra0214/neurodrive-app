import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../view_models/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
    });
  }

  void _handleError(ProfileViewModel vm) {
    if (vm.unauthorized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesión expirada. Por favor, inicia sesión de nuevo.')),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      });
    } else if (vm.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${vm.errorMessage}')),
        );
        vm.clearError();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    // Trigger error handling
    if (vm.unauthorized || vm.errorMessage != null) {
      _handleError(vm);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Perfil del Conductor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = vm.userProfile;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No se pudo cargar el perfil'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.loadProfile(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileHeader(context, user),
                const SizedBox(height: 12),
                _buildStatusBadge(context, user.status),
                const SizedBox(height: 32),
                _buildDateWidget(context),
                const SizedBox(height: 24),
                _buildInfoSection(context, user),
                const SizedBox(height: 32),
                _buildLogoutButton(context),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: colorScheme.primaryContainer,
          backgroundImage: user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
          child: user.imageUrl == null
              ? Icon(Icons.person, size: 50, color: colorScheme.onPrimaryContainer)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final bool isActive = status.toLowerCase() == 'activo';
    final Color color = isActive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDateWidget(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(DateTime.now());
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined, size: 20),
          const SizedBox(width: 12),
          Text(
            'Fecha actual: $formattedDate',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, user) {
    return Column(
      children: [
        _buildInfoCard(context, 'ID de Operador', user.id, Icons.badge_outlined),
        const SizedBox(height: 12),
        _buildInfoCard(context, 'ID de Empresa', user.idEmpresa, Icons.business_outlined),
        const SizedBox(height: 12),
        _buildInfoCard(context, 'Número de Licencia', user.numeroLicencia, Icons.assignment_ind_outlined),
        const SizedBox(height: 12),
        _buildInfoCard(context, 'Teléfono', user.telefono, Icons.phone_outlined),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
        icon: const Icon(Icons.logout),
        label: const Text('Cerrar Sesión'),
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.error,
          side: BorderSide(color: colorScheme.error),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
