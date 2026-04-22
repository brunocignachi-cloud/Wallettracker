class UserModel {
  final String id;
  final String name;
  final String email;
  final bool premium;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.premium,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      premium: json['premium'],
    );
  }
}