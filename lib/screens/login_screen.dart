import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zera3ati_app/screens/main_screen.dart';
import 'package:zera3ati_app/screens/signup_pscreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _password = 'Haha12345#';
  String _idNumber = '1234567890';

  Future<void> _login() async {
    final url = Uri.parse('http://192.168.1.16:8000/login/');
    final body = json.encode({
      'id': _idNumber,
      'password': _password,
    });
    print('Request body: $body');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.to(const MainScreen());
    } else {
      // handle error based on the status code
      // for example, show a message to the user
      print('Error: ${response.statusCode} - ${response.body}');
    }
  }

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
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ID Number',
                    hintText: "Enter your ID number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _idNumber,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your ID number';
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
                  initialValue: _password,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _login();
                      }
                    },
                    style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 92, 0, 0))),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
