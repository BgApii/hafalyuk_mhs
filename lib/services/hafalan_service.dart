import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'auth_service.dart';

class SetoranService {
  final String? urlApi = dotenv.env['URL_API'];
  final String? baseUrl = dotenv.env['BASE_URL'];
  final Dio dio;
  final AuthService authService;

  SetoranService(this.authService) : dio = authService.dio;

  Future<SetoranMhs> getSetoranData() async {
    final token = await authService.getToken();
    if (token == null) throw Exception('No token found');

    final response = await dio.get(
      '$urlApi/$baseUrl/mahasiswa/setoran-saya',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return SetoranMhs.fromJson(response.data);
    } else {
      throw Exception('Failed to load data: ${response.data}');
    }
  }
}