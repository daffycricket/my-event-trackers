import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_event_tracker/constants/storage_keys.dart';

class AuthService extends BaseService {
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
        
        logInfo('Login successful - Token received: $token');
        
        // Stocker l'email de l'utilisateur
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(StorageKeys.userEmail, email);
        await saveAuthData(email, token);
        
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

  Future<void> saveAuthData(String email, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.userToken, token);
    await prefs.setString(StorageKeys.userEmail, email);
  }

  Future<Map<String, String?>> getStoredAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(StorageKeys.userToken),
      'email': prefs.getString(StorageKeys.userEmail),
    };
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.userToken);
    await prefs.remove(StorageKeys.userEmail);
  }
} 