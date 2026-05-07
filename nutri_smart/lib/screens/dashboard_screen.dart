import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'meal_entry_screen.dart';
import 'search_filter_screen.dart';
import '../providers/meal_provider.dart';
import '../providers/user_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/nutrition_card.dart';
import '../widgets/daily_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    
    if (user == null) return const Center(child: CircularProgressIndicator());

    final today = DateTime.now();
    final totalCals = mealProvider.getTotalCalories(today);
    final totalProtein = mealProvider.getTotalProtein(today);
    final totalCarbs = mealProvider.getTotalCarbs(today);
    final totalFats = mealProvider.getTotalFats(today);

    return Scaffold(
      appBar: AppBar(
        title: const Text("NutriSmart Dashboard"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${user.name}!",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text("Track your nutrition goals for today."),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.primary),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchFilterScreen())),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            DailySummaryCard(
              consumed: totalCals,
              goal: user.calorieGoal,
            ),
            
            const SizedBox(height: 24),
            const Text("Nutrition Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: NutritionCard(
                    label: "Protein",
                    value: totalProtein,
                    goal: user.proteinGoal,
                    color: AppColors.protein,
                    unit: "g",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NutritionCard(
                    label: "Carbs",
                    value: totalCarbs,
                    goal: user.carbGoal,
                    color: AppColors.carbs,
                    unit: "g",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NutritionCard(
                    label: "Fats",
                    value: totalFats,
                    goal: user.fatGoal,
                    color: AppColors.fats,
                    unit: "g",
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            _buildWaterTracker(context, mealProvider),
            const SizedBox(height: 24),
            _buildRecentMeals(context, mealProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterTracker(BuildContext context, MealProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Water Intake", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Stay hydrated! (Goal: 8 glasses)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Text("${provider.waterGlasses}/8", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => provider.removeWater(),
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                ),
                Wrap(
                  spacing: 4,
                  children: List.generate(8, (index) {
                    return Icon(
                      index < provider.waterGlasses ? Icons.water_drop : Icons.water_drop_outlined,
                      color: index < provider.waterGlasses ? Colors.blue : Colors.grey.withOpacity(0.3),
                      size: 24,
                    );
                  }),
                ),
                IconButton(
                  onPressed: () => provider.addWater(),
                  icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMeals(BuildContext context, MealProvider provider) {
    final recentMeals = provider.meals.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recent Meals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (recentMeals.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text("No meals logged yet.", style: TextStyle(color: Colors.grey))),
            ),
          )
        else
          ...recentMeals.map((meal) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.restaurant, color: AppColors.primary, size: 20),
                  ),
                  title: Text(meal.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${meal.type.name} • ${meal.calories.toInt()} kcal"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to meal details if needed
                  },
                ),
              )).toList(),
      ],
    );
  }
}
