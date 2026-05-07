import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../models/meal_model.dart';
import '../constants/app_constants.dart';
import 'package:intl/intl.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String _searchQuery = "";
  MealType? _selectedType;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final filteredMeals = mealProvider.meals.where((meal) {
      final matchesName = meal.foodName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == null || meal.type == _selectedType;
      final matchesDate = _selectedDate == null || 
          (meal.date.year == _selectedDate!.year && 
           meal.date.month == _selectedDate!.month && 
           meal.date.day == _selectedDate!.day);
      return matchesName && matchesType && matchesDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search & Filter"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search meals...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterChip(
                        label: _selectedType == null ? "All Types" : _selectedType!.name.toUpperCase(),
                        icon: Icons.restaurant,
                        onTap: _showTypePicker,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterChip(
                        label: _selectedDate == null ? "All Dates" : DateFormat('MMM d').format(_selectedDate!),
                        icon: Icons.calendar_today,
                        onTap: _showDatePicker,
                      ),
                    ),
                    if (_selectedType != null || _selectedDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () => setState(() {
                          _selectedType = null;
                          _selectedDate = null;
                        }),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: filteredMeals.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) => _buildMealCard(filteredMeals[index]),
            ),
    );
  }

  Widget _buildFilterChip({required String label, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(Meal meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(meal.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${meal.type.name.toUpperCase()} • ${DateFormat('MMM d, hh:mm a').format(meal.time)}"),
        trailing: Text("${meal.calories.toInt()} kcal", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No meals found matching your filters.", style: TextStyle(color: Colors.grey)),
    );
  }

  void _showTypePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text("All Types"), onTap: () { setState(() => _selectedType = null); Navigator.pop(context); }),
          ...MealType.values.map((type) => ListTile(
            title: Text(type.name.toUpperCase()),
            onTap: () { setState(() => _selectedType = type); Navigator.pop(context); },
          )),
        ],
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }
}
