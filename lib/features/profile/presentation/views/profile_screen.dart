import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'NeuroDrive',
          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = vm.userProfile;
          if (user == null) {
            return const Center(child: Text('No se pudo cargar el perfil'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileHeader(context, user),
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'DISPOSITIVOS VINCULADOS', 'Gestionar'),
                _buildDeviceCard(context, user.connectedDevice),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'CONTACTOS DE EMERGENCIA', '+ Añadir'),
                _buildContactCard(context, user.emergencyContact),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'PREFERENCIAS DE ALERTA', null),
                _buildPreferencesCard(context, vm),
                const SizedBox(height: 32),
                _buildLogoutButton(context),
                const SizedBox(height: 24),
                Text(
                  'NEURODRIVE CORE V2.4.0-STABLE',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.24),
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
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
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary.withValues(alpha: 0.5), width: 2),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.imageUrl),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit, size: 16, color: colorScheme.onPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        Text(
          user.id,
          style: TextStyle(fontSize: 12, color: colorScheme.primary, letterSpacing: 1.5),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String? actionText) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.38),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
          ),
          if (actionText != null)
            Text(
              actionText,
              style: TextStyle(color: colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, device) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.auto_awesome, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name, style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
                Text(
                  'Estado: ${device.status} • Batería ${device.batteryLevel}%',
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          const CircleAvatar(radius: 4, backgroundColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, contact) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
                Text(
                  '${contact.relationship} • ${contact.phoneNumber}',
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.phone_outlined, color: colorScheme.onSurfaceVariant, size: 20),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(BuildContext context, ProfileViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    final prefs = vm.userProfile!.preferences;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            context,
            'Vibración Háptica',
            'Alertas físicas en la muñeca',
            prefs.hapticFeedback,
            vm.toggleHapticFeedback,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          _buildSwitchTile(
            context,
            'Alertas de Audio',
            'Notificaciones sonoras en cabina',
            prefs.audioAlerts,
            vm.toggleAudioAlerts,
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          _buildSwitchTile(
            context,
            'Modo Nocturno Automático',
            'Ajuste de brillo por sensores',
            prefs.autoNightMode,
            vm.toggleAutoNightMode,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, bool value, Function(bool) onChanged) {
    final colorScheme = Theme.of(context).colorScheme;
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11)),
      activeColor: colorScheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Cerrar Sesión'),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }
}
