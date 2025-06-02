import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// screens
import 'package:trombol_apk/screens/homepage/explore.dart';
import 'package:trombol_apk/screens/login/auth_gate.dart';
import 'package:trombol_apk/screens/login/create_acc.dart';
import 'package:trombol_apk/screens/login/forgot_pwd.dart';
import 'package:trombol_apk/screens/seller/seller_main.dart';

class LoginUser extends StatelessWidget {
  const LoginUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ DON'T navigate manually here
      // AuthGate will automatically listen to authStateChanges
      // and route accordingly

    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'user-not-found' => 'No user found for that email.',
        'wrong-password' => 'Wrong password provided.',
        'invalid-email' => 'That email address is invalid.',
        'user-disabled' => 'This user has been disabled.',
        _ => 'Login failed. ${e.message}',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    _buildLogo(),
                    const SizedBox(height: 30),
                    _buildLoginForm(),
                    const SizedBox(height: 20),

                    // Create Account link
                    _buildCreateAccount(),

                    // NEW: Admin login link
                    // const SizedBox(height: 12),
                    // GestureDetector(
                    //   onTap: () {
                    //     if (!mounted) return;
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => const LoginAdmin(),
                    //       ),
                    //     );
                    //   },
                    //   child: const Text.rich(
                    //     TextSpan(
                    //       text: 'Are you an Admin? ',
                    //       children: [
                    //         TextSpan(
                    //           text: 'Login using Admin ID',
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black38,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogo() => Column(
    children: [
      Container(
        width: 103,
        height: 102,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/trombol_logo_dark.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Welcome to Paradise',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
      const Text(
        'Please enter your login details below...',
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    ],
  );

  Widget _buildLoginForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Email'),
      _buildTextField(
        controller: _emailController,
        hint: "Enter your email address",
        obscure: false,
      ),

      const SizedBox(height: 14),


      const Text('Password'),
      _buildTextField(
        controller: _passwordController,
        hint: "Enter your password",
        obscure: _obscurePassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            size: 18,
          ),
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),

      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
            );
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(color: Color(0xFF0060D2)),
          ),
        ),
      ),

      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
          try {
          // Run your auth logic
          await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
          );

          // ✅ Navigate to AuthGate after login
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
          (route) => false,
          );
          } catch (e) {
          // Handle login errors
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
          );
          }
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3D6B), // your theme blue
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
          ),

  child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      ),
    ],
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    Widget? suffixIcon,
  }) =>
      Container(
        margin: const EdgeInsets.only(top: 4, bottom: 12),
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          keyboardType: hint.contains('email')
              ? TextInputType.emailAddress
              : TextInputType.text,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
            const TextStyle(fontSize: 12, color: Colors.black54),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            suffixIcon: suffixIcon,
          ),
        ),
      );

  Widget _buildCreateAccount() => GestureDetector(
    onTap: () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CreateAcc()),
      );
    },
    child: const Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: 'Do not have an account? ',
              style: TextStyle(color: Colors.black)),
          TextSpan(
            text: 'Create Account',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ],
      ),
    ),
  );
}
