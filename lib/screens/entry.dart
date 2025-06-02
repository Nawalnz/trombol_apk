import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trombol_apk/screens/onboarding/onboarding1.dart';
import 'package:trombol_apk/screens/login/auth_gate.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  bool? _onboardingCompleted;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;

    setState(() {
      _onboardingCompleted = completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingCompleted == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _onboardingCompleted!
        ? const AuthGate()
        : const Onboarding1(); // first onboarding screen
  }
}
