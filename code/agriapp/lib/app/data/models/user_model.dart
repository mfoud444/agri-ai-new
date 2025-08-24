import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? firstName;

  @HiveField(2)
  String? lastName;

  @HiveField(3)
  String? avatarUrl;

  @HiveField(4)
  String? dateOfBirth;

  @HiveField(5)
  bool? state;

  @HiveField(6)
  String? gender;

  @HiveField(7)
  String? userType;

  @HiveField(8)
  String? country;

  @HiveField(9)
  String? createdAt;

  @HiveField(10)
  String? updatedAt;

  @HiveField(11)
  String? email;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.avatarUrl,
      this.dateOfBirth,
      this.state,
      this.gender,
      this.userType,
      this.country,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
       email = json['email'];
    avatarUrl = json['avatar_url'];
    dateOfBirth = json['date_of_birth'];
    state = json['state'];
    gender = json['gender'];
    userType = json['user_type'];
    country = json['country'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
     data['email'] = email;
    data['avatar_url'] = avatarUrl;
    data['date_of_birth'] = dateOfBirth;
    data['state'] = state;
    data['gender'] = gender;
    data['user_type'] = userType;
    data['country'] = country;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
