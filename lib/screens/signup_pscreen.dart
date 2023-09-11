import 'dart:convert'; // Import for JSON operations
import 'package:http/http.dart' as http; // Import for HTTP operations
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zera3ati_app/screens/main_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage(
      {Key? key,
      required this.id,
      required this.token,
      required this.assistantId})
      : super(key: key);

  final String id;
  final String token;
  final int assistantId;

  @override
  _SignupPageState createState() => _SignupPageState();
}

// String TokenGetter() {
//   return token.value;
// }

// String IdGetter() {
//   return id.value;
// }

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  String? _password;
  String? _idNumber;
  String? _confirm;

  bool passwordcheck() {
    return _password == _confirm;
  }

  Future<void> _signup() async {
    final url = Uri.parse('http://127.0.0.1:8000/signup/');
    final body = json.encode({
      'id': _idNumber,
      'password': _password,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.to(MainScreen(
        id: widget.id,
        token: widget.token,
        assistantId: widget.assistantId,
      ));
    } else {
      // Handle error based on the status code
      Get.snackbar('Error', 'Signup failed: ${response.body}');
    }
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
                    hintText: "Enter your password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
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
                    hintText: "Enter your password again",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password again';
                    } else if (!passwordcheck()) {
                      return 'Your passwords don\'t match. Please try again.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _confirm = value!;
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save(); // Save the form data
                        _signup(); // Call the signup function
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
