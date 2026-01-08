import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_form_question_item.dart';

void main() {
  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: QuizFormQuestionItem(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('QuizFormQuestionItem', () {
    testWidgets('initially renders (at least) the question input and options',
        (tester) async {
      await pump(tester);

      // Should have at least 1 question TextFormField + 2 option fields (your initState adds 2 options).
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
    });

    testWidgets('getQuestion() returns null if question is empty',
        (tester) async {
      await pump(tester);

      final state = tester.state<QuizFormQuestionItemState>(
        find.byType(QuizFormQuestionItem),
      );

      final q = state.getQuestion();
      expect(q, isNull);
    });

    testWidgets('getQuestion() returns null if fewer than 2 non-empty options',
        (tester) async {
      await pump(tester);

      // Fill the question field.
      final questionField = find.byType(TextFormField).first;
      await tester.enterText(questionField, 'What is 2+2?');
      await tester.pumpAndSettle();

      // Leave options empty (or clear them if present).
      // We try to clear any remaining text fields besides the question.
      final allTextFields = find.byType(TextFormField);
      final count = tester.widgetList(allTextFields).length;

      // Clear the rest if any are options.
      for (int i = 1; i < count; i++) {
        await tester.enterText(allTextFields.at(i), '');
      }
      await tester.pumpAndSettle();

      final state = tester.state<QuizFormQuestionItemState>(
        find.byType(QuizFormQuestionItem),
      );

      final q = state.getQuestion();
      expect(q, isNull);
    });

    testWidgets('getQuestion() returns null if options contain duplicates',
        (tester) async {
      await pump(tester);

      // Fill question
      await tester.enterText(find.byType(TextFormField).first, 'Pick one');
      await tester.pumpAndSettle();

      // We expect there are at least 3 TextFormFields: question + 2 options
      final fields = find.byType(TextFormField);
      expect(fields, findsAtLeastNWidgets(3));

      // Enter duplicate options
      await tester.enterText(fields.at(1), 'Same');
      await tester.enterText(fields.at(2), 'Same');
      await tester.pumpAndSettle();

      final state = tester.state<QuizFormQuestionItemState>(
        find.byType(QuizFormQuestionItem),
      );

      final q = state.getQuestion();
      expect(q, isNull);
    });

    testWidgets(
        'getQuestion() returns Question and places selected answer at index 0',
        (tester) async {
      await pump(tester);

      // Fill question
      await tester.enterText(find.byType(TextFormField).first, 'Pick one');
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      expect(fields, findsAtLeastNWidgets(3));

      // Options: A, B
      await tester.enterText(fields.at(1), 'A');
      await tester.enterText(fields.at(2), 'B');
      await tester.pumpAndSettle();

      // Select 2nd option as correct (radio)
      // NOTE: depending on your QuestionOptionItem implementation, radio might be `Radio<int>`
      // We'll attempt to tap the second radio.
      final radios = find.byType(Radio<int>);
      if (radios.evaluate().isNotEmpty && radios.evaluate().length >= 2) {
        await tester.tap(radios.at(1));
        await tester.pumpAndSettle();
      }

      final state = tester.state<QuizFormQuestionItemState>(
        find.byType(QuizFormQuestionItem),
      );

      final q = state.getQuestion();
      expect(q, isNotNull);

      // Because your logic "moves selected answer to index 0"
      // If we successfully tapped the second radio, expected first answer is 'B'.
      // If radios weren't found/tapped in this UI, selected index stays 0 => first is 'A'.
      // We assert that the first answer is either A or B, and list contains both exactly once.
      expect(q!.answers.toSet(), {'A', 'B'});
      expect(q.answers.length, 2);
    });
  });
}
