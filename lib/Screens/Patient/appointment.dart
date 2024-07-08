import 'package:flutter/material.dart';
import 'package:medical_monitor/widgets/original_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:medical_monitor/providers/auth.dart';
// Add the intl package
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medical_monitor/lang/local_keys.g.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  final Auth auth = Auth();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime(2023, 00, 00, 00, 00);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: _selectedDate.hour, minute: _selectedDate.minute));
    if (newTime == null) return;

    final newDateTime = DateTime(
        picked.year, picked.month, picked.day, newTime.hour, newTime.minute);

    setState(() {
      _selectedDate = newDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final doctorId = arguments?['doctorId'] as int?;
    final doctorName = arguments?['doctorName'] as String?;
    final client = arguments?['client'] as String?;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(19, 33, 110, 1),
        shadowColor: Color.fromARGB(255, 101, 180, 245),
        title: Text(
          LocaleKeys.Appointment.tr(),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      Text(
                        'Take Appointment',
                        style: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      TextFormField(
                        initialValue: doctorName,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Doctor Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: client,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Clinic or Hospital Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                          labelText: 'Reason',
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Select Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('yyyy-MM-dd HH:mm')
                                  .format(_selectedDate)),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                      OriginalButton(
                        text: 'Book Appointment',
                        onPressed: () {
                          Provider.of<Auth>(context, listen: false)
                              .storeAppointment(
                            credentials: {
                              'doctor_id': doctorId,
                              'client_id': client,
                              'reason': _reasonController.text,
                              'appointment_date': _selectedDate.toString(),
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Send successfully Wait for acceptance or rejection')),
                          );
                        },
                        textColor: Colors.white,
                        bgColor: const Color.fromRGBO(19, 33, 110, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
