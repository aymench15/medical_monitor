import 'package:medical_monitor/models/medical.dart';
import 'package:flutter/material.dart';
import 'package:medical_monitor/providers/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicalInfo extends StatefulWidget {
  const MedicalInfo({Key? key}) : super(key: key);

  @override
  State<MedicalInfo> createState() => _MedicalInfoState();
}

class _MedicalInfoState extends State<MedicalInfo> {
  final Auth auth = Auth();
  List<ShowMedical> medicalsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    String? tokenValue;
    auth.readToken().then((value) {
      setState(() {
        tokenValue = value;
        auth.MedicalList(tokenValue!).then((medicalList) {
          setState(() {
            medicalsList = auth.medicalList;
            isLoading = false; // تحديث حالة التحميل بعد الحصول على القائمة
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(19, 33, 110, 1),
        shadowColor: Color.fromARGB(255, 101, 180, 245),
        title: Text(
          "Hospital Records",
          style: GoogleFonts.audiowide(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(
              'Historic',
              style: GoogleFonts.acme(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child:
                        CircularProgressIndicator()) // عرض مؤشر التحميل أثناء جلب البيانات
                : medicalsList.isEmpty
                    ? Center(
                        child: Text(
                            "No medical information available")) // عرض رسالة عندما تكون القائمة فارغة
                    : ListView.builder(
                        itemCount: medicalsList.length,
                        itemBuilder: (context, index) {
                          ShowMedical medical = medicalsList[index];
                          return Card(
                            color: Color.fromARGB(255, 238, 244, 247),
                            elevation: 2, // Add elevation for a shadow effect
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Add rounded corners
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                    AssetImage('images/medical_info.png'),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Historic ${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                              subtitle: Text(medical.service_affec.toString()),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  'details',
                                  arguments: {
                                    'case': medical.case_e,
                                    'date': medical.date_en,
                                    'date_sor': medical.date_sor,
                                    'service': medical.service_affec,
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
