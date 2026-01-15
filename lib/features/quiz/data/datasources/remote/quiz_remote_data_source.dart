import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';

abstract class QuizRemoteDataSource {
  Future<void> upsertQuiz(QuizModel quiz);

  Future<void> deleteQuiz({required String userId, required String quizId});

  Future<List<QuizModel>> fetchQuizzes(String userId);
}

class FirestoreQuizRemoteDataSource implements QuizRemoteDataSource {
  final FirebaseFirestore _firestore;

  FirestoreQuizRemoteDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> _quizCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('quizzes');
  }

  @override
  Future<void> upsertQuiz(QuizModel quiz) async {
    final userId = quiz.userId;
    if (userId == null) return;

    final data = quiz.toFirestore();
    await _quizCollection(
      userId,
    ).doc(quiz.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteQuiz({
    required String userId,
    required String quizId,
  }) async {
    await _quizCollection(userId).doc(quizId).delete();
  }

  @override
  Future<List<QuizModel>> fetchQuizzes(String userId) async {
    final snap = await _quizCollection(userId).get();
    return snap.docs.map((doc) => QuizModel.fromFirestore(doc.data())).toList();
  }
}
