// ignore_for_file: unused_import, non_constant_identifier_names

class User {
  final int? id;
  final String? name;
  final String? first_name;
  final String? last_name;
  final String? email;
  final String? phone_number;
  final String? nss;
  final String? language;
  final String? birthday;

  User({
    required this.id,
    required this.name,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone_number,
    required this.nss,
    required this.language,
    required this.birthday,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      email: json["email"],
      phone_number: json["phone_number"],
      nss: json["nss"],
      language: json["language"],
      birthday: json["birthday"],
    );
  }

  String get languag => language ?? '';

  @override
  String toString() {
    return 'ShowUser{id: $id, name: $name, email: $email, birthday: $birthday, language: $language}';
  }
}
