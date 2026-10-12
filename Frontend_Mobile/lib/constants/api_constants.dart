/// API constants and endpoints configuration
class ApiConstants {
  ApiConstants._();

  /// Default Backend API base URL specified in project requirements:
  /// https://localhost:44311/api/services/app/Exam
  static const String defaultLocalhostUrl =
      'https://localhost:44311/api/services/app/Exam';

  /// Android Emulator mapping for host machine localhost
  static const String defaultAndroidEmulatorUrl =
      'https://10.0.2.2:44311/api/services/app/Exam';

  /// Endpoints
  static const String getAllExams = '/GetAllExams';
  static const String getExamDetail = '/GetExamDetail';

  /// Request timeouts
  static const Duration connectTimeout = Duration(seconds: 8);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
