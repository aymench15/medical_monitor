// ignore_for_file: deprecated_member_use, prefer_const_constructors, file_names, use_key_in_widget_constructors

import 'package:medical_monitor/widgets/original_button.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topRight,
              colors: [
                Colors.white,
                Colors.blueGrey,
                Colors.lightBlue,
              ]),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(),
                Image.asset('images/home_logo.png', width: 300, height: 300),
                OriginalButton(
                  text: 'Get Started',
                  onPressed: () => Navigator.of(context).pushNamed('login'),
                  textColor: Color.fromARGB(255, 97, 169, 202),
                  bgColor: Color.fromARGB(255, 248, 221, 235),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
