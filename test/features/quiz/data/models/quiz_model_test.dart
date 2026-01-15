import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_master/features/quiz/data/models/question_model.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';

void main() {
  group('QuizModel.fromFirestore', () {
    test('uses safe defaults when optional fields are missing', () {
      final data = <String, dynamic>{
        'id': 'q1',
        'title': 'Basics',
        'questions': [
          {
            'id': 'qq1',
            'text': 'What is Flutter?',
            'answers': ['SDK', 'IDE'],
          },
        ],
        // durationSeconds missing
        // userId missing
        // lastSyncedAt missing
        // syncStatus missing -> should default to 'synced' per your code
        // isPublic missing -> should default to false per your code
        // createdByUserId missing
        // createdAt missing
        // playCount missing -> default 0
        // sumScorePercent missing -> default 0.0
        // sumCorrectAnswers missing -> default 0
        // sumTotalQuestions missing -> default 0
        // isAiGenerated missing -> default false
      };

      final model = QuizModel.fromFirestore(data);

      expect(model.id, 'q1');
      expect(model.title, 'Basics');
      expect(model.questions.length, 1);

      expect(model.durationSeconds, isNull);
      expect(model.userId, isNull);
      expect(model.lastSyncedAt, isNull);

      // Defaults from your implementation:
      expect(model.syncStatus, 'synced');
      expect(model.isPublic, false);
      expect(model.playCount, 0);
      expect(model.sumScorePercent, 0.0);
      expect(model.sumCorrectAnswers, 0);
      expect(model.sumTotalQuestions, 0);
      expect(model.isAiGenerated, false);
    });

    test('parses questions list into QuestionModel', () {
      final data = <String, dynamic>{
        'id': 'q1',
        'title': 'Basics',
        'questions': [
          {
            'id': 'qq1',
            'text': 'A?',
            'answers': ['1', '2'],
          },
          {
            'id': 'qq2',
            'text': 'B?',
            'answers': ['x', 'y'],
          },
        ],
      };

      final model = QuizModel.fromFirestore(data);

      expect(model.questions, everyElement(isA<QuestionModel>()));
      expect(model.questions[0].text, 'A?');
      expect(model.questions[1].text, 'B?');
    });
  });

  group('QuizModel.toFirestore', () {
    test('produces a map with all expected keys', () {
      final model = QuizModel(
        id: 'id_123',
        title: 'Quiz',
        questions: [
          QuestionModel(id: 'q1', text: 'T?', answers: ['A', 'B']),
        ],
        durationSeconds: 120,
        userId: 'u1',
        syncStatus: 'pending',
        isPublic: true,
        createdByUserId: 'u1',
        createdAt: DateTime(2024, 1, 1),
        playCount: 3,
        sumScorePercent: 150.0,
        sumCorrectAnswers: 6,
        sumTotalQuestions: 10,
        isAiGenerated: true,
      );

      final map = model.toFirestore();

      // Minimal key checks (avoid asserting exact timestamp values)
      expect(map['id'], 'id_123');
      expect(map['title'], 'Quiz');
      expect(map['questions'], isA<List>());
      expect(map['durationSeconds'], 120);
      expect(map['userId'], 'u1');
      expect(map['syncStatus'], 'pending');
      expect(map['isPublic'], true);
      expect(map['createdByUserId'], 'u1');
      expect(map['playCount'], 3);
      expect(map['sumScorePercent'], 150.0);
      expect(map['sumCorrectAnswers'], 6);
      expect(map['sumTotalQuestions'], 10);
      expect(map['isAiGenerated'], true);

      // lastSyncedAt & createdAt always written as UTC DateTime
      expect(map['lastSyncedAt'], isA<DateTime>());
      expect((map['lastSyncedAt'] as DateTime).isUtc, true);

      expect(map['createdAt'], isA<DateTime>());
      expect((map['createdAt'] as DateTime).isUtc, true);
    });
  });
}
