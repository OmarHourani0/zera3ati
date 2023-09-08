import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zera3ati_app/screens/main_screen.dart';
import 'package:zera3ati_app/screens/signup_pscreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // ignore: unused_field
  late final String _password;
  // ignore: unused_field
  late final String _idNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  //'assets/IMG_9186.PNG',
                  'assets/logo3.png',
                  scale: 5,
                ),
                const SizedBox(
                  height: 22,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ID Number',
                    hintText: "Enter your ID number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your ID number';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'ID number should only contain digits (0-9)';
                    } else if (value.length != 10) {
                      return 'ID number must be 10 digits long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _idNumber = value!;
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: "Enter your pasword",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,}$')
                        .hasMatch(value)) {
                      return 'Password must contain at least one capital letter and one number';
                    } else if (value.length < 6) {
                      return 'Password length should be at least 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Get.to(const MainScreen());
                          }
                        },
                        style: const ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 92, 0, 0))),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    //SizedBox(width: 70),
                    // Column(
                    //   children: [
                    //     SizedBox(height: 30),
                    //     TextButton(
                    //       onPressed: () {
                    //         Get.to(SignupPage());
                    //       },
                    //       child: Text(
                    //         'Dont have an account yet?',
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //           decoration: TextDecoration.underline,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        Get.to(SignupPage());
                      },
                      child: Text(
                        'Dont have an account yet?',
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // SingleChildScrollView(
                //   child: Lottie.asset(
                //     'assets/images/test.json',
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
