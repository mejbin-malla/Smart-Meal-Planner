// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 3;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      name: fields[0] as String,
      age: fields[1] as double,
      weight: fields[2] as double,
      height: fields[3] as double,
      gender: fields[4] as String,
      calorieGoal: fields[5] as double,
      proteinGoal: fields[6] as double,
      carbGoal: fields[7] as double,
      fatGoal: fields[8] as double,
      password: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.calorieGoal)
      ..writeByte(6)
      ..write(obj.proteinGoal)
      ..writeByte(7)
      ..write(obj.carbGoal)
      ..writeByte(8)
      ..write(obj.fatGoal)
      ..writeByte(9)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
