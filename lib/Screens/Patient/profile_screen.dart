import 'package:medical_monitor/widgets/original_button.dart';
import 'package:flutter/material.dart';
import 'package:medical_monitor/providers/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formkeyRe = GlobalKey<FormState>();
  bool showpassword = true;
  bool showCpassword = true;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nssController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(19, 33, 110, 1),
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
        // Wrap the Column with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'images/profile.png',
                width: 200,
                height: 150,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "My Profile",
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
                  _nameController.text = auth.user?.name ?? '';
                  _emailController.text = auth.user?.email ?? '';
                  _phoneController.text = auth.user?.phone_number ?? '';
                  _nssController.text = auth.user?.nss ?? '';
                  _birthdayController.text = auth.user!.birthday ?? '';

                  return Column(
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
                              TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Email is required ';
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
                                controller: _birthdayController,
                                decoration: InputDecoration(
                                  labelText: 'Birthday',
                                  prefixIcon: Icon(Icons.date_range),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  labelText: 'Phone',
                                  prefixIcon: Icon(Icons.phone),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _nssController,
                                decoration: InputDecoration(
                                  labelText: 'NSS',
                                  prefixIcon: Icon(Icons.numbers),
                                ),
                              ),
                              SizedBox(height: 18),
                              OriginalButton(
                                  text: 'Update',
                                  onPressed: () {
                                    if (_formkeyRe.currentState!.validate()) {
                                      Provider.of<Auth>(context, listen: false)
                                          .update(
                                        credentials: {
                                          'name': _nameController.text,
                                          'email': _emailController.text,
                                          'phone_number': _phoneController.text,
                                          'nss': _nssController.text,
                                        },
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Send Success')),
                                      );
                                    }
                                  },
                                  textColor: Colors.white,
                                  bgColor: Color.fromRGBO(19, 33, 110, 1)),
                              SizedBox(height: 20),
                              TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed('password'),
                                  child: Text(
                                    'Change your password !',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 18),
                                  )),
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
