import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  final String oobCode;
  const ResetPassword({super.key, required this.oobCode});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _pwdCtrl = TextEditingController();
  bool _obscure = true, _loading = false;
  String? _email;
  String? _codeError;

  @override
  void initState() {
    super.initState();
    _verifyCode();
  }

  Future<void> _verifyCode() async {
    try {
      final email = await FirebaseAuth.instance
          .verifyPasswordResetCode(widget.oobCode);
      if (!mounted) return;
      setState(() => _email = email);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _codeError = e.message);
    }
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);
    final pwd = _pwdCtrl.text.trim();
    if (pwd.length < 6) {
      messenger.showSnackBar(const SnackBar(
        content: Text('Password must be ≥ 6 chars'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.oobCode,
        newPassword: pwd,
      );
      messenger.showSnackBar(const SnackBar(
        content: Text('Password reset! Please login.'),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pop(); // back to login
    } on FirebaseAuthException catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text(e.message ?? 'Error resetting password'),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_codeError != null) {
      return Center(
        child: Text(
          'Invalid or expired link:\n$_codeError',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    if (_email == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Resetting for: $_email'),
            const SizedBox(height: 20),
            TextField(
              controller: _pwdCtrl,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'New Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Set New Password'),
            ),
          ],
        ),
      ),
    );
  }
}