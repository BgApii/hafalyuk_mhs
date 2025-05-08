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
    dotenv.env['CLIENT_ID'] = 'jualan-mobile';
    dotenv.env['CLIENT_SECRET'] = 'dkskodkoskaoadmpoOIJONWNdioniwnn';
  }

  final authService = AuthService();
  final token = await authService.getToken();
  Widget initialPage =
      (token != null) ? const HafalanPage() : const LoginPage();

  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Setoran Hafalan',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF8BC5E9),
          scrolledUnderElevation: 0,
        ),
        primarySwatch: Colors.blue,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.blue.shade100,
          cursorColor: Colors.grey.shade300,
          selectionHandleColor: Colors.blue.shade300,
        ),
      ),
      home: initialPage,
    );
  }
}
