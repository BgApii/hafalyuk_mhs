import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hafalyuk_mhs/models/login_model.dart';

class AuthService {
  final String? kcUrl = dotenv.env['KC_URL'] ?? 'https://your-api-url.com';
  final String? clientId = dotenv.env['CLIENT_ID'] ?? 'setoran-mobile-dev';
  final String? clientSecret =
      dotenv.env['CLIENT_SECRET'] ?? 'dkskodkoskaoadmpoOIJONWNdioniwnn';
  final _storage = const FlutterSecureStorage();
  final Dio dio = Dio();

  AuthService() {
    print('AuthService initialized with KC_URL: $kcUrl');
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401) {
            print('Access token expired, attempting to refresh...');
            try {
              await _refreshToken();
              final clonedRequest = await dio.fetch(e.requestOptions);
              print('Token refreshed successfully, retrying request...');
              return handler.resolve(clonedRequest);
            } catch (refreshError) {
              print('Refresh token failed: $refreshError');
              await logout();
              return handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  error: 'Session expired. Please log in again.',
                  type: DioExceptionType.badResponse,
                ),
              );
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<LoginRespons> login(String username, String password) async {
    final response = await dio.post(
      '$kcUrl/realms/dev/protocol/openid-connect/token',
      data: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'password',
        'username': username,
        'password': password,
        'scope': 'openid profile email',
      },
      options: Options(contentType: 'application/x-www-form-urlencoded'),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final loginResponse = LoginRespons.fromJson(data);
      await _storage.write(
        key: 'access_token',
        value: loginResponse.accessToken,
      );
      await _storage.write(
        key: 'refresh_token',
        value: loginResponse.refreshToken,
      );
      print(
        'Tokens saved: access_token=${loginResponse.accessToken}, refresh_token=${loginResponse.refreshToken}',
      );
      return loginResponse;
    } else {
      throw Exception('Login failed: ${response.data}');
    }
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: 'access_token');
    print('Retrieved access_token: $token');
    return token;
  }

  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: 'refresh_token');
    print('Retrieved refresh_token: $token');
    return token;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    print('Tokens deleted on logout');
  }

  Future<void> _refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token found');

    final response = await dio.post(
      '$kcUrl/realms/dev/protocol/openid-connect/token',
      data: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
      options: Options(contentType: 'application/x-www-form-urlencoded'),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final newAccessToken = data['access_token'];
      final newRefreshToken = data['refresh_token'];
      await _storage.write(key: 'access_token', value: newAccessToken);
      await _storage.write(key: 'refresh_token', value: newRefreshToken);
      dio.options.headers['Authorization'] = 'Bearer $newAccessToken';
      print(
        'Tokens refreshed: access_token=$newAccessToken, refresh_token=$newRefreshToken',
      );
    } else {
      throw Exception(
        'Failed to refresh token: ${response.statusCode} - ${response.data}',
      );
    }
  }
}
