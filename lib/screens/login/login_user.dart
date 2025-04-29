import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/homepage/explore.dart';
import 'package:trombol_apk/screens/login/create_acc.dart';
import 'package:trombol_apk/screens/login/forgot_pwd.dart';
import 'package:trombol_apk/screens/seller/seller_main.dart';

class LoginUser extends StatelessWidget {
  const LoginUser({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == "admin" && password == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SellerMain()),
      );
    } else if (email == "user" && password == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ExploreToday()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username or password")),
      );
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
                    _buildSocialLogin(),
                    const SizedBox(height: 30),
                    _buildCreateAccount(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
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
          'Please choose your login option below',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email'),
        _buildTextField(_emailController, "Enter your email address"),
        const SizedBox(height: 14),
        const Text('Password'),
        _buildTextField(
          _passwordController,
          "Enter your password",
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              size: 18,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
            ),
            child: const Text('Forgot password?', style: TextStyle(color: Color(0xFF0060D2))),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xD6042B55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false, Widget? suffixIcon}) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 12),
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Or login with'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                title: "Facebook",
                onPressed: () {},
                icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SocialButton(
                title: "Gmail",
                onPressed: () {},
                icon: Image.asset("assets/images/google_icon.png", width: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateAccount() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAcc()));
      },
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Do not have an account? ', style: TextStyle(color: Colors.black)),
            TextSpan(text: 'Create Account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Widget icon;

  const _SocialButton({
    required this.title,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 5),
            Text(title, style: const TextStyle(color: Colors.black, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
