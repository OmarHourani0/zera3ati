import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zera3ati_app/screens/main_screen.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  String? _password;
  String? _idNumber;
  String? _confirm;

  bool passwordcheck() {
    setState(() {
      if (_password == _confirm || (_password!.length != _confirm!.length)) {
        const SnackBar(
          content: Center(
            child: Text(
              "You passwords dont match, please try again.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      }
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                // const SizedBox(
                //   height: 16,
                // ),
                Image.asset(
                  'assets/logo3.png',
                  scale: 5,
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  'Your path to smart agriculture start here...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30,
                  ),
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
                SizedBox(height: 24),
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
                SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                    hintText: "Enter your pasword again",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password again';
                    } else if (passwordcheck() == true) {
                      return 'Your passwords dont match. Please try again nigga';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _confirm = value!;
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.to(const MainScreen());
                      }
                    },
                    style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 92, 0, 0))),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
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
