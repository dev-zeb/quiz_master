import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/features/quiz/data/datasources/remote/quiz_remote_data_source.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';

final quizRemoteDataSourceProvider = Provider<QuizRemoteDataSource>((ref) {
  final firestore = FirebaseFirestore.instance;
  return FirestoreQuizRemoteDataSource(firestore);
});

class FirestoreQuizRemoteDataSource implements QuizRemoteDataSource {
  final FirebaseFirestore _firestore;

  FirestoreQuizRemoteDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> _quizCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('quizzes');
  }

  @override
  Future<void> upsertQuiz(QuizModel quiz) async {
    final userId = quiz.userId;
    if (userId == null) {
      // No logged-in user; don't sync
      return;
    }

    final data = quiz.toFirestore();
    await _quizCollection(userId)
        .doc(quiz.id)
        .set(data, SetOptions(merge: true));
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
