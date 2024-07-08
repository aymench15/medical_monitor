import 'package:medical_monitor/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_monitor/widgets/original_button.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formkey = GlobalKey<FormState>();
  bool showpassword = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //_emailController.dispose();
    //_passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 240, 248, 1),
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
                          Color.fromARGB(255, 46, 99, 204),
                          Color.fromARGB(255, 2, 10, 84),
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
                        'Login',
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
            SizedBox(height: 60),
            Column(
              children: <Widget>[
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Consumer<Auth>(builder: (context, auth, child) {
                      return Column(
                        children: <Widget>[
                          SizedBox(height: 16),
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 5, 20, 188),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            obscureText: showpassword,
                            controller: _passwordController,
                            validator: (value) =>
                                value!.isEmpty ? 'Password is required' : null,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outlined),
                              suffixIcon: togglePassord(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 5, 20, 188),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          SizedBox(height: 18),
                          OriginalButton(
                            text: 'Login',
                            onPressed: () async {
                              Navigator.of(context).pushNamed('menu');
                              if (_formkey.currentState!.validate()) {
                                await Provider.of<Auth>(context, listen: false)
                                    .login(
                                  credentials: {
                                    'email': _emailController.text,
                                    'password': _passwordController.text,
                                  },
                                );
                                if (Provider.of<Auth>(context, listen: false)
                                    .error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Invalid email or password')),
                                  );
                                } else {
                                  await Future.delayed(Duration.zero);
                                  if (auth.role == true) {
                                    Navigator.of(context).pushNamed('menu');
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed('menudoctor');
                                  }
                                }
                              }
                            },
                            textColor: Colors.white,
                            bgColor: Color.fromRGBO(19, 33, 110, 1),
                          ),
                          SizedBox(height: 5),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('register'),
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.acme(
                                textStyle: TextStyle(
                                  color: Color.fromARGB(255, 134, 132, 132),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget togglePassord() {
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
}
