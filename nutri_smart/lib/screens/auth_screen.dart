import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    _isLogin = Provider.of<UserProvider>(context, listen: false).hasProfile;
  }

  // Sign up specific controllers
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _gender = "Male";

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String? error;

      if (_isLogin) {
        error = await userProvider.login(_nameController.text, _passwordController.text);
      } else {
        final user = UserProfile(
          name: _nameController.text,
          password: _passwordController.text,
          age: double.parse(_ageController.text),
          weight: double.parse(_weightController.text),
          height: double.parse(_heightController.text),
          gender: _gender,
          calorieGoal: 2000,
          proteinGoal: 150,
          carbGoal: 250,
          fatGoal: 70,
        );
        error = await userProvider.register(user);
      }

      if (error != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.restaurant_menu, size: 60, color: AppColors.primary),
                        const SizedBox(height: 16),
                        Text(
                          _isLogin ? "Login to NutriSmart" : "Create Account",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 32),
                        _buildTextField(_nameController, "User Name", Icons.person),
                        const SizedBox(height: 16),
                        _buildTextField(_passwordController, "Password", Icons.lock, isPassword: true),
                        
                        if (!_isLogin) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildTextField(_ageController, "Age", Icons.calendar_today, isNumber: true)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTextField(_weightController, "Weight", Icons.monitor_weight, isNumber: true)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(_heightController, "Height (cm)", Icons.height, isNumber: true),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Radio(value: "Male", groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)),
                              const Text("Male"),
                              Radio(value: "Female", groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)),
                              const Text("Female"),
                            ],
                          ),
                        ],
                        
                        const SizedBox(height: 32),
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
                            child: Text(_isLogin ? "Login" : "Sign Up"),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          child: Text(_isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
    );
  }
}
