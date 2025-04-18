import 'package:flutter/material.dart';
import 'package:testing/screens/onboarding1.dart';

void main() {
  runApp(const Paradise());
}

class Paradise extends StatelessWidget {
  const Paradise({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paradise App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      simulateLoading(context);
    });
  }

  void simulateLoading(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboarding1(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'folder/Logo.png',
              width: 160,
              height: 163,
            ),
            const SizedBox(height: 20), // Space between logo and loading indicator
            const CircularProgressIndicator(
              color: Colors.black54, // Set the indicator color to black
              strokeWidth: 1,
            ), // Circular loading indicator
          ],
        ),
      ),
    );
  }
}
