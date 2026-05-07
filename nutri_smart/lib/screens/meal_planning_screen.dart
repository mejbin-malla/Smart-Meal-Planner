import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../models/meal_model.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import 'meal_entry_screen.dart';

class MealPlanningScreen extends StatefulWidget {
  const MealPlanningScreen({super.key});

  @override
  State<MealPlanningScreen> createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final meals = mealProvider.getMealsByDate(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Planning"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateHeader(),
          Expanded(
            child: meals.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: meals.length,
                    itemBuilder: (context, index) => _buildMealCard(meals[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MealEntryScreen(date: _selectedDate)),
        ),
        icon: const Icon(Icons.add),
        label: const Text("Log Meal"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: AppColors.primary.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1))),
          ),
          Text(
            DateFormat('EEEE, MMM d').format(_selectedDate),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1))),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(Meal meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getMealColor(meal.type).withOpacity(0.1),
          child: Icon(_getMealIcon(meal.type), color: _getMealColor(meal.type)),
        ),
        title: Text(meal.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${meal.type.name.toUpperCase()} • ${DateFormat('hh:mm a').format(meal.time)}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${meal.calories.toInt()} kcal", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            Text("${meal.protein.toInt()}g P | ${meal.carbs.toInt()}g C", style: const TextStyle(fontSize: 12)),
          ],
        ),
        onLongPress: () => _showDeleteDialog(meal),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 80, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text("No meals logged for this day.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showDeleteDialog(Meal meal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Meal?"),
        content: const Text("Are you sure you want to remove this entry?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Provider.of<MealProvider>(context, listen: false).deleteMeal(meal.id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getMealColor(MealType type) {
    switch (type) {
      case MealType.breakfast: return Colors.orange;
      case MealType.lunch: return Colors.green;
      case MealType.dinner: return Colors.blue;
      case MealType.snack: return Colors.purple;
    }
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast: return Icons.wb_sunny_outlined;
      case MealType.lunch: return Icons.light_mode_outlined;
      case MealType.dinner: return Icons.nights_stay_outlined;
      case MealType.snack: return Icons.cookie_outlined;
    }
  }
}
