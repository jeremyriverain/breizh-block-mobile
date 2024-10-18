import 'package:flutter/material.dart';

class BoulderAreaDetailsPerformanceTabProgressTracker extends StatelessWidget {
  const BoulderAreaDetailsPerformanceTabProgressTracker({
    required this.completed,
    required this.total,
    required this.label,
    super.key,
  });

  final int completed;
  final int total;
  final String label;

  @override
  Widget build(BuildContext context) {
    final progress = completed / total;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 14,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.amber,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$completed',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
