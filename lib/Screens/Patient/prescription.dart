import 'package:flutter/material.dart';
import 'package:medical_monitor/providers/auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/prescription.dart';

class PrescriptionLis extends StatefulWidget {
  const PrescriptionLis({super.key});

  @override
  State<PrescriptionLis> createState() => _PrescriptionLisState();
}

class _PrescriptionLisState extends State<PrescriptionLis> {
  final Auth auth = Auth();
  List<Prescription> presctList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    String? tokenValue;
    auth.readToken().then((value) {
      setState(() {
        tokenValue = value;
        auth.PrescriptionList(tokenValue!).then((prescList) {
          setState(() {
            presctList = auth.prescList;
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
          "Prescriptions",
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
              'My Prescriptions List',
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
                : presctList.isEmpty
                    ? Center(
                        child: Text(
                            "No prescriptions available")) // عرض رسالة عندما تكون القائمة فارغة
                    : ListView.builder(
                        itemCount: presctList.length,
                        itemBuilder: (context, index) {
                          Prescription pre = presctList[index];
                          return Card(
                            color: Color.fromARGB(255, 232, 238, 241),
                            elevation: 2, // Add elevation for a shadow effect
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Add rounded corners
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16), // Add padding
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('images/presc.PNG'),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'prescription ${pre.prescription ?? ''}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Dr.${pre.doctor ?? ''}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                pre.date_app ??
                                    '', // Replace with your desired subtitle text
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 56, 56, 56),
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  'detaiPre',
                                  arguments: {
                                    'prescription': pre.prescription,
                                    'doctor': pre.doctor,
                                    'medicine': pre.medicine,
                                    'quantity': pre.quantity,
                                    'description': pre.description,
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
