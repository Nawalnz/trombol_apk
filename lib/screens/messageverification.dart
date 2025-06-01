import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/onboarding/onboarding1.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Verification(),
  ));
}

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        colors: [
          Color(0xFF085374),
          Color(0x7500659C),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
       child: SafeArea(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
          children: [

          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFD5ECFF),
                      BlendMode.srcATop,
                   ),
               child: Image.asset(
                'assets/images/Logo.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
           ),

        const SizedBox(height: 32),
          const Text(
             'Message Sent!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 14),
          const Text(
              'Thank you for reaching out to us.\nWe have received your message and will get back to you shortly.',
              style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
   ),
 ),

        SizedBox(
            width: double.infinity,
            height: 57,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home, color: Colors.black),
                label: const Text(
                  'Back to Home',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                   MaterialPageRoute(builder: (context) => const Onboarding1()),
                      (route) => false,
                    );
                  },
                ),
              ),

            const SizedBox(height: 24), // Optional spacing from the bottom
            ],
          ),
        ),
      ),
    )
   );
  }
}
