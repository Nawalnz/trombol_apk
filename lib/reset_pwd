import 'package:flutter/material.dart';

void main() {
  runApp(const ResetPwdApp());
}

class ResetPwdApp extends StatelessWidget {
  const ResetPwdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const Scaffold(
        body: ResetPassword(),
      ),
    );
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 50),
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView(
          children: [
            // Top-Left Arrow Icon
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  // Handle navigation manually
                  // Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 10),

            // Trombol Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 103,
                  height: 102,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/trombol_logo_dark.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Create New Password',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.17,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Keep your account secure by creating a strong password',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.17,
              ),
            ),

            const SizedBox(height: 30),

            // 🔐 Password Field with Eye Icon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter new password',
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black38,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your password should at least contain an uppercase character',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 40),

            // create new pwd
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
              decoration: BoxDecoration(
                color: const Color(0xD6042B55),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  'Create New Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
