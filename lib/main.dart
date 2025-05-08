import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hafalyuk_mhs/pages/login_page.dart';
import 'package:hafalyuk_mhs/pages/hafalan_page.dart';
import 'package:hafalyuk_mhs/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print('Loaded .env file successfully');
    print('KC_URL: ${dotenv.env['KC_URL']}');
    print('CLIENT_ID: ${dotenv.env['CLIENT_ID']}');
    print('CLIENT_SECRET: ${dotenv.env['CLIENT_SECRET']}');
  } catch (e) {
    print('Failed to load .env file: $e');
    dotenv.env['KC_URL'] = 'https://your-api-url.com';
    dotenv.env['CLIENT_ID'] = 'setoran-mobile-dev';
    dotenv.env['CLIENT_SECRET'] = 'dkskodkoskaoadmpoOIJONWNdioniwnn';
  }

  final authService = AuthService();
  final token = await authService.getToken();
  Widget initialPage = (token != null) ? const HafalanPage() : const LoginPage();

  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Setoran Hafalan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initialPage,
    );
  }
}