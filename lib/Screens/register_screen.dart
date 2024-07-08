// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:medical_monitor/widgets/original_button.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:medical_monitor/providers/auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showpassword = true;
  bool showCpassword = true;
  final _formkeyRe = GlobalKey<FormState>();
  int? role;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController c_passwordController = TextEditingController();

  bool _isStrongPassword(String value) {
    return value.contains(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)'));
  }

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: DarwinInitializationSettings());

    flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBanner: true,
            presentList: true,
            presentBadge: true,
            presentSound: true));
    await flutterLocalNotificationsPlugin!.show(
      0,
      'Hello',
      'This is a test notification',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topRight,
                        colors: [
                          Colors.white,
                          Colors.blueGrey,
                          Color.fromRGBO(19, 33, 110, 1),
                        ]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 80),
                      Text(
                        'Register',
                        style: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Image.asset('images/home_logo.png',
                          height: 300, width: 300),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Form(
                  key: _formkeyRe,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          validator: (value) =>
                              value!.isEmpty ? 'Name is required ' : null,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Radio(
                              activeColor: Color.fromARGB(255, 156, 205, 245),
                              value: 5,
                              groupValue: role,
                              onChanged: (value) {
                                setState(() {
                                  role = value;
                                });
                              },
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Patient'),
                            SizedBox(
                              width: 80.0,
                            ),
                            Radio(
                              activeColor: Color.fromARGB(255, 156, 205, 245),
                              value: 4,
                              groupValue: role,
                              onChanged: (value) {
                                setState(() {
                                  role = value;
                                });
                              },
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Doctor'),
                          ],
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            }
                            final emailRegex = RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Invalid email format';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          obscureText: showpassword,
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            } else if (!_isStrongPassword(value) &&
                                value.length < 8) {
                              return 'Password must be strong:\n'
                                  'must be at least 8 characters long\n'
                                  '- At least one lowercase letter\n'
                                  '- At least one uppercase letter\n'
                                  '- At least one digit';
                            }
                            return null; // Return null when the password is correct
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outlined),
                            suffixIcon: togglePassword(),
                            errorStyle: TextStyle(
                                color: Colors
                                    .red), // Set the style for error messages
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          obscureText: showCpassword,
                          controller: c_passwordController,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Confirm Password is required ';
                            if (value != _passwordController.text)
                              return 'Password Not Match';
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Confirm your password',
                            prefixIcon: Icon(Icons.lock_outlined),
                            suffixIcon: toggleConfirmPassword(),
                          ),
                        ),
                        SizedBox(height: 18),
                        OriginalButton(
                          text: 'Register',
                          onPressed: () {
                            _showNotification();
                            // _formkeyRe.currentState?.save();
                            // if (_formkeyRe.currentState!.validate()) {
                            //   if (role == 5) {
                            //     Provider.of<Auth>(context, listen: false)
                            //         .storePatient(
                            //       credentials: {
                            //         'name': _nameController.text,
                            //         'role': role,
                            //         'email': _emailController.text,
                            //         'password': _passwordController.text,
                            //         'c_password': c_passwordController.text,
                            //       },
                            //     );
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //           content: Text('Create Successfully')),
                            //     );
                            //   }
                            //   if (role == 4) {
                            //     Provider.of<Auth>(context, listen: false)
                            //         .storeDoctor(
                            //       credentials: {
                            //         'name': _nameController.text,
                            //         'role': role,
                            //         'email': _emailController.text,
                            //         'password': _passwordController.text,
                            //         'c_password': c_passwordController.text,
                            //       },
                            //     );
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //           content: Text('Create Successfully')),
                            //     );
                            //   }
                            //   if (role == null) {
                            //     // No role selected, show an error message
                            //     showDialog(
                            //       context: context,
                            //       builder: (context) => AlertDialog(
                            //         title: Text('Validation Error'),
                            //         content: Text('Please select a role.'),
                            //         actions: [
                            //           TextButton(
                            //             onPressed: () {
                            //               Navigator.of(context).pop();
                            //             },
                            //             child: Text('OK'),
                            //           ),
                            //         ],
                            //       ),
                            //     );
                            //   }
                            // }
                          },
                          textColor: Colors.white,
                          bgColor: const Color.fromRGBO(19, 33, 110, 1),
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('login'),
                          child: Text(
                            'Already have an account!',
                            style: GoogleFonts.acme(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 134, 132, 132),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            showpassword = !showpassword;
          });
        },
        icon:
            showpassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        color: Colors.grey);
  }

  Widget toggleConfirmPassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            showCpassword = !showCpassword;
          });
        },
        icon:
            showCpassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        color: Colors.grey);
  }
}
