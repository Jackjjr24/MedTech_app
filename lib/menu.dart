import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_auth_try7/skin.dart';
import 'package:user_auth_try7/prescription.dart';
import 'package:user_auth_try7/home_page.dart';
import 'package:user_auth_try7/chat.dart';
import 'package:user_auth_try7/req.dart';
import 'package:user_auth_try7/blood.dart';
import 'package:user_auth_try7/xray.dart';
import 'package:user_auth_try7/my_prescription.dart';
import 'package:user_auth_try7/login.dart';  // Import the login page
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
        backgroundColor: Color(0xFF2B9873),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF2B9873),
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              title: Text('Request Blood', style: GoogleFonts.poppins(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestBloodPage()),
                );
              },
            ),
            ListTile(
              title: Text('Blood Donation', style: GoogleFonts.poppins(fontSize: 18)),
              onTap: () {
                // Navigate to the Blood Donation page where blood details will be fetched from Firebase
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BloodDonationPage()),  // No default data passed
                );
              },
            ),
            ListTile(
              title: Text('My Prescription', style: GoogleFonts.poppins(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrescriptionManagementPage()),
                );
              },
            ),
            // Logout button
            ListTile(
              title: Text('Logout', style: GoogleFonts.poppins(fontSize: 18, color: Colors.red)),
              onTap: () {
                // Navigate to the login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1_optimized.png'), // Path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: mediaHeight * 0.05),
              Image.asset(
                'assets/images/page-removebg-preview.png', // Path to your image
                height: mediaHeight * 0.2,  // Adjust the height as needed to minimize size
                fit: BoxFit.contain,
              ),
              SizedBox(height: mediaHeight * 0.05), // Add some space between the image and the options
              _buildOption(
                context,
                title: "Symptoms",
                page: const SymptomsPage(),
              ),
              _buildOption(
                context,
                title: "Prescription Analyzer",
                page: const PrescriptionAnalyzerPage(),
              ),
              _buildOption(
                context,
                title: "Skin Disease Detection",
                page: const HomePage(),
              ),
              _buildOption(
                context,
                title: "X-ray Analysis",
                page: const XrayAnalyzerPage(),
              ),
              _buildOption(
                context,
                title: "Chat with Doctor",
                page: const ChatWithDoctorPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, {required String title, required Widget page}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.8),  // Slightly transparent background
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
