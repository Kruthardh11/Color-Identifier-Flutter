import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ColorIdentifier extends StatefulWidget {
  const ColorIdentifier({Key? key}) : super(key: key);

  @override
  _ColorIdentifierState createState() => _ColorIdentifierState();
}

class _ColorIdentifierState extends State<ColorIdentifier> {
  File? _image;
  List? _result;
  bool _hasRunModel = false;

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
          _hasRunModel = false; // Reset the result when a new image is selected
        });
      }
      detectColor(_image!);
    } catch (e) {
      print(e);
      setState(() {});
    }
  }

  void loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  void detectColor(File image) async {
    var result = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 8,
      threshold: 0.1,
      imageMean: 100,
      imageStd: 100,
    );

    setState(() {
      _result = result;
      _hasRunModel = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_hasRunModel)
          Column(
            children: [
              SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Image.file(_image!),
              ),
              Column(
                children: _result!.map((item) {
                  final label = item['label'];
                  final confidence = item['confidence'];

                  return ListTile(
                    title: Text('$label'),
                    subtitle: Text('Confidence: $confidence'),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: () => _getImage(ImageSource.gallery),
                    tooltip: 'Pick Image from Gallery',
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => _getImage(ImageSource.camera),
                    tooltip: 'Capture Image from Camera',
                  ),
                ],
              ),
            ],
          )
        else
          Container(
              child: Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_library),
                        onPressed: () => _getImage(ImageSource.gallery),
                        tooltip: 'Pick Image from Gallery',
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _getImage(ImageSource.camera),
                        tooltip: 'Capture Image from Camera',
                      ),
                    ],
                  ),
                ],
              ),
              const Text('Color Detection'),
            ],
          )),
      ],
    );
  }
}
