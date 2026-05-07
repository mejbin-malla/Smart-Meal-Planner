import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;
  
  @HiveField(1)
  double age;
  
  @HiveField(2)
  double weight; // kg
  
  @HiveField(3)
  double height; // cm
  
  @HiveField(4)
  String gender;
  
  @HiveField(5)
  double calorieGoal;
  
  @HiveField(6)
  double proteinGoal;
  
  @HiveField(7)
  double carbGoal;
  
  @HiveField(8)
  double fatGoal;
  
  @HiveField(9)
  String? password;

  UserProfile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbGoal,
    required this.fatGoal,
    this.password,
  });
}
