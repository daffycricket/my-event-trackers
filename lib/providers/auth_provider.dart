import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/constants/storage_keys.dart';
import 'package:my_event_tracker/services/auth_service.dart';
import 'package:my_event_tracker/services/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authServiceProvider = Provider((ref) => AuthService());
final eventServiceProvider = Provider((ref) => EventService(ref));

class AuthState extends StateNotifier<String?> {
  final AuthService _authService;
  final EventService _eventService;

  AuthState(this._authService, this._eventService) : super(null);

  Future<bool> login(String email, String password) async {
    try {
      await _authService.clearAuthData();
      state = null;

      final token = await _authService.login(email, password);
      await _authService.saveAuthData(email, token);
      state = token;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkStoredAuth() async {
    try {
      final authData = await _authService.getStoredAuthData();
      final token = authData['token'];
      final email = authData['email'];

      if (token == null || email == null) {
        return false;
      }

      try {
        await _eventService.getEvents();
        state = token;
        return true;
      } catch (e) {
        await _authService.clearAuthData();
        state = null;
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String?> getStoredEmail() async {
    final authData = await _authService.getStoredAuthData();
    return authData['email'];
  }

  Future<void> logout() async {
    await _authService.clearAuthData();
    state = null;
  }

  Future<void> setToken(String token) async {
    state = token;
  }

  Future<String?> initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString(StorageKeys.userToken);
    if (storedToken != null) {
      state = storedToken;
    }
    return prefs.getString(StorageKeys.userEmail);
  }
}

final authStateProvider = StateNotifierProvider<AuthState, String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  final eventService = ref.watch(eventServiceProvider);
  return AuthState(authService, eventService);
}); 