import 'package:flutter/material.dart';

class QuestionSummary extends StatelessWidget {
  const QuestionSummary({
    super.key,
    required this.summaryData,
  });

  final List<Map<String, dynamic>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: summaryData.map((data) {
            final isCorrectAnswer =
                data['user_answer'] == data['correct_answer'];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(100),
                      color: isCorrectAnswer
                          ? const Color.fromARGB(255, 163, 183, 225)
                          : const Color.fromARGB(255, 198, 50, 168),
                      // shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${data['question_index'] + 1}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['question'],
                          style: const TextStyle(
                            color: Color.fromARGB(255, 197, 185, 228),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['user_answer'],
                          style: const TextStyle(
                            color: Color.fromARGB(255, 198, 50, 168),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                        Text(
                          data['correct_answer'],
                          style: const TextStyle(
                            color: Color.fromARGB(255, 140, 114, 225),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
