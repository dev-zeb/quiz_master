import 'package:flutter_dotenv/flutter_dotenv.dart';

class BackendConfig {
  static String get baseUrl {
    return dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:8000');
  }

  static String get quizFromText => '$baseUrl/api/v1/quiz/from-text';

  static String get quizFromFile => '$baseUrl/api/v1/quiz/from-file';
}
