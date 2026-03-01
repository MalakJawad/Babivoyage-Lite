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
    try {
      final data = await _api.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      });

      final token = data['token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Token missing from server response.');
      }

      await _store.save(token);
    } catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await _api.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final token = data['token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Token missing from server response.');
      }

      await _store.save(token);
    } catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  Future<Map<String, dynamic>> me() async {
    try {
      final data = await _api.get('/auth/me');
      final user = data['user'];
      if (user is Map) return user.cast<String, dynamic>();
      throw Exception('Invalid user response.');
    } catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  Future<void> logout() async {
    try {
      await _api.post('/auth/logout', {});
    } catch (_) {
    } finally {
      await _store.clear();
    }
  }

  String _friendlyError(Object e) {
    final msg = e.toString().replaceFirst('Exception: ', '');

    if (msg.contains('422')) return 'Invalid input. Please check your fields.';
    if (msg.contains('401')) return 'Wrong email or password.';
    if (msg.contains('403')) return 'Access denied.';
    if (msg.contains('500')) return 'Server error. Try again later.';
    if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
      return 'Server not reachable. Check your URL and Laravel is running.';
    }

    return msg;
  }
}