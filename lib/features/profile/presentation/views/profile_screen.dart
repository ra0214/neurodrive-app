import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/profile_view_model.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileViewModel viewModel;

  const ProfileScreen({super.key, required this.viewModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'NeuroDrive',
            style: TextStyle(color: AppTheme.primaryCyan, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, vm, child) {
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
                  _buildProfileHeader(user),
                  const SizedBox(height: 32),
                  _buildSectionHeader('DISPOSITIVOS VINCULADOS', 'Gestionar'),
                  _buildDeviceCard(user.connectedDevice),
                  const SizedBox(height: 24),
                  _buildSectionHeader('CONTACTOS DE EMERGENCIA', '+ Añadir'),
                  _buildContactCard(user.emergencyContact),
                  const SizedBox(height: 24),
                  _buildSectionHeader('PREFERENCIAS DE ALERTA', null),
                  _buildPreferencesCard(vm),
                  const SizedBox(height: 32),
                  _buildLogoutButton(),
                  const SizedBox(height: 24),
                  const Text(
                    'NEURODRIVE CORE V2.4.0-STABLE',
                    style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryCyan.withOpacity(0.5), width: 2),
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
                decoration: const BoxDecoration(
                  color: AppTheme.primaryCyan,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          user.id,
          style: const TextStyle(fontSize: 12, color: AppTheme.primaryCyan, letterSpacing: 1.5),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String? actionText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.1),
          ),
          if (actionText != null)
            Text(
              actionText,
              style: const TextStyle(color: AppTheme.primaryCyan, fontSize: 12, fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(device) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryCyan.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryCyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, color: AppTheme.primaryCyan),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(
                  'Estado: ${device.status} • Batería ${device.batteryLevel}%',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const CircleAvatar(radius: 4, backgroundColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildContactCard(contact) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white70),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(
                  '${contact.relationship} • ${contact.phoneNumber}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.phone_outlined, color: Colors.white54, size: 20),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(ProfileViewModel vm) {
    final prefs = vm.userProfile!.preferences;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            'Vibración Háptica',
            'Alertas físicas en la muñeca',
            prefs.hapticFeedback,
            vm.toggleHapticFeedback,
          ),
          const Divider(height: 1, color: Colors.white10),
          _buildSwitchTile(
            'Alertas de Audio',
            'Notificaciones sonoras en cabina',
            prefs.audioAlerts,
            vm.toggleAudioAlerts,
          ),
          const Divider(height: 1, color: Colors.white10),
          _buildSwitchTile(
            'Modo Nocturno Automático',
            'Ajuste de brillo por sensores',
            prefs.autoNightMode,
            vm.toggleAutoNightMode,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      activeColor: AppTheme.primaryCyan,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Cerrar Sesión'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C1620),
          foregroundColor: const Color(0xFFFF4B6E),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }
}
