import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:user_auth_try7/auth_gate.dart'; // Import AuthGate

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>  AuthGate(), // Navigate to AuthGate
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg1_optimized.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'JR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/tony1.png',
              width: 250,
            ),
          ),
          Positioned(
            bottom: 170,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _animation,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CinzelDecorative',
                    ),
                  ),
                  Text(
                    'TECH',
                    style: TextStyle(
                      color: Color(0xFF2B9873),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CinzelDecorative',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
