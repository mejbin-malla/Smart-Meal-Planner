import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import '../constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = userProvider.user;

    if (user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(context, user),
          const SizedBox(height: 32),
          const Text("Nutrition Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildGoalItem(context, "Daily Calories", "${user.calorieGoal.toInt()} kcal", Icons.local_fire_department, AppColors.calories),
          _buildGoalItem(context, "Protein Goal", "${user.proteinGoal.toInt()}g", Icons.fitness_center, AppColors.protein),
          _buildGoalItem(context, "Carbs Goal", "${user.carbGoal.toInt()}g", Icons.grain, AppColors.carbs),
          _buildGoalItem(context, "Fats Goal", "${user.fatGoal.toInt()}g", Icons.opacity, AppColors.fats),
          const SizedBox(height: 32),
          const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Switch between light and dark theme"),
            secondary: const Icon(Icons.dark_mode),
            value: themeProvider.isDarkMode,
            onChanged: (v) => themeProvider.toggleTheme(),
          ),
          ListTile(
            title: const Text("Export Data"),
            leading: const Icon(Icons.download),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () => userProvider.logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, var user) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(user.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text("${user.gender} • ${user.age.toInt()} years • ${user.weight.toInt()} kg", style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildGoalItem(BuildContext context, String label, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        onTap: () {
          // Logic to edit goal
        },
      ),
    );
  }
}
