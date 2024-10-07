import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class XrayAnalyzerPage extends StatefulWidget {
  const XrayAnalyzerPage({super.key});

  @override
  State<XrayAnalyzerPage> createState() => _XrayAnalyzerPageState();
}

class _XrayAnalyzerPageState extends State<XrayAnalyzerPage> {
  final Gemini gemini = Gemini.instance;
  String response = ''; // To store the whole response

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "X-ray Analyzer",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/home.png'),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    response,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendMediaMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: GoogleFonts.poppins(fontSize: 18),
                  ),
                  child: const Text("Upload X-ray Image"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      // Send image with Gemini
      _sendToGemini(file: File(file.path));
    }
  }

  void _sendToGemini({File? file}) {
    List<Uint8List>? image;
    if (file != null) {
      image = [file.readAsBytesSync()];
    }

    gemini.streamGenerateContent(
      '''
      Image Description: 

      [A brief, general description of the X-ray image, focusing on visible features and structures.]

      Surgery Needed?:

      [surgery needed or not .]
      ''',
      images: image,
    ).listen((event) {
      final responsePart = event.content?.parts?.fold(
          "", (previous, current) => "$previous ${current.text}") ?? "";

      setState(() {
        response += responsePart; // Append the new part to the existing response
      });
    });
  }
}
