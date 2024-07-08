// ignore_for_file: unused_import, non_constant_identifier_names

class Call {
  final int? id;
  final String? namepatient;
  final String? namebed;
  final String? nameroom;
  final String? servicename;
  final String? casee;

  Call({
    required this.id,
    required this.namepatient,
    required this.namebed,
    required this.nameroom,
    required this.servicename,
    required this.casee,
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      id: json["id"],
      namepatient: json["namepatient"],
      namebed: json["namebed"],
      nameroom: json["nameroom"],
      servicename: json["servicename"],
      casee: json["casee"],
    );
  }

  @override
  String toString() {
    return 'ShowUser{id:$id,name:$namepatient,bed:$namebed,room:$nameroom,service:$servicename,case:$casee }';
  }
}
