class ShowMedical {
  final String? date_en;
  final String? date_sor;
  final String? service_affec;
  final String? case_e;

  ShowMedical({
    required this.date_en,
    required this.date_sor,
    required this.service_affec,
    required this.case_e,
  });

  factory ShowMedical.fromJson(Map<String, dynamic> json) {
    return ShowMedical(
        date_en: json["date_en"],
        date_sor: json["date_sor"],
        service_affec: json["service_affec"],
        case_e: json["case_e"]);
  }

  @override
  String toString() {
    return 'ShowMedical{ date_en:$date_en, date:$date_sor, service: $service_affec,case:$case_e}';
  }
}
