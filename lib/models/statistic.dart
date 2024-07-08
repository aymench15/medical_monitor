// ignore_for_file: unused_import, non_constant_identifier_names

class Statistic {
  final String? appointment_count;
  final String? patient_count;

  Statistic({
    required this.appointment_count,
    required this.patient_count,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      appointment_count: json["appointment_count"].toString(),
      patient_count: json["patient_count"].toString(),
    );
  }

  @override
  String toString() {
    return 'ShowUser{patient_count:$patient_count ,appointment_count:$appointment_count}';
  }
}
