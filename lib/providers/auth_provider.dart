import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthState extends StateNotifier<String?> {
  AuthState() : super(null);

  Future<void> setToken(String token) async {
    state = token;
  }

  Future<void> logout() async {
    // Supprimer le token du stockage local si nécessaire
    // await storage.delete(key: 'auth_token');
    state = null;
  }
}

final authStateProvider = StateNotifierProvider<AuthState, String?>((ref) {
  return AuthState();
}); 