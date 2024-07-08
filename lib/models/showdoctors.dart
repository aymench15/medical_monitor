class ShowDoctors {
  final int? id;
  final String name;
  final String email;
  final String? speciality;
  final String? hospital;

  ShowDoctors({
    required this.id,
    required this.name,
    required this.email,
    required this.speciality,
    required this.hospital,
  });

  factory ShowDoctors.fromJson(Map<String, dynamic> json) {
    return ShowDoctors(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      speciality: json["speciality"],
      hospital: json["hospital"],
    );
  }

  @override
  String toString() {
    return 'ShowDoctors{id: $id, name: $name, email: $email}';
  }
}
