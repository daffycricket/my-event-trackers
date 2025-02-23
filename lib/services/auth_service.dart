import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends BaseService {
  static const String userKey = 'stored_user';

  AuthService() : super('AuthService');

  Future<String> login(String email, String password) async {
    try {
      final uri = Uri.parse('${BaseService.baseUrl}/auth/login');
      final jsonData = {
        'grant_type': 'password',
        'username': email,
        'password': password,
      };
      
      logInfo('Logging in user: $email');
      logInfo('Request URL: $uri');
      logInfo('Request body:');
      logInfo(jsonEncode(jsonData));
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        //body: jsonEncode(jsonData),
        body: {
          'username': email,
          'password': password,
          'grant_type': 'password',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['access_token'];
        
        // Stocker l'email de l'utilisateur
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(userKey, email);
        
        return token;
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logSevere('Login error', e, stackTrace);
      rethrow;
    }
  }

  Future<String> register(String email, String password) async {
    try {
      final uri = Uri.parse('${BaseService.baseUrl}/auth/register');
      final jsonData = {
        'email': email,
        'password': password,
        'is_active' : true,
        'is_superuser' : false,
        'is_verified' : true
        };
      logInfo('Registering user: $email');
      logInfo('Request URL: $uri');
      logInfo('Request body:');
      logInfo(jsonEncode(jsonData));
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(jsonData),
      );
      
      logInfo('Response status: ${response.statusCode}');
      logFine('Response body:');
      logFine(response.body);
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        logInfo('Decoded response: $data');
        // Après l'inscription réussie, on fait directement le login
        return login(email, password);
      } else {
        logSevere('Registration failed with status ${response.statusCode}');
        logSevere('Response body:');
        logSevere(response.body);
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logSevere('Registration error', e, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Supprimer l'utilisateur stocké
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(userKey);
    } catch (e, stackTrace) {
      logSevere('Logout error', e, stackTrace);
      rethrow;
    }
  }

  // Méthode pour récupérer l'utilisateur stocké
  Future<String?> getStoredUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(userKey);
    } catch (e, stackTrace) {
      logSevere('Error getting stored user', e, stackTrace);
      return null;
    }
  }
} 