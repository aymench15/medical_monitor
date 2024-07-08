import 'package:flutter/material.dart';
import 'package:medical_monitor/providers/auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:medical_monitor/core/res/color.dart';
import 'package:medical_monitor/widgets/circle_gradient_icon.dart';
import 'package:medical_monitor/models/appointment.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medical_monitor/lang/local_keys.g.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../widgets/task_group.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final Auth auth = Auth();
  final DateTime now = DateTime.now();
  final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('ar'),
    const Locale('fr'),
  ];
  MaterialColor colorCustom = MaterialColor(0xFF13216E, <int, Color>{
    50: Color(0xFF13216E),
    100: Color(0xFF13216E),
    200: Color(0xFF13216E),
    300: Color(0xFF13216E),
    400: Color(0xFF13216E),
    500: Color(0xFF13216E),
    600: Color(0xFF13216E),
    700: Color(0xFF13216E),
    800: Color(0xFF13216E),
    900: Color(0xFF13216E),
  });
  List<Appointment> appList = [];
  bool isLoading = true;
  int _currentIndex = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    print(now);
    super.initState();
    initializeNotifications();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Appointment Reminder',
      'Your appointment is coming up in 1 hour.',
      platformChannelSpecifics,
      payload: 'appointment_notification',
    );
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  void loadData() {
    String? tokenValue;
    auth.readToken().then((value) {
      setState(() {
        tokenValue = value;
        auth.AppointmentList(tokenValue!).then((appointList) {
          setState(() {
            appList = auth.appointList;
            isLoading = false; // Update loading status after getting the list
            checkAppointments();
          });
        });
      });
    });
  }

  void checkAppointments() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    for (Appointment appointment in appList) {
      if (appointment.status == 'approved') {
        final DateTime appointmentDateTime =
            DateTime.parse(appointment.appointmentDate ?? '');

        if (appointmentDateTime.year == today.year &&
            appointmentDateTime.month == today.month &&
            appointmentDateTime.day == today.day) {
          final Duration timeDifference = appointmentDateTime.difference(now);

          if (timeDifference <= const Duration(hours: 1)) {
            showNotification();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String get_month(int month) {
      if (month == 1) return "Jan";
      if (month == 2) return "Feb";
      if (month == 3) return "Mar";
      if (month == 4) return "Apr";
      if (month == 5) return "Mai";
      if (month == 6) return "Jun";
      if (month == 7) return "Jul";
      if (month == 8) return "Aug";
      if (month == 9) return "Sep";
      if (month == 10) return "Oct";
      if (month == 11) return "Nov";
      return "Dec";
    }

    ;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${now.day < 10 ? '0${now.day}' : now.day}, ${get_month(now.month)} ${now.year}",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: Container(),
        actions: <Widget>[
          PopupMenuButton<String>(
              surfaceTintColor: colorCustom,
              icon: Icon(
                Icons.language,
                size: 30,
                color: colorCustom,
              ),
              onSelected: (String value) {
                print("You selected $value");
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuWidget(
                    height: 40.0,
                    child: Row(
                      children: [
                        TextButton(
                            child: Text(
                              'En',
                              style: TextStyle(color: colorCustom),
                            ),
                            onPressed: () async =>
                                await context.setLocale(supportedLocales[0])),
                        TextButton(
                            child: Text(
                              'Fr',
                              style: TextStyle(color: colorCustom),
                            ),
                            onPressed: () async =>
                                await context.setLocale(supportedLocales[2])),
                        TextButton(
                            child: Text(
                              'Ar',
                              style: TextStyle(color: colorCustom),
                            ),
                            onPressed: () async =>
                                await context.setLocale(supportedLocales[1]))
                      ],
                    ),
                  ),
                ];
              }),
        ],
      ),
      //  AppBar(
      //   title: Text(
      //     "08, Jun 2024",
      //     style: Theme.of(context)
      //         .textTheme
      //         .bodySmall!
      //         .copyWith(fontWeight: FontWeight.bold),
      //   ),
      //   elevation: 0,
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 20),
      //       child: CircleGradientIcon(
      //         onTap: () {
      //         //  Navigator.pushNamed(context, Routes.todaysTask);
      //         },
      //         icon: Icons.settings,
      //         color: colorCustom,
      //         iconSize: 24,
      //         size: 40,
      //       ),
      //     )
      //   ],
      //   leading: Container(),
      //   // leading: Padding(
      //   //   padding: const EdgeInsets.symmetric(horizontal: 10),
      //   //   child: Container(
      //   //     width: 50,
      //   //     height: 50,
      //   //     decoration: const BoxDecoration(
      //   //       color: Colors.white,
      //   //       shape: BoxShape.circle,
      //   //     ),
      //   //     child: InkWell(
      //   //       onTap: () {},
      //   //       customBorder: RoundedRectangleBorder(
      //   //         borderRadius: BorderRadius.circular(100),
      //   //       ),
      //   //       child: const Icon(
      //   //         Icons.menu_rounded,
      //   //       ),
      //   //     ),
      //   //   ),
      //   // ),
      // ),
      extendBody: true,
      body: _buildBody(),
    );
  }

  Stack _buildBody() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              _taskHeader(),
              const SizedBox(
                height: 15,
              ),
              buildGrid(),
              const SizedBox(
                height: 125,
              ),
              _onGoingHeader(),
              // const SizedBox(
              //   height: 10,
              // ),
              // const OnGoingTask(),
              // const SizedBox(
              //   height: 40,
              // ),
            ],
          ),
        ),
        Positioned(
            bottom: 50,
            // left: 100.w / 2 - (70 / 2),
            right: 30,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('Informations');
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: colorCustom,
              tooltip: 'Add info',
              focusNode: FocusNode(debugLabel: 'Add info'),
            )
            // CircleGradientIcon(
            //   color: colorCustom,
            //   onTap: () {},
            //   size: 60,
            //   iconSize: 30,
            //   icon: Icons.add,
            // ),
            )
      ],
    );
  }

  Row _onGoingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.clickhere.tr(),
          style: TextStyle(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        // const Spacer(),
        // InkWell(
        //   onTap: () {},
        //   child: Text(
        //     "See all",
        //     style: TextStyle(
        //       color: AppColors.primaryColor,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // )
      ],
    );
  }

  Row _taskHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SelectableText(
          LocaleKeys.whatyoucando.tr(),
          style: TextStyle(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          toolbarOptions: const ToolbarOptions(
            copy: true,
            selectAll: true,
          ),
        ),
      ],
    );
  }

  StaggeredGrid buildGrid() {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1.3,
            child: InkWell(
              onTap: () => {Navigator.of(context).pushNamed('profile')},
              child: TaskGroupContainer(
                color: Colors.blue,
                icon: Icons.person,
                taskCount: 10,
                taskGroup: LocaleKeys.profile.tr(),
              ),
            )),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: InkWell(
            onTap: () => {Navigator.of(context).pushNamed('showDoctors')},
            child: TaskGroupContainer(
              color: Colors.grey,
              isSmall: true,
              icon: Icons.list,
              taskCount: 5,
              taskGroup: LocaleKeys.ListDoctor.tr(),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: InkWell(
            onTap: () => {Navigator.of(context).pushNamed('prescript')},
            child: TaskGroupContainer(
              color: colorCustom,
              icon: Icons.article,
              taskCount: 2,
              taskGroup: LocaleKeys.prescription.tr(),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: InkWell(
            onTap: () => {Navigator.of(context).pushNamed('MedicalInfo')},
            child: TaskGroupContainer(
              color: Colors.blue,
              isSmall: true,
              icon: Icons.medical_information,
              taskCount: 0,
              taskGroup: LocaleKeys.hospitalRecords.tr(),
            ),
          ),
        ),
      ],
    );
  }
}

class OnGoingTask extends StatelessWidget {
  const OnGoingTask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Startup Website Design with Responsive",
                  style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.timelapse,
                      color: Colors.purple[300],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "10:00 AM - 12:30PM",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "Complete - 80%",
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Icon(
            Icons.rocket_rounded,
            size: 60,
            color: Colors.orange,
          )
        ],
      ),
    );
  }
}

class PopupMenuWidget<T> extends PopupMenuEntry<T> {
  const PopupMenuWidget({required this.height, required this.child}) : super();

  @override
  final Widget child;

  @override
  final double height;

  @override
  bool get enabled => false;

  @override
  _PopupMenuWidgetState createState() => new _PopupMenuWidgetState();

  @override
  bool represents(T? value) {
    // TODO: implement represents
    throw UnimplementedError();
  }
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) => widget.child;
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    final firstControlPoint = Offset(size.width * 0.6, 0);
    final firstEndPoint = Offset(size.width * 0.58, 44);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secControlPoint = Offset(size.width * 0.55, 50);
    final secEndPoint = Offset(size.width * 0.5, 50);
    path.quadraticBezierTo(
      secControlPoint.dx,
      secControlPoint.dy,
      secEndPoint.dx,
      secEndPoint.dy,
    );

//     path.lineTo(size.width * 0.45, 30);

//     final lastControlPoint = Offset(size.width * 0.45, 20);
//     final lastEndPoint = Offset(size.width * 0.2, 30);
//     path.quadraticBezierTo(
//       lastControlPoint.dx,
//       lastControlPoint.dy,
//       lastEndPoint.dx,
//       lastEndPoint.dy,
//     );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
  // Widget build(BuildContext context) {
  //   return 
    
    // WillPopScope(
    //   onWillPop: _onWillPop,
    //   child: Scaffold(
    //     extendBodyBehindAppBar: true,
    //     drawer: Drawer(
    //       child: Consumer<Auth>(
    //         builder: (context, auth, child) {
    //           if (auth.authenticated) {
    //             return ListView(
    //               padding: EdgeInsets.zero,
    //               children: [
    //                 UserAccountsDrawerHeader(
    //                   decoration: const BoxDecoration(
    //                     gradient: LinearGradient(
    //                       begin: Alignment.bottomRight,
    //                       end: Alignment.topRight,
    //                       colors: [
    //                         Color.fromARGB(255, 126, 160, 177),
    //                         Color.fromARGB(255, 5, 20, 188)
    //                       ],
    //                     ),
    //                   ),
    //                   accountName: Text(
    //                    (auth.user?.name == "0")? "Patient" 
    //                      : 'Doctor',
    //                     style: GoogleFonts.audiowide(
    //                       textStyle: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 12,
    //                         fontWeight: FontWeight.bold,
    //                         letterSpacing: 1.2,
    //                       ),
    //                     ),
    //                   ),
    //                   accountEmail: Text(
    //                     auth.user?.email ?? '',
    //                     style: GoogleFonts.audiowide(
    //                       textStyle: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 12,
    //                         fontWeight: FontWeight.bold,
    //                         letterSpacing: 1.2,
    //                       ),
    //                     ),
    //                   ),
    //                   currentAccountPicture: CircleAvatar(
    //                     backgroundImage: AssetImage(
    //                         'images/patient.png'), // Replace with your image path
    //                   ),
    //                 ),
    //                 ListTile(
    //                   leading: const Icon(Icons.info),
    //                   title: Text(
    //                     LocaleKeys.profile.tr(),
    //                     style: GoogleFonts.acme(
    //                       textStyle: TextStyle(
    //                         color: Color.fromARGB(255, 77, 70, 70),
    //                         fontSize: 13,
    //                         fontWeight: FontWeight.bold,
    //                         letterSpacing: 1.2,
    //                       ),
    //                     ),
    //                   ),
    //                   onTap: () {
    //                     Navigator.of(context).pushNamed('profile');
    //                   },
    //                 ),
    //                 ListTile(
    //                   leading: const Icon(Icons.medical_information),
    //                   title: Text(
    //                     LocaleKeys.hospitalRecords.tr(),
    //                     style: GoogleFonts.acme(
    //                       textStyle: TextStyle(
    //                         color: Color.fromARGB(255, 77, 70, 70),
    //                         fontSize: 13,
    //                         fontWeight: FontWeight.bold,
    //                         letterSpacing: 1.2,
    //                       ),
    //                     ),
    //                   ),
    //                   onTap: () {
    //                     Navigator.of(context).pushNamed('MedicalInfo');
    
    //                   },
    //                 ),
    //                 ListTile(
    //                   leading: const Icon(Icons.description),
    //                   title: Text(
    //                     LocaleKeys.prescription.tr(),
    //                     style: GoogleFonts.acme(
    //                       textStyle: TextStyle(
    //                         color: Color.fromARGB(255, 77, 70, 70),
    //                         fontSize: 13,
    //                         fontWeight: FontWeight.bold,
    //                         letterSpacing: 1.2,
    //                       ),
    //                     ),
    //                   ),
    //                   onTap: () {
    //                     Navigator.of(context).pushNamed('prescript');
    
    //                   },
    //                 ),
    //                 ListTile(
    //                   leading: const Icon(Icons.call),
    //                   title: Text(
    //                     LocaleKeys.Appointments.tr(),
    //                     style: GoogleFonts.acme(
    //                       textStyle: TextStyle(
    //                         color: Color.fromARGB(255, 77, 70, 70),
    //                         fontSize: 13,
    //                         fontWeight: FontWeight.bold,
    //                         letterSpacing: 1.2,
    //                       ),
    //                     ),
    //                   ),
    //                   onTap: () {
    //                     Navigator.of(context).pushNamed('showDoctors');
    //                   },
    //                 ),
    //                 ListTile(
    //                   leading: const Icon(Icons.language),
    //                   title: Text(
    //                     LocaleKeys.language.tr(),
    //                     style: GoogleFonts.acme(
    //                       textStyle: TextStyle(
    //                         color: Color.fromARGB(255, 77, 70, 70),
    //                         fontSize: 13,
    //                         fontWeight: FontWeight.bold,
    //                         letterSpacing: 1.2,
    //                       ),
    //                     ),
    //                   ),
    //                   onTap: () {
    //                     Navigator.of(context).pushNamed('Setting');
    //                   },
    //                 ),
    //                 ListTile(
    //                   leading: const Icon(Icons.logout),
    //                   title: Text(
    //                     LocaleKeys.logout.tr(),
    //                     style: GoogleFonts.acme(
    //                       textStyle: TextStyle(
    //                         color: Color.fromARGB(255, 77, 70, 70),
    //                         fontSize: 13,
    //                         fontWeight: FontWeight.bold,
    //                         letterSpacing: 1.2,
    //                       ),
    //                     ),
    //                   ),
    //                   onTap: () {
    //                     showDialog(
    //                       context: context,
    //                       builder: (context) => AlertDialog(
    //                         title: Text(LocaleKeys.logout.tr()),
    //                         content: Text(LocaleKeys.logou.tr()),
    //                         actions: [
    //                           TextButton(
    //                             onPressed: () {
    //                               Provider.of<Auth>(context, listen: false)
    //                                   .logout();
    //                               Navigator.of(context).pushNamed('login');
    //                             },
    //                             child: Text(LocaleKeys.logout.tr()),
    //                           ),
    //                           TextButton(
    //                             onPressed: () {
    //                               // User clicked on "Cancel"
    //                               Navigator.of(context)
    //                                   .pop(); // Close the dialog
    //                             },
    //                             child: Text(LocaleKeys.cancel.tr()),
    //                           ),
    //                         ],
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ],
    //             );
    //           } else {
    //             return Container();
    //           }
    //         },
    //       ),
    //     ),
    //     appBar: AppBar(
    //       backgroundColor:Color.fromRGBO(19, 33, 110, 1),
    //       shadowColor: Color.fromARGB(19, 33, 110, 1),
    //       actions: [],
    //     ),
    //     body: Container(),
    //     // _buildCallPage() ,
    //     //  _buildAppointmentsPage(),
    //     bottomNavigationBar: CurvedNavigationBar(
    //       color: Color.fromRGBO(19, 33, 110, 1),
    //       backgroundColor: Colors.white,
    //       height: 50,
    //       animationDuration: Duration(milliseconds: 200),
    //       items: [
    //         Icon(
    //           Icons.call,
    //           size: 25,
    //           color: Colors.white,
    //         ),
    //         Icon(
    //           Icons.date_range,
    //           size: 25,
    //           color: Colors.white,
    //         ),
    //       ],
    //       onTap: (index) {
    //         if (index == 0) {
    //           setState(() {
    //             _currentIndex = index;
    //           });
    //         } else {
    //           setState(() {
    //             _currentIndex = index;
    //             if (_currentIndex == 1) {
    //               loadData(); // Call loadData() when appointment index is selected
    //             }
    //           });
    //         }
    //       },
    //     ),
    //   ),
    // );
  //}

  // Widget _buildCallPage() {
  //   return Container(
  //     decoration: BoxDecoration(),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
  //       color: Color.fromRGBO(
  //           247, 244, 244, 1), // Adjust the opacity and color as needed
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             SizedBox(height: 75),
  //             ClipRRect(
  //               borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(50),
  //                   bottomRight: Radius.circular(50)),
  //               child: Image.asset(
  //                 'images/healthcare.PNG',
  //                 width: 500.0,
  //                 height: 250.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               LocaleKeys.welcome.tr(),
  //               style: GoogleFonts.pacifico(
  //                 textStyle: TextStyle(
  //                   color: Color.fromARGB(19, 33, 110, 1),
  //                   fontSize: 19,
  //                   fontWeight: FontWeight.w600,
  //                   letterSpacing: 1.2,
  //                 ),
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               LocaleKeys.callsent.tr(),
  //               style: GoogleFonts.acme(
  //                 textStyle: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w600,
  //                   letterSpacing: 1.2,
  //                 ),
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //             SizedBox(height: 40),
  //             ElevatedButton(
  //               onPressed: () {
  //                 int call = 1;
  //                 Provider.of<Auth>(context, listen: false).calling(
  //                   credentials: {
  //                     'Calling': call,
  //                   },
  //                 );
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text(LocaleKeys.callsent.tr())),
  //                 );
  //               },
  //               // style: ElevatedButton.styleFrom(
  //               //   primary: Color.fromARGB(
  //               //       255, 101, 180, 245), // Adjust the button color as needed
  //               //   onPrimary:
  //               //       Colors.white, // Adjust the button text color as needed
  //               //   padding: EdgeInsets.symmetric(horizontal: 60, vertical: 25),
  //               //   textStyle: TextStyle(fontSize: 20),
  //               //   shape: RoundedRectangleBorder(
  //               //     borderRadius: BorderRadius.circular(
  //               //         30), // Adjust the button shape as needed
  //               //   ),
  //               // ),
  //               child: Text(
  //                 LocaleKeys.call.tr(),
  //                 style: GoogleFonts.acme(
  //                   textStyle: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w600,
  //                     letterSpacing: 1.2,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildAppointmentsPage() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         height: 85,
  //       ),
  //       ClipRRect(
  //         borderRadius: BorderRadius.only(
  //             bottomLeft: Radius.circular(50),
  //             bottomRight: Radius.circular(50)),
  //         child: Image.asset(
  //           'images/healthcare.PNG',
  //           width: 500.0,
  //           height: 250.0,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       Expanded(
  //         child: Container(
  //           color: Color.fromRGBO(247, 244, 244, 1),
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: appList.length,
  //                   itemBuilder: (context, index) {
  //                     Appointment appoint = appList[index];
  //                     IconData? statusIcon;
  //                     Color? statusColor;

  //                     if (appoint.status == 'approved') {
  //                       statusIcon = Icons.check;
  //                       statusColor = Colors.green;
  //                     } else if (appoint.status == 'pending') {
  //                       statusIcon = Icons.hourglass_empty;
  //                       statusColor = Colors.orange;
  //                     } else if (appoint.status == 'canceled') {
  //                       statusIcon = Icons.cancel;
  //                       statusColor = Color.fromARGB(255, 202, 37, 37);
  //                     }

  //                     return Card(
  //                       color: Color.fromARGB(255, 232, 238, 241),
  //                       child: ListTile(
  //                         leading: CircleAvatar(
  //                           backgroundColor: Color.fromARGB(19, 33, 110, 1),
  //                           child:
  //                               Icon(Icons.calendar_today, color: Colors.white),
  //                         ),
  //                         title: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               '${LocaleKeys.Appointment.tr()} ${index + 1}',
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 16,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 4),
  //                             Text(
  //                               appoint.doctor ?? '',
  //                               style: TextStyle(
  //                                 fontSize: 14,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 4),
  //                             Text(
  //                               appoint.client ?? '',
  //                               style: TextStyle(
  //                                 fontSize: 14,
  //                                 color: Colors.black,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 4),
  //                             Row(
  //                               children: [
  //                                 Icon(statusIcon, color: statusColor),
  //                                 const SizedBox(width: 4),
  //                                 Text(
  //                                   appoint.status ?? '',
  //                                   style: TextStyle(
  //                                     fontSize: 14,
  //                                     color: Colors.black,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                         subtitle: Text(appoint.appointmentDate ?? ''),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
 // }

