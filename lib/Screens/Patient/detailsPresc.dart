import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsPre extends StatefulWidget {
  const DetailsPre({super.key});

  @override
  State<DetailsPre> createState() => _DetailsPreState();
}

class _DetailsPreState extends State<DetailsPre> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String? doctorName = arguments!['doctor'];
    final String? medicine = arguments['medicine'];
    final String? dosage = arguments['quantity'];
    final String? duration = arguments['description'];
    final String? prescription = arguments['prescription'];

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
        SizedBox(
          height: 30,
        ),
        Center(
          child: Image.asset(
            'images/prescription.png',
            width: 200,
            height: 150,
          ),
        ),
        const SizedBox(height: 50),
        TextFormField(
          initialValue: doctorName,
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Doctor Name',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            prefixIcon: Icon(
              Icons.person,
              size: 28,
              color: Colors.blue,
            ),
          ),
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: prescription,
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Prescription Number',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            prefixIcon: Icon(
              Icons.description,
              size: 28,
              color: Colors.blue,
            ),
          ),
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: medicine,
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Medicine',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            prefixIcon: Icon(
              Icons.local_pharmacy,
              size: 28,
              color: Colors.blue,
            ),
          ),
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity, // Adjust the width as needed
          height: 100, // Adjust the height as needed
          child: TextFormField(
            initialValue: dosage,
            enabled: false,
            maxLines: null, // Allow the field to expand vertically
            decoration: const InputDecoration(
              labelText: 'Quantity',
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              prefixIcon: Icon(
                Icons.numbers,
                size: 28,
                color: Colors.blue,
              ),
            ),
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 15, // Increase the font size of the text
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          initialValue: duration,
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            prefixIcon: Icon(
              Icons.hourglass_bottom,
              size: 28,
              color: Colors.blue,
            ),
          ),
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
      ]),
    );
  }
}
