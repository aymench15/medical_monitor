import 'package:medical_monitor/widgets/original_button.dart';
import 'package:flutter/material.dart';
import 'package:medical_monitor/providers/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _formkeyP = GlobalKey<FormState>();
  bool showpassword = true;
  bool showOpassword = true;
  bool showCpassword = true;

  TextEditingController c_passwordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _OpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 101, 180, 245),
        shadowColor: Color.fromARGB(255, 101, 180, 245),
        title: Text(
          'Profile',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Image.asset(
                'images/password_logo.png',
                width: 150,
                height: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Password",
                style: GoogleFonts.acme(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            Consumer<Auth>(
              builder: (context, auth, child) {
                if (auth.authenticated) {
                  return Column(
                    children: <Widget>[
                      Form(
                        key: _formkeyP,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 16),
                              TextFormField(
                                obscureText: showOpassword,
                                controller: _OpasswordController,
                                validator: (value) => value!.isEmpty
                                    ? 'Old Password is required '
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'Old Password',
                                  prefixIcon: Icon(Icons.lock_outlined),
                                  suffixIcon: toggleOPassword(),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                obscureText: showpassword,
                                controller: _passwordController,
                                validator: (value) => value!.isEmpty
                                    ? 'New Password is required'
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  prefixIcon: Icon(Icons.lock_outlined),
                                  suffixIcon: togglePassword(),
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
                                text: 'Change',
                                onPressed: () async {
                                  if (_formkeyP.currentState!.validate()) {
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .update(
                                      credentials: {
                                        'name': auth.user!.name,
                                        'email': auth.user!.email,
                                        'phone_number': auth.user!.phone_number,
                                        'nss': auth.user!.nss,
                                        'birthday': auth.user!.birthday,
                                        'O_password': _OpasswordController.text,
                                        'password': _passwordController.text,
                                        'c_password': c_passwordController.text,
                                      },
                                    );
                                    setState(() {
                                      if (auth.errPassword == false) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Successfully changed'),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Invalid Old Password'),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                                textColor: Colors.white,
                                bgColor:
                                    const Color.fromARGB(255, 97, 169, 202),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Handle case when not authenticated
                  return Container();
                }
              },
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

  Widget toggleOPassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            showOpassword = !showOpassword;
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
