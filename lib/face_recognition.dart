import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  String recognizedName = "Recognized Name";

  final TextEditingController registrationNameController =
      TextEditingController();
  final TextEditingController registrationEmailController =
      TextEditingController();
  final TextEditingController registrationPasswordController =
      TextEditingController();

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  Future<void> registerUser(String name, String email, String password) async {
    final url = Uri.parse('http://172.22.16.214:5000/register');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
      print('Registration successful: ${response.body}');
    } else {
      print('Failed to register: ${response.body}');
    }
  }

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    final url = Uri.parse('http://172.22.16.214:5000/login');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200 && response.body == 'LOGGED IN') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful!')),
      );
      print('Login successful: ${response.body}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed!')),
      );
      print('Login failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Registration Form
                  TextField(
                    controller: registrationNameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: registrationEmailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: registrationPasswordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      registerUser(
                        registrationNameController.text,
                        registrationEmailController.text,
                        registrationPasswordController.text,
                      );
                    },
                    child: Text('Register'),
                  ),
                  SizedBox(height: 30),
                  // Login Form
                  TextField(
                    controller: loginEmailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: loginPasswordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      loginUser(
                        loginEmailController.text,
                        loginPasswordController.text,
                        context,
                      );
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
