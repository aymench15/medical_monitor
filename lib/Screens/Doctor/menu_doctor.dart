import 'package:easy_localization/easy_localization.dart';
import 'package:medical_monitor/lang/local_keys.g.dart';
import 'package:medical_monitor/models/statistic.dart';
import 'package:flutter/material.dart';
import 'package:medical_monitor/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:medical_monitor/models/call.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class MenuScreendoctor extends StatefulWidget {
  const MenuScreendoctor({super.key});

  @override
  State<MenuScreendoctor> createState() => _MenuScreendoctorState();
}

class _MenuScreendoctorState extends State<MenuScreendoctor> {
  final Auth auth = Auth();
  int _currentIndex = 0;
  List<Call> cllList = [];
  List<Statistic> stList = [];
  bool isLoading = true;
  Timer? timer;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    //loadData();
    stateData();
    WidgetsFlutterBinding.ensureInitialized();
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    final settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings =
        InitializationSettings(android: settingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    Workmanager().registerPeriodicTask(
      'data_loading_task',
      'data_loading_task',
      frequency: Duration(seconds: 30),
    );
    startTimer();
  }

  void loadData() {
    String? tokenValue;
    auth.readToken().then((value) {
      setState(() {
        tokenValue = value;
      });
      auth.Calllist(tokenValue!).then((CallList) {
        setState(() {
          cllList = auth.CallList;
          isLoading = false;
          if (cllList.isNotEmpty) {
            showNotification();
          }
        });
      });
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 30), (_) {
      loadData();
    });
  }

  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) {
      loadData();
      return Future.value(true);
    });
  }

  void stateData() {
    String? tokenValue;
    // auth.readToken().then((value) {
    setState(() {
      //  tokenValue = value;
      auth.statics(tokenValue!).then((statiLi) {
        setState(() {
          stList = auth.statiLi;
          isLoading = false;
        });
      });
    });
    // });
  }

  void showNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      //sound: RawResourceAndroidNotificationSound('notification'), // Use custom notification sound
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'New call received',
      'You have a new call',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            if (auth.authenticated) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topRight,
                        colors: [
                          Color.fromARGB(255, 126, 160, 177),
                          Color.fromARGB(255, 101, 180, 245)
                        ],
                      ),
                    ),
                    accountName: Text(
                      auth.user?.name ?? '',
                      style: GoogleFonts.audiowide(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    accountEmail: Text(
                      auth.user?.email ?? '',
                      style: GoogleFonts.audiowide(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage(
                          'images/avatar-doc.jpg'), // Replace with your image path
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(
                      LocaleKeys.profile.tr(),
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 77, 70, 70),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('profile');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: Text(
                      LocaleKeys.listPatient.tr(),
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 77, 70, 70),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('patient');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(
                      LocaleKeys.language.tr(),
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 77, 70, 70),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('Setting');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(
                      LocaleKeys.logout.tr(),
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 77, 70, 70),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            LocaleKeys.logout.tr(),
                            style: GoogleFonts.acme(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 77, 70, 70),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to logout?',
                            style: GoogleFonts.acme(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 77, 70, 70),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Provider.of<Auth>(context, listen: false)
                                    .logout();
                                Navigator.of(context).pushNamed('login');
                              },
                              child: Text(
                                LocaleKeys.logout.tr(),
                                style: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 35, 176, 219),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // User clicked on "Cancel"
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 35, 176, 219),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 101, 180, 245),
        shadowColor: Color.fromARGB(255, 101, 180, 245),
      ),
      body: _currentIndex == 0 ? _buildCallPage() : _buildAppointmentsPage(),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromARGB(255, 101, 180, 245),
        backgroundColor: Colors.white,
        height: 50,
        animationDuration: Duration(milliseconds: 200),
        items: [
          Icon(
            Icons.pie_chart,
            size: 25,
            color: Colors.white,
          ),
          Icon(
            Icons.call,
            size: 25,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 0) {
                stateData(); // Call loadData() when appointment index is selected
              }
            });
          } else {
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 1) {
                loadData(); //loadData(); // Call loadData() when appointment index is selected
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildCallPage() {
    return Container(
      decoration: BoxDecoration(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        color: Color.fromRGBO(
            247, 244, 244, 1), // Adjust the opacity and color as needed
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 65),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                child: Image.asset(
                  'images/doctorHealthcare.jpeg', // Replace with your own image path
                  width: 500.0,
                  height: 250.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  color: Color.fromRGBO(247, 244, 244, 1),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // عدد العناصر في الصفوف الأفقية
                      childAspectRatio: 3, // نسبة العرض إلى الارتفاع لكل عنصر
                    ),
                    itemCount: stList.length,
                    itemBuilder: (context, index) {
                      Statistic st = stList[index];
                      return Card(
                        color: Color.fromARGB(255, 232, 238, 241),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 128, 194, 248),
                            radius: 45,
                            child: Icon(Icons.bar_chart,
                                color: Colors.white, size: 40),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.Statist.tr(),
                                style: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 118, 152, 245),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Icon(Icons.people,
                                      color: Color.fromARGB(255, 102, 100, 100),
                                      size: 30),
                                  Text(
                                    LocaleKeys.Pesient.tr(),
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 44, 38, 38),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    st.patient_count ?? '0',
                                    style: GoogleFonts.pacifico(
                                      textStyle: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 44, 38, 38),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.description,
                                    color: Color.fromARGB(255, 102, 100, 100),
                                    size: 30,
                                  ),
                                  Text(
                                    LocaleKeys.prescriptionOne.tr(),
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 44, 38, 38),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    st.appointment_count ?? '0',
                                    style: GoogleFonts.pacifico(
                                      textStyle: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 44, 38, 38),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Text(''),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 75,
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50)),
          child: Image.asset(
            'images/doctorHealthcare.jpeg',
            width: 500.0,
            height: 250.0,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
            color: Color.fromRGBO(247, 244, 244, 1),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cllList.length,
                    itemBuilder: (context, index) {
                      Call cll = cllList[index];
                      return Card(
                        color: Color.fromARGB(255, 232, 238, 241),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 128, 194, 248),
                            child: Icon(Icons.call, color: Colors.white),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Call ${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cll.namepatient ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cll.servicename ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    cll.nameroom ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Text(cll.namebed ?? ''),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
