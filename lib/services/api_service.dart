import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class ApiService {
  final Ref _ref;

  ApiService(this._ref);

  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      await _ref.read(authStateProvider.notifier).logout();
    }
    return response;
  }

  Future<http.Response> get(String url) async {
    final response = await http.get(Uri.parse(url));
    return _handleResponse(response);
  }

  Future<http.Response> post(String url, {Object? body}) async {
    final response = await http.post(Uri.parse(url), body: body);
    return _handleResponse(response);
  }

  // Ajoutez d'autres méthodes HTTP si nécessaire
}

final apiServiceProvider = Provider((ref) => ApiService(ref)); 