import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/global_providers.dart';
import '../view_models/profile_view_model.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileViewModelProvider).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(profileViewModelProvider);
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
                    onPressed: () => ref.read(profileViewModelProvider).loadProfile(),
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
                const SizedBox(height: 20),
                _buildDateReminder(context),
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'DATOS OPERATIVOS', null),
                _buildDataCard(context, [
                  {'label': 'ID OPERADOR', 'value': user.id.toString(), 'icon': Icons.badge_outlined},
                  {'label': 'ID EMPRESA', 'value': user.idEmpresa.toString(), 'icon': Icons.business_outlined},
                  {'label': 'NÚMERO DE LICENCIA', 'value': user.numeroLicencia, 'icon': Icons.assignment_ind_outlined},
                  {'label': 'TELÉFONO', 'value': user.telefono, 'icon': Icons.phone_android_outlined},
                ]),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'CONTACTOS DE EMERGENCIA', '+ Añadir'),
                _buildContactCard(context, user.emergencyContact),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'PREFERENCIAS DE ALERTA', null),
                _buildPreferencesCard(context, vm),
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
    final bool isActive = user.status.toLowerCase() == 'activo';

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(user.imageUrl),
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: (isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isActive ? Colors.green : Colors.red),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                user.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateReminder(BuildContext context) {
    final theme = Theme.of(context);
    final String formattedDate = DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(DateTime.now());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            formattedDate,
            style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(BuildContext context, List<Map<String, dynamic>> items) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(item['icon'], size: 20, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['label'], style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
                      Text(item['value'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
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
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          if (actionText != null)
            Text(
              actionText,
              style: TextStyle(color: colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
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
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${contact.relationship} • ${contact.phoneNumber}',
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.phone_outlined, color: colorScheme.primary, size: 20),
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
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _buildSwitchTile(context, 'Vibración Háptica', prefs.hapticFeedback, vm.toggleHapticFeedback),
          _buildSwitchTile(context, 'Alertas de Audio', prefs.audioAlerts, vm.toggleAudioAlerts),
          _buildSwitchTile(context, 'Modo Nocturno', prefs.autoNightMode, vm.toggleAutoNightMode),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        icon: const Icon(Icons.logout),
        label: const Text('CERRAR SESIÓN'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
