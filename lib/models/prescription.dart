class Prescription {
  final String? prescription;
  final String? medicine;
  final String? doctor;
  final String? quantity;
  final String? description;
  final String? date_app;

  Prescription(
      {required this.prescription,
      required this.medicine,
      required this.doctor,
      required this.quantity,
      required this.description,
      required this.date_app});

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      prescription: json["prescription"].toString(),
      medicine: json["medicine"],
      doctor: json["doctor"],
      quantity: json["quantity"].toString(),
      description: json["description"],
      date_app: json["date_app"].toString(),
    );
  }

  @override
  String toString() {
    return 'Prescription{ prescription:$prescription,medicine:$medicine,doctor:$doctor, dosage:$quantity,duration:$description,date:$date_app}';
  }
}
