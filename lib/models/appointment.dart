class Appointment {
  final String? client;
  final String? doctor;
  final String? appointmentDate;
  final String? status;

  Appointment(
      {required this.client,
      required this.doctor,
      required this.appointmentDate,
      required this.status});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      client: json["client"],
      doctor: json["doctor"],
      appointmentDate: json["appointment_date"],
      status: json["status"],
    );
  }

  @override
  String toString() {
    return 'Appointment{ client:$client,doctor:$doctor, date:$appointmentDate,status:$status}';
  }
}
