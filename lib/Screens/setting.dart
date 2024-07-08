import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medical_monitor/lang/local_keys.g.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('ar'),
    const Locale('fr'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.language.tr(),
          style: GoogleFonts.audiowide(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 101, 180, 245),
        shadowColor: Color.fromARGB(255, 101, 180, 245),
      ),
      body: ListView.builder(
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) {
          Locale locale = supportedLocales[index];

          return ListTile(
            leading: Icon(Icons.language),
            title: Text(
              locale.languageCode,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () async {
              await context.setLocale(locale);
            },
          );
        },
      ),
    );
  }
}
