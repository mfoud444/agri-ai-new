// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      avatarUrl: fields[3] as String?,
      dateOfBirth: fields[4] as String?,
      state: fields[5] as bool?,
      gender: fields[6] as String?,
      userType: fields[7] as String?,
      country: fields[8] as String?,
      createdAt: fields[9] as String?,
      updatedAt: fields[10] as String?,
      email: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.dateOfBirth)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.userType)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
