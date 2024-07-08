// ignore_for_file: prefer_const_constructors, unused_import

import 'package:medical_monitor/Screens/Doctor/showpatient.dart';
import 'package:medical_monitor/Screens/Patient/appointment.dart';
import 'package:medical_monitor/Screens/Patient/details.dart';
import 'package:medical_monitor/Screens/Patient/detailsPresc.dart';
import 'package:medical_monitor/Screens/Patient/logout.dart';
import 'package:medical_monitor/Screens/Patient/medical_information.dart';
import 'package:medical_monitor/Screens/Patient/password.dart';
import 'package:medical_monitor/Screens/Patient/prescription.dart';
import 'package:medical_monitor/Screens/auth_screen.dart';
import 'package:medical_monitor/Screens/Doctor/menu_doctor.dart';
import 'package:medical_monitor/Screens/setting.dart';
import 'package:medical_monitor/components/applocal.dart';
import 'package:medical_monitor/lang/codegen_loader.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medical_monitor/Screens/register_screen.dart';
import 'package:medical_monitor/providers/auth.dart';
import 'package:medical_monitor/Screens/Patient/menu_screen.dart';
import 'package:medical_monitor/Screens/Patient/profile_screen.dart';
import 'package:medical_monitor/Screens/Patient/show_list_doctor.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import 'package:workmanager/workmanager.dart';

import 'Screens/Patient/form.dart';
import 'models/prescription.dart';

void main() async {
  String? languag = 'en';

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => Auth(),
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
          Locale('ar')
        ], // Add your supported locales here
        fallbackLocale: Locale(languag), // Set your fallback locale
        path: 'lang', // Set the path to your translations folder
        assetLoader: const CodegenLoader(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Day Todo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color.fromARGB(255, 230, 241, 250),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      home: AuthScreen(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routes: {
        'login': (context) => AuthScreen(),
        'register': (context) => RegisterScreen(),
        'menu': (context) => MenuScreen(),
        'menudoctor': (context) => MenuScreendoctor(),
        'profile': (context) => ProfilePage(),
        'showDoctors': (context) => ShowDoctorsList(),
        'AppointmentPage': (context) => Appointment(),
        'MedicalInfo': (context) => MedicalInfo(),
        'details': (context) => Details(),
        'password': (context) => Password(),
        'logout': (context) => LogoutDialog(),
        'prescript': (context) => PrescriptionLis(),
        'detaiPre': (context) => DetailsPre(),
        'patient': (context) => Patient(),
        'Setting': (context) => Setting(),
        'Informations': (context) => Informations(),
      },
    );
  }
}
