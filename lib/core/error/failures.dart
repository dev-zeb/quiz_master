abstract class Failure {
  final String message;
  const Failure(this.message);
}

class QuizFailure extends Failure {
  const QuizFailure(super.message);
}
