// ignore_for_file: library_prefixes, avoid_print, unused_local_variable

import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:medical_monitor/dio.dart';
import 'package:medical_monitor/models/call.dart';
import 'package:medical_monitor/models/medical.dart';
import 'package:medical_monitor/models/patient.dart';
import 'package:medical_monitor/models/prescription.dart';
import 'package:medical_monitor/models/showdoctors.dart';
import 'package:medical_monitor/models/statistic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medical_monitor/models/user.dart';
import 'package:medical_monitor/models/appointment.dart';

class Auth extends ChangeNotifier {
  bool _authenticated = false;
  bool _error = false;
  bool _errPassword = false;
  bool? role;
  User? _user;

  List<Statistic> statiLi = [];
  List<ShowDoctors> doctorsList = [];
  List<ShowMedical> medicalList = [];
  List<ShowPatient> patList = [];
  List<Appointment> appointList = [];
  List<Prescription> prescList = [];
  List<Call> CallList = [];
  String? _token;

  final storage = new FlutterSecureStorage();

  bool get authenticated => _authenticated;
  bool get error => _error;
  bool get errPassword => _errPassword;
  User? get user => _user;
  String? get token => _token;

  Future login({required Map credentials}) async {
    try {
      Dio.Response response = await dio().post(
        'https://1b625da6-8eb3-4218-9850-b37b5060dfee.mock.pstmn.io/login',
        options: Options(responseType: ResponseType.json),
        data: json.encode(credentials),
      );
      if (response.statusCode == 200) {
        print('reaches');
        print(json.decode(response.data)['token']);

        _token = json.decode(response.data)['token'];
        role = true;
        //json.decode(response.data)['value'];
        print(token);
        print(role);
        _error = false;

        await attempt(_token!);
      }
    } catch (e) {
      _error = true;
    }
  }

  Future attempt(String toke) async {
    try {
      // {"id" : 1 , "name" :"dd" , "first_name" : "Razane" , "last_name":"Guettala"  , "email" : "razane.guettala@gmail.com" , "phone_number":"0608420820" , "nss" : "" , "language":"en" , "birthday":"26-12-2000"}
      Dio.Response responseData = await dio().post(
        'https://c33db73b-b23d-4abf-89dc-664c2250847b.mock.pstmn.io/user',
        //   options: Dio.Options(headers: {'Authorization': 'Bearer $toke'})
        options: Options(responseType: ResponseType.json),
        data: "",
      );
      print(User.fromJson(json.decode(responseData.data)));
      _user = User.fromJson(json.decode(responseData.data));
      // storeToken(toke);
      _authenticated = true;
      print(_user);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future statics(String toke) async {
    try {
      final String? appointment_count;
      final String? patient_count;
      dynamic responseData = {"appointment_count": "2", "patient_count": "2"};
      //  Dio.Response responseData = await dio().get('link/statistics',
      options:
      Dio.Options(headers: {'Authorization': 'Bearer $toke'});
      //);

      // List<dynamic> medicalData = responseData;
      // json.decode(responseData.data);

      statiLi =
          responseData.map((midical) => Statistic.fromJson(midical)).toList();
      print(statiLi);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<List<ShowDoctors>> DoctorsList(String tok) async {
    print("Doctor  list here : ");

    final List<dynamic> showDoc = [
      {
        "id": 1000,
        "name": "Meftah Zouai",
        "email": "m.zouai@gmail.com",
        "speciality": "generalist",
        "hospital": "Hakim saadan"
      }
    ];
    try {
      // Dio.Response responseData = await dio().get('doctors',
      //     options: Dio.Options(headers: {'Authorization': 'Bearer $tok'}));

      // List<dynamic> doctorsData = json.decode(responseData.data);

      // تحويل البيانات إلى قائمة من كائنات ShowDoctors
      doctorsList =
          showDoc.map((doctor) => ShowDoctors.fromJson(doctor)).toList();

      print('here is list : ');
      print(doctorsList);
      readToken();
      notifyListeners();
      return doctorsList;
    } catch (e) {
      print(e.toString());
      return throw Error();
    }
  }

  Future MedicalList(String tok) async {
    try {
      // Dio.Response responseData = await dio().get('medical',
      //     options: Dio.Options(headers: {'Authorization': 'Bearer $tok'}));
      final String? date_en;
      final String? date_sor;
      final String? service_affec;
      final String? case_e;
      List<dynamic> medicalData = [
        {
          "date_en": "2024.07.26",
          "date_sor": "2024.12.26",
          "service_affec": "service A",
          "case_e": "case A",
        },
        {
          "date_en": "2024.07.26",
          "date_sor": "2024.12.26",
          "service_affec": "service A",
          "case_e": "case A",
        },
        {
          "date_en": "2024.07.26",
          "date_sor": "2024.12.26",
          "service_affec": "service A",
          "case_e": "case A",
        }
      ];
      // json.decode(responseData.data);

      medicalList =
          medicalData.map((midical) => ShowMedical.fromJson(midical)).toList();
      print(medicalList);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future patiList(String tok) async {
    try {
      Dio.Response responseData = await dio().get('patients',
          options: Dio.Options(headers: {'Authorization': 'Bearer $tok'}));

      List<dynamic> patientData = json.decode(responseData.data);

      patList = patientData.map((pa) => ShowPatient.fromJson(pa)).toList();
      print(patList);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future AppointmentList(String tok) async {
    try {
      Dio.Response responseData = await dio().get('appointActive',
          options: Dio.Options(headers: {'Authorization': 'Bearer $tok'}));
      final String? client;
      final String? doctor;
      final String? appointmentDate;
      final String? status;
      List<dynamic> appointmentData = [
        {
          "client": "Biskra hospital",
          "doctor": "dr. me",
          "appointmentDate": "2024.12.26 12:00:00",
          "status": "Sensitivity",
        }
      ];

      //List<dynamic> appointmentData = json.decode(responseData.data);

      appointList = appointmentData
          .map((appoint) => Appointment.fromJson(appoint))
          .toList();
      print(appointList);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future Calllist(String tok) async {
    try {
      Dio.Response responseData = await dio().get('viewCalling',
          options: Dio.Options(headers: {'Authorization': 'Bearer $tok'}));

      List<dynamic> callData = [
        {
          "id": 1,
          "namepatient": "Razane guettala",
          "namebed": "1",
          "nameroom": "1",
          "servicename": "disease",
          "casee": "1",
        }
      ];
      // json.decode(responseData.data);

      CallList = callData.map((call) => Call.fromJson(call)).toList();
      print(CallList);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future PrescriptionList(String tok) async {
    try {
      final String? prescription;
      final String? medicine;
      final String? doctor;
      final String? quantity;
      final String? description;
      final String? date_app;
      final data = {
        {
          "prescription": "p1",
          "medicine": "",
          "doctor": "Dr. me",
          "quantity": "2",
          "description": "this a medicine",
          "date_app": "2024.12.26 13:00:00",
        }
      };
      final responseData = data.toList();
      // Dio.Response responseData = await dio().get('/prescription',
      // options:
      // Dio.Options(headers: {'Authorization': 'Bearer $tok'});
      //);

      List<dynamic> prescriptionData = responseData;
      //json.decode(responseData);

      prescList = prescriptionData
          .map((prescrpt) => Prescription.fromJson(prescrpt))
          .toList();
      print(prescList);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  void storeToken(String token) async {
    await storage.write(key: 'auth', value: token);
  }

  Future readToken() async {
    String? tok = await storage.read(key: 'auth');
    _token = tok;
    return tok;
  }

  Future storeAppointment({required Map credentials}) async {
    try {
      Dio.Response response = await dio().post(
        'appointments',
        options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}),
        data: json.encode(credentials),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future update({required Map credentials}) async {
    try {
      Dio.Response response = await dio().post(
        'update',
        options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}),
        data: json.encode(credentials),
      );
      _errPassword = false;
      await attempt(_token!);
    } catch (e) {
      print(e.toString());
      _errPassword = true;
    }
  }

  Future calling({required Map credentials}) async {
    try {
      Dio.Response response = await dio().post(
        'calling',
        options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}),
        data: json.encode(credentials),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future storePatient({required Map credentials}) async {
    try {
      Dio.Response response = await dio().post(
        '/register',
        data: json.encode(credentials),
      );

      if (response.statusCode == 200) {
        print(json.decode(response.data));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future storeDoctor({required Map credentials}) async {
    Dio.Response response = await dio().post(
      'register',
      data: json.encode(credentials),
    );

    String msg = json.decode(response.toString())['data'];
    String error = json.decode(response.toString())['message'];

    print(msg);
  }

  void logout() async {
    try {
      Dio.Response response = await dio().get('logout',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      cleanup();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  void cleanup() async {
    _user = null;
    _authenticated = false;
    _token = null;
    // await storage.delete(key: 'auth');
  }
}
