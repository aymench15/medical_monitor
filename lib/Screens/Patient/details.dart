import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _detailsState();
}

class _detailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String? caseValue = arguments!['case'];
    final String? dateValue = arguments['date'];
    final String? dateSorValue = arguments['date_sor'];
    final String? serviceValue = arguments['service'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(19, 33, 110, 1),
        shadowColor: Color.fromARGB(255, 101, 180, 245),
        title: Text(
          'Details',
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Image.asset(
            'images/details.png',
            width: 200,
            height: 150,
          ),
        ),
        const SizedBox(height: 50),
        TextFormField(
          initialValue: caseValue,
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Case',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            prefixIcon: Icon(Icons.info),
          ),
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: dateValue,
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Date Entre',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            prefixIcon: Icon(Icons.date_range),
          ),
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: dateSorValue ??
              'Not out yet', // Use the null coalescing operator to provide a default value of '' if dateSorValue is null
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Date Sortie',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            prefixIcon: Icon(Icons.date_range),
          ),
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: serviceValue,
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Service Name',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            prefixIcon: Icon(Icons.room_service_outlined),
          ),
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
      ]),
    );
  }
}
