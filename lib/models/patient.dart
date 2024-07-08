// ignore_for_file: unused_import, non_constant_identifier_names
class ShowPatient {
  final String? name;
  final String? phone_number;

  ShowPatient({
    required this.name,
    required this.phone_number,
  });

  factory ShowPatient.fromJson(Map<String, dynamic> json) {
    return ShowPatient(
      name: json["name"],
      phone_number: json["phoneNumber"],
    );
  }

  @override
  String toString() {
    return 'ShowPatient{ name:$name, phone Number:$phone_number}';
  }
}
