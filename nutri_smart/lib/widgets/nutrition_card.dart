import 'package:flutter/material.dart';

class NutritionCard extends StatelessWidget {
  final String label;
  final double value;
  final double goal;
  final Color color;
  final String unit;

  const NutritionCard({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (value / goal).clamp(0.0, 1.0);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percentage,
                  color: color,
                  backgroundColor: color.withOpacity(0.1),
                  strokeWidth: 8,
                ),
                Text(
                  "${(percentage * 100).toInt()}%",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "${value.toInt()}/$goal$unit",
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
