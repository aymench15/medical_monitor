import 'package:flutter/material.dart';
import 'package:medical_monitor/providers/auth.dart';
import 'package:medical_monitor/models/showdoctors.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowDoctorsList extends StatefulWidget {
  const ShowDoctorsList({Key? key}) : super(key: key);

  @override
  State<ShowDoctorsList> createState() => _ShowDoctorsListState();
}

class _ShowDoctorsListState extends State<ShowDoctorsList> {
  final Auth auth = Auth();
  List<ShowDoctors> filteredDoctorsList = [];
  List<ShowDoctors> doctorsList = [];

  @override
  void initState() {
    super.initState();
    // String? tokenValue;
    // auth.readToken().then((value) {
    setState(() {
      print("acceess !!");
      //  tokenValue = value;
      //  auth.DoctorsList(tokenValue!).then((doctorList) {
      auth.DoctorsList("s").then((doctorsList) {
        setState(() {
          doctorsList = auth.doctorsList;
          filteredDoctorsList = auth.doctorsList;
          print("here is the list");
          print(filteredDoctorsList);
        });
      });
    });
    // });
  }

  void filterDoctorsList(String keyword) {
    setState(() {
      filteredDoctorsList = doctorsList
          .where((doctor) =>
              doctor.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
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
          "Doctors List",
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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => filterDoctorsList(value),
              decoration: InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctorsList.length,
              itemBuilder: (context, index) {
                ShowDoctors doctor = filteredDoctorsList[index];
                return Card(
                  color: Color.fromARGB(255, 232, 238, 241),
                  elevation: 2, // Add elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Add rounded corners
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('images/d.png'),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          doctor.speciality ?? ' ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(doctor.hospital ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        'AppointmentPage',
                        arguments: {
                          'doctorId': doctor.id,
                          'doctorName': doctor.name,
                          'client': doctor.hospital,
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
