import 'api_client.dart';
import 'token_store.dart';

class AuthService {
  final ApiClient _api;
  final TokenStore _store;

  AuthService(this._api, this._store);

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final data = await _api.post(
      '/auth/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      },
    );

    final token = data['token']?.toString();
    if (token == null || token.isEmpty) {
      throw Exception('Token missing from server response.');
    }

    await _store.save(token);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    final token = data['token']?.toString();
    if (token == null || token.isEmpty) {
      throw Exception('Token missing from server response.');
    }

    await _store.save(token);
  }
}