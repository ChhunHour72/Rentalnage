import 'package:flutter/material.dart';
import 'main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/welcome_image.png', height: 350),
              const SizedBox(height: 30),
              const Text(
                "Rentalnage the 2nd Best",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),
              Text(
                "This productive tool is designed to help you better manage your monthly rent payment",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              const SizedBox(height: 40),
              FractionallySizedBox(
                widthFactor: 0.65,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Let's Start",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
