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
    try {
      final response = await dio.get('$urlApi/$baseUrl/mahasiswa/setoran-saya');
      if (response.statusCode == 200) {
        return SetoranMhs.fromJson(response.data);
      } else {
        throw Exception('Failed to load data: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      throw Exception('getSetoranData error: $e');
    }
  }
}
