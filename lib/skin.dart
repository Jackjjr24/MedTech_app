import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({super.key});

  @override
  State<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  // Gemini chat instance
  final Gemini gemini = Gemini.instance;

  // Message list to store data of messages
  List<Map<String, dynamic>> messages = [];

  // User information
  final String currentUserId = "0";
  final String geminiUserId = "1";

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
          "Symptoms",
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
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        // Centered text when the messages list is empty
        if (messages.isEmpty)
          Center(
            child: Text(
              "Type your symptoms here...",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),

        // Chat UI
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUserMessage = message['userId'] == currentUserId;

                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (isUserMessage)
                        // User avatar or icon on the right
                          Container(
                            margin: const EdgeInsets.only(left: 170),
                            child: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                          ),
                        if (!isUserMessage)
                        // Bot avatar or icon on the left
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUserMessage ? Colors.blueGrey : Colors.teal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message['text'] != null)
                                  Text(
                                    message['text'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                if (message['media'] != null)
                                  Image.file(
                                    File(message['media']),
                                    height: 100,
                                    width: 100,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (isUserMessage)
                        // Ensure the user avatar is after the message
                          const SizedBox(width: 10),
                        if (!isUserMessage)
                        // Ensure the bot avatar is before the message
                          const SizedBox(width: 10),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _sendMediaMessage,
                    icon: const Icon(Icons.attach_file, color: Colors.white),
                  ),
                  Expanded(
                    child: TextField(
                      onSubmitted: _handleSendMessage,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Ask a question",
                        hintStyle: const TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle send button press
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleSendMessage(String text) {
    final chatMessage = {
      'userId': currentUserId,
      'text': text,
      'createdAt': DateTime.now(),
    };

    setState(() {
      messages.insert(0, chatMessage);
    });

    _sendToGemini(text);
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      // Prompt user for input when sending an image
      String? userInput = await _askForInput();

      final chatMessage = {
        'userId': currentUserId,
        'text': userInput ?? "",
        'media': file.path,
        'createdAt': DateTime.now(),
      };

      setState(() {
        messages.insert(0, chatMessage);
      });

      // Send image with Gemini
      _sendToGemini(userInput ?? "", file: File(file.path));
    }
  }

  void _sendToGemini(String text, {File? file}) {
    List<Uint8List>? image;
    if (file != null) {
      image = [file.readAsBytesSync()];
    }

    gemini.streamGenerateContent(
      text,
      images: image,
    ).listen((event) {
      final response = event.content?.parts?.fold(
          "", (previous, current) => "$previous ${current.text}") ??
          "";

      final responseMessage = {
        'userId': geminiUserId,
        'text': response,
        'createdAt': DateTime.now(),
      };

      setState(() {
        messages.insert(0, responseMessage);
      });
    });
  }

  Future<String?> _askForInput() async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          backgroundColor: const Color.fromARGB(231, 0, 94, 60),
          title: Text(
            'Send a message with the image',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          content: TextField(
            cursorColor: Colors.white,
            controller: controller,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(59, 255, 255, 255),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                borderSide: BorderSide.none,
              ),
              hintText: "Ask about Image",
              hintStyle: TextStyle(
                color: Color.fromARGB(145, 255, 255, 255),
              ),
            ),
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(
                'Send',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
