import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/meal_model.dart';
import '../models/food_item_model.dart';
import '../providers/meal_provider.dart';
import '../providers/food_provider.dart';
import '../constants/app_constants.dart';
import 'package:intl/intl.dart';

class MealEntryScreen extends StatefulWidget {
  final DateTime date;
  const MealEntryScreen({super.key, required this.date});

  @override
  State<MealEntryScreen> createState() => _MealEntryScreenState();
}

class _MealEntryScreenState extends State<MealEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: "1");
  final _calController = TextEditingController();
  final _proController = TextEditingController();
  final _carbController = TextEditingController();
  final _fatController = TextEditingController();
  
  MealType _selectedType = MealType.breakfast;
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _saveMeal() {
    if (_formKey.currentState!.validate()) {
      final mealTime = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final meal = Meal(
        id: const Uuid().v4(),
        foodName: _nameController.text,
        quantity: double.parse(_qtyController.text),
        calories: double.parse(_calController.text),
        protein: double.parse(_proController.text),
        carbs: double.parse(_carbController.text),
        fats: double.parse(_fatController.text),
        type: _selectedType,
        time: mealTime,
        date: widget.date,
      );

      final error = Provider.of<MealProvider>(context, listen: false).validateMeal(meal);
      
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
        return;
      }

      Provider.of<MealProvider>(context, listen: false).addMeal(meal);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Meal added successfully!"), backgroundColor: AppColors.secondary),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log Meal")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTypeSelector(),
              const SizedBox(height: 20),
              _buildFoodSelector(),
              const SizedBox(height: 12),
              _buildTextField(_nameController, "Food Name", Icons.fastfood),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTextField(_qtyController, "Quantity", Icons.scale, isNumber: true, onChanged: (v) => _updateNutrition())),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ListTile(
                      title: const Text("Time"),
                      subtitle: Text(_selectedTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final TimeOfDay? time = await showTimePicker(context: context, initialTime: _selectedTime);
                        if (time != null) setState(() => _selectedTime = time);
                      },
                    ),
                  ),
                ],
              ),
              const Divider(height: 40),
              const Text("Nutrition Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField(_calController, "Calories", Icons.local_fire_department, isNumber: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField(_proController, "Protein (g)", Icons.fitness_center, isNumber: true)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTextField(_carbController, "Carbs (g)", Icons.grain, isNumber: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField(_fatController, "Fats (g)", Icons.opacity, isNumber: true)),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveMeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Save Entry", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FoodItem? _selectedFood;

  Widget _buildFoodSelector() {
    final foodProvider = Provider.of<FoodProvider>(context);
    return DropdownButtonFormField<FoodItem>(
      decoration: InputDecoration(
        labelText: "Select from Database",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: foodProvider.foods.map((food) {
        return DropdownMenuItem(
          value: food,
          child: Text(food.name),
        );
      }).toList(),
      onChanged: (food) {
        if (food != null) {
          setState(() {
            _selectedFood = food;
            _nameController.text = food.name;
            _updateNutrition();
          });
        }
      },
    );
  }

  void _updateNutrition() {
    if (_selectedFood != null && _qtyController.text.isNotEmpty) {
      double qty = double.tryParse(_qtyController.text) ?? 1.0;
      // Assuming database values are per 100 units/grams for some, or per unit. 
      // Let's assume they are per unit for simplicity here, or per 100g.
      // The DatabaseService seeded them as per 100g/unit approx.
      setState(() {
        _calController.text = (_selectedFood!.calories * qty).toStringAsFixed(1);
        _proController.text = (_selectedFood!.protein * qty).toStringAsFixed(1);
        _carbController.text = (_selectedFood!.carbs * qty).toStringAsFixed(1);
        _fatController.text = (_selectedFood!.fats * qty).toStringAsFixed(1);
      });
    }
  }

  Widget _buildTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: MealType.values.map((type) {
        bool isSelected = _selectedType == type;
        return GestureDetector(
          onTap: () => setState(() => _selectedType = type),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSelected ? AppColors.primary : Colors.grey),
            ),
            child: Text(
              type.name.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Required";
        if (isNumber && double.tryParse(value) == null) return "Invalid number";
        if (isNumber && double.parse(value) < 0) return "Cannot be negative";
        return null;
      },
    );
  }
}
