import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:quiz_master/core/config/backend_config.dart';

class AiQuizRemoteDataSource {
  final http.Client _client;

  AiQuizRemoteDataSource(this._client);

  Future<Map<String, dynamic>> generateFromText({
    required String text,
    required int numQuestions,
  }) async {
    final uri = Uri.parse(BackendConfig.quizFromText);

    final body = {'text': text, 'num_questions': numQuestions};

    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (resp.statusCode != 200) {
      throw Exception('Backend error (${resp.statusCode}): ${resp.body}');
    }

    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateFromFile({
    required Uint8List bytes,
    required String filename,
    required int numQuestions,
    String? extraInstructions,
  }) async {
    final uri = Uri.parse(BackendConfig.quizFromFile);

    final request = http.MultipartRequest('POST', uri)
      ..fields['num_questions'] = numQuestions.toString();

    if (extraInstructions != null && extraInstructions.trim().isNotEmpty) {
      request.fields['extra_instructions'] = extraInstructions.trim();
    }

    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: filename),
    );

    final streamed = await _client.send(request);
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode != 200) {
      throw Exception('Backend error (${resp.statusCode}): ${resp.body}');
    }

    return jsonDecode(resp.body) as Map<String, dynamic>;
  }
}
