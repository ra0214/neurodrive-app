import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../sources/profile_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService apiService;

  ProfileRepositoryImpl({required this.apiService});

  @override
  Future<UserProfile> getUserProfile() async {
    final data = await apiService.getProfile();
    
    // Mapeo robusto: el backend puede devolver 'id' o 'chofer_id', 'nombre' o 'first_name'
    return UserProfile(
      id: data['id'] ?? data['chofer_id'] ?? 0,
      idEmpresa: data['id_empresa'] ?? data['empresa_id'] ?? 0,
      name: data['nombre'] ?? data['first_name'] ?? 'Sin nombre',
      apellidos: data['apellidos'] ?? data['last_name'] ?? '',
      numeroLicencia: data['numero_licencia'] ?? data['licencia'] ?? 'S/N',
      telefono: data['telefono'] ?? data['phone'] ?? 'S/N',
      status: data['status'] ?? data['estado'] ?? 'activo',
      imageUrl: data['image_url'] ?? 'https://ui-avatars.com/api/?name=${data['nombre'] ?? 'U'}&background=random',
      connectedDevice: DeviceInfo(
        name: 'NeuroDrive Core v2',
        status: 'Conectado',
        batteryLevel: 85,
      ),
      emergencyContact: EmergencyContact(
        name: 'Contacto de Emergencia',
        relationship: 'Familiar',
        phoneNumber: '961 000 0000',
      ),
      preferences: NotificationPreferences(
        hapticFeedback: true,
        audioAlerts: true,
        autoNightMode: false,
      ),
    );
  }

  @override
  Future<void> updatePreferences(NotificationPreferences preferences) async {
    return;
  }
}
