import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'providers/exam_provider.dart';
import 'services/api_service.dart';
import 'screens/exam_list_screen.dart';

/// Custom HttpOverrides to allow self-signed development certificates for
/// ASP.NET Core local API (https://localhost:44311)
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow localhost HTTPS self-signed certificate in development mode
  if (!kIsWeb) {
    HttpOverrides.global = DevHttpOverrides();
  }

  // Auto-configure base URL for platform (e.g. 10.0.2.2 on Android emulator)
  ApiService().configureForPlatform();

  runApp(const ToeicExamApp());
}

class ToeicExamApp extends StatelessWidget {
  const ToeicExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamProvider(),
      child: MaterialApp(
        title: 'TOEIC Reading Exam',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: AppColors.canvasBackground,
          primaryColor: AppColors.brandGreen,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.brandGreen,
            primary: AppColors.brandGreen,
            surface: AppColors.cardDefault,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.canvasBackground,
            foregroundColor: AppColors.textDark,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColors.textDark),
          ),
        ),
        home: const ExamListScreen(),
      ),
    );
  }
}
