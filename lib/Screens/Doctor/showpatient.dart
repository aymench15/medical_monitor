import 'package:medical_monitor/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:medical_monitor/providers/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Patient extends StatefulWidget {
  const Patient({super.key});

  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  final Auth auth = Auth();
  List<ShowPatient> pList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    String? tokenValue;
    // auth.readToken().then((value) {
    setState(() {
      //    tokenValue = value;
      auth.patiList(tokenValue!).then((patList) {
        setState(() {
          pList = auth.patList;
          isLoading = false; // تحديث حالة التحميل بعد الحصول على القائمة
        });
      });
    });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 101, 180, 245),
        shadowColor: Color.fromARGB(255, 101, 180, 245),
        title: Text(
          "Patients ",
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
              'Your patients',
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
                : pList.isEmpty
                    ? Center(
                        child: Text(
                            "No patients available")) // عرض رسالة عندما تكون القائمة فارغة
                    : ListView.builder(
                        itemCount: pList.length,
                        itemBuilder: (context, index) {
                          ShowPatient patt = pList[index];
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
                                    AssetImage('images/patient.png'),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patt.name ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                              subtitle: Text(patt.phone_number ?? ''),
                              trailing: const Icon(Icons.person_pin),
                              onTap: () {},
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
