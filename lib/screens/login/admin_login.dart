// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // user screens
// import 'login_user.dart';
// import 'package:trombol_apk/screens/seller/seller_main.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//   runApp(const AdminApp());
// }
//
// class AdminApp extends StatelessWidget {
//   const AdminApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginAdmin(),
//     );
//   }
// }
//
// class LoginAdmin extends StatefulWidget {
//   const LoginAdmin({super.key});
//
//   @override
//   State<LoginAdmin> createState() => _LoginAdminState();
// }
//
// class _LoginAdminState extends State<LoginAdmin> {
//   final TextEditingController _adminIdController  = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _adminIdController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _handleLogin() async {
//     final adminId  = _adminIdController.text.trim();
//     final password = _passwordController.text.trim();
//
//     if (adminId.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter Admin email and password')),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     // cache these before the await
//     final messenger = ScaffoldMessenger.of(context);
//     final navigator = Navigator.of(context);
//
//     try {
//       final query = await FirebaseFirestore.instance
//           .collection('admins')
//           .where('admin_ID', isEqualTo: adminId)
//           .where('admin_pwd',isEqualTo: password)
//           .limit(1)
//           .get();
//
//       if (!mounted) return;
//
//       if (query.docs.isNotEmpty) {
//         navigator.pushReplacement(
//           MaterialPageRoute(builder: (_) => const SellerMain()),
//         );
//       } else {
//         messenger.showSnackBar(
//           const SnackBar(
//             content: Text('Invalid admin credentials'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } on FirebaseException catch (e) {
//       messenger.showSnackBar(
//         SnackBar(
//           content: Text('Login error: ${e.message}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 26),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/images/trombol_logo_dark.png',
//                       width: 120, height: 120, fit: BoxFit.contain,
//                     ),
//                     const SizedBox(height: 24),
//                     const Text(
//                       'Welcome to Paradise',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 22,
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Please enter your Admin email and password',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.black54,
//                         fontSize: 15,
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text('Admin Email'),
//                     ),
//                     const SizedBox(height: 6),
//                     _buildInputField(
//                       controller: _adminIdController,
//                       hint: 'Enter your admin email',
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     const SizedBox(height: 16),
//
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text('Password'),
//                     ),
//                     const SizedBox(height: 6),
//                     _buildInputField(
//                       controller: _passwordController,
//                       hint: 'Enter your password',
//                       obscureText: _obscurePassword,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.black54,
//                         ),
//                         onPressed: () => setState(
//                               () => _obscurePassword = !_obscurePassword,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _handleLogin,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xD6042B55),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         child: _isLoading
//                             ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                             : const Text(
//                           'Login',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.black),
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const LoginUser()),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//           if (_isLoading)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black38,
//                 child: const Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String hint,
//     TextInputType keyboardType = TextInputType.text,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     const fieldHeight = 52.0;
//     const fontSize = 15.0;
//     const verticalPadding = (fieldHeight - fontSize) / 2;
//
//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         height: fieldHeight,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: TextField(
//           controller: controller,
//           keyboardType: keyboardType,
//           obscureText: obscureText,
//           style: const TextStyle(fontSize: fontSize, height: 1.0),
//           textAlignVertical: TextAlignVertical.center,
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: const TextStyle(
//               fontSize: fontSize,
//               height: 1.0,
//               color: Colors.black54,
//             ),
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 15,
//               vertical: verticalPadding,
//             ),
//             suffixIcon: suffixIcon,
//           ),
//         ),
//       ),
//     );
//   }
// }