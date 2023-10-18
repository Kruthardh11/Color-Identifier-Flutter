import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  String recognizedName = "Recognized Name";

  Future<void> _recognizeFace() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    var request =
        http.MultipartRequest('POST', Uri.parse('YOUR_FLASK_API_URL'));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseJson = json.decode(await response.stream.bytesToString());
      setState(() {
        recognizedName = responseJson['name'];
      });
    } else {
      print("Failed to recognize face. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            recognizedName != "Recognized Name"
                ? Text("Recognized Name: $recognizedName")
                : Container(),
            ElevatedButton(
              onPressed: _recognizeFace,
              child: Text('Capture and Recognize Face'),
            ),
          ],
        ),
      ),
    );
  }
}
