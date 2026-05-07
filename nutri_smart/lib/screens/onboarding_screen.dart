import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _gender = "Male";

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = UserProfile(
        name: _nameController.text,
        age: double.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        gender: _gender,
        calorieGoal: 2000, // Defaults, can be updated later
        proteinGoal: 150,
        carbGoal: 250,
        fatGoal: 70,
      );
      
      Provider.of<UserProvider>(context, listen: false).setupProfile(user);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to NutriSmart!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text("Tell us a bit about yourself to get started."),
              const SizedBox(height: 32),
              
              _buildTextField(_nameController, "Name", Icons.person, TextInputType.name),
              const SizedBox(height: 16),
              _buildTextField(_ageController, "Age", Icons.calendar_today, TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(_weightController, "Weight (kg)", Icons.monitor_weight, TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(_heightController, "Height (cm)", Icons.height, TextInputType.number),
              const SizedBox(height: 16),
              
              const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio(value: "Male", groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)),
                  const Text("Male"),
                  const SizedBox(width: 20),
                  Radio(value: "Female", groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)),
                  const Text("Female"),
                ],
              ),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Continue", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
      validator: (value) => value == null || value.isEmpty ? "Required" : null,
    );
  }
}
