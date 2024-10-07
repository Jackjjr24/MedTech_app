import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_auth_try7/login.dart';
import 'package:user_auth_try7/menu.dart'; // Import MenuPage

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/intro.png"),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: mediaHeight * 0.1,
              ),
              Image.asset(
                'assets/images/tony.png',
                height: 230,
              ),
              SizedBox(
                height: mediaHeight * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Instant\nMedical Assistant\nand Analysis',
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'with',
                      style: GoogleFonts.poppins(
                        fontSize: 43,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'MedTech',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        color: const Color.fromARGB(255, 0, 200, 157),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 27),
                child: Text(
                  'MedTech - AN AI CONSULTANT\n FOR YOUR NEEDS',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: mediaHeight * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    // Check if user is logged in
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // User is logged in, navigate to OptionsPage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OptionsPage(),
                        ),
                      );
                    } else {
                      // User is not logged in, navigate to LoginPage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Text(
                      "Get Started",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mediaHeight * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
