import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../constants/app_constants.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final weeklyData = _getWeeklyData(mealProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Nutrition Analytics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Weekly Calorie Trends", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(weeklyData) + 500,
                  barGroups: weeklyData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: AppColors.primary,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(DateFormat('E').format(date), style: const TextStyle(fontSize: 10)),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildMacroDistribution(mealProvider),
          ],
        ),
      ),
    );
  }

  List<double> _getWeeklyData(MealProvider provider) {
    final today = DateTime.now();
    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      return provider.getTotalCalories(date);
    });
  }

  double _getMaxY(List<double> data) {
    return data.reduce((a, b) => a > b ? a : b);
  }

  Widget _buildMacroDistribution(MealProvider provider) {
    final today = DateTime.now();
    final p = provider.getTotalProtein(today);
    final c = provider.getTotalCarbs(today);
    final f = provider.getTotalFats(today);
    final total = p + c + f;

    if (total == 0) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today's Macro Ratio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            _macroItem("Protein", p / total, AppColors.protein),
            _macroItem("Carbs", c / total, AppColors.carbs),
            _macroItem("Fats", f / total, AppColors.fats),
          ],
        ),
      ],
    );
  }

  Widget _macroItem(String label, double ratio, Color color) {
    return Expanded(
      flex: (ratio * 100).toInt(),
      child: Column(
        children: [
          Container(height: 8, color: color),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          Text("${(ratio * 100).toInt()}%", style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
