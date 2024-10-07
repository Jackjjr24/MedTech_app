import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatWithDoctorPage extends StatefulWidget {
  const ChatWithDoctorPage({super.key});

  @override
  _ChatWithDoctorPageState createState() => _ChatWithDoctorPageState();
}

class _ChatWithDoctorPageState extends State<ChatWithDoctorPage> {
  final List<String> doctors = [
    "Dr. Samantha Patel",
    "Dr. Marcus Nguyen",
    "Dr. Emily Chang",
    "Dr. Javier Rodriguez",
    "Dr. Priya Sharma",
    "Dr. Alexander Mitchell",
    "Dr. Natalie Wilson",
    "Dr. Omar Khan",
    "Dr. Gabriella Russo",
    "Dr. Benjamin Lee",
    "Dr. Sophia Martinez",
    "Dr. Liam O'Connor",
    "Dr. Isabella Flores",
    "Dr. Jacob Thompson",
    "Dr. Maya Gupta"
  ];

  final List<String> specialties = [
    "Dermatology",
    "Cardiology",
    "Emergency Medicine",
    "Family Medicine",
    "Gastroenterology",
    "Hematology",
    "Immunology",
    "Internal Medicine",
    "Nephrology",
    "Neurology",
    "Obstetrics and Gynecology (OB/GYN)",
    "Oncology",
    "Ophthalmology",
    "Orthopedics",
    "Pediatrics"
  ];

  String selectedDoctor = "Dr. Samantha Patel";
  String selectedSpecialty = "Dermatology";
  String chatLog = "";
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Doctor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.teal, // Set the color of the app bar
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // Path to your logo image
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Chat with Doctor",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DropdownButton<String>(
                    value: selectedDoctor,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDoctor = newValue!;
                      });
                    },
                    items: doctors
                        .map<DropdownMenuItem<String>>((String doctor) {
                      return DropdownMenuItem<String>(
                        value: doctor,
                        child: Text(
                          doctor,
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.black.withOpacity(0.8),
                    style: GoogleFonts.poppins(color: Colors.white),
                    isExpanded: true,
                    underline: Container(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DropdownButton<String>(
                    value: selectedSpecialty,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSpecialty = newValue!;
                      });
                    },
                    items: specialties
                        .map<DropdownMenuItem<String>>((String specialty) {
                      return DropdownMenuItem<String>(
                        value: specialty,
                        child: Text(
                          specialty,
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.black.withOpacity(0.8),
                    style: GoogleFonts.poppins(color: Colors.white),
                    isExpanded: true,
                    underline: Container(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: chatLog.split('\n').map((message) {
                        bool isUser = message.startsWith("User:");
                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.blue.withOpacity(0.8)
                                  : Colors.grey.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              message,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.5),
                        hintText: "Type your message...",
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: Text(
                      "Send",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      backgroundColor: Colors.blue.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    setState(() {
      chatLog += "User: ${messageController.text}\n";
      messageController.clear();
      chatLog +=
      "$selectedDoctor: Hi there! How can I assist you today?\n"; // Simulated doctor response
    });
  }
}
