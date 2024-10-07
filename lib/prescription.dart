import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PrescriptionAnalyzerPage extends StatefulWidget {
  const PrescriptionAnalyzerPage({super.key});

  @override
  _PrescriptionAnalyzerPageState createState() =>
      _PrescriptionAnalyzerPageState();
}

class _PrescriptionAnalyzerPageState extends State<PrescriptionAnalyzerPage> {
  File? _image;
  final picker = ImagePicker();
  List<Map<String, dynamic>> messages = [];
  bool _isLoading = false;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        messages.add({
          'type': 'userImage',
          'content': _image,
        });
        _isLoading = true; // Show loading indicator
      });
      _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "https://detect.roboflow.com/doctor-prescription-ion3u/2?api_key=S5ML7UF6I5p9JHqQkppq"),
    );

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = json.decode(responseBody);
      final predictions = decodedResponse['predictions'] as List<dynamic>;

      if (predictions.isNotEmpty) {
        String highestConfidenceClass = '';

        predictions.forEach((prediction) {
          if (prediction['confidence'] > 0.5) {
            // Confidence threshold
            highestConfidenceClass = prediction['class'] as String;
          }
        });

        if (highestConfidenceClass.isNotEmpty) {
          setState(() {
            messages.add({
              'type': 'aiText',
              'content': highestConfidenceClass,
            });

            if (highestConfidenceClass == 'Paracetamol, 3.5ml') {
              messages.add({
                'type': 'aiText',
                'content': '''
MedTech Information:
[Medicine names]: Paracetamol (3.5ml)

[Medicines used for]:
- Fever (including fevers caused by colds and flu)
- Pain relief, including headaches, migraines, toothache, sore throats, period pain, back pain, and arthritis

[Dosage level]:
- Dosage will depend on the individual's age and the reason for taking Paracetamol.
- Always follow the directions on the medicine label or as advised by your doctor or pharmacist.

[Possible Side Effects of Prescribed Medicines if any]:
- Paracetamol is generally safe for most people when taken as directed.
- Possible side effects include nausea, vomiting, and allergic reactions.
- If you experience any unusual or severe side effects, stop taking the medication and consult a doctor immediately.

[Alternative home remedies if any]:
- Rest: Allowing your body to rest can help reduce fever and pain.
- Fluids: Drinking plenty of fluids helps keep you hydrated and can help flush out the system.
- Applying a cool compress to the forehead can help reduce fever.

Important note: This information is for general knowledge only. Always consult a doctor or pharmacist for specific medical advice.
                '''
              });
            }
          });
        } else {
          setState(() {
            messages.add({
              'type': 'aiText',
              'content': 'No class detected',
            });
          });
        }
      } else {
        setState(() {
          messages.add({
            'type': 'aiText',
            'content': 'No predictions found',
          });
        });
      }
    } else {
      setState(() {
        messages.add({
          'type': 'aiText',
          'content': 'Failed to upload image',
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Analyzer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.teal, // Set the color of the app bar
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home.png'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered text
          Center(
            child: Text(
              "Upload your prescription image",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8),
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    if (message['type'] == 'userImage') {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Image.file(
                                message['content'],
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/logo.png', // Path to your logo image
                              height: 40, // Adjust size as needed
                              width: 40, // Adjust size as needed
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100]?.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  message['content'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _getImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.photo_library),
                      SizedBox(width: 5),
                      Text('Choose from Gallery'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
