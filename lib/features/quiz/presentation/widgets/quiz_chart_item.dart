import 'package:flutter/material.dart';

class QuizChartItem extends StatelessWidget {
  final String chartTitle;
  final Widget chartWidget;
  final List<Widget> infoWidget;

  const QuizChartItem({
    super.key,
    required this.chartTitle,
    required this.chartWidget,
    required this.infoWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 150,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chartTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...infoWidget,
              ],
            ),
            SizedBox(
              height: 140,
              width: 160,
              child: chartWidget,
            ),
          ],
        ),
      ),
    );
  }
}
