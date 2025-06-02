import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/bookplace/payment.dart';

class BookingPage extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final String productType;
  final double price;
  final DateTime selectedStartDate;
  final DateTime? selectedEndDate;
  final String userEmail;

  const BookingPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.productType,
    required this.price,
    required this.selectedStartDate,
    this.selectedEndDate,
    required this.userEmail,
    required this.productImage,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}


class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isFormValid() {
    return _guestNameController.text.isNotEmpty &&
        _countController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _idController.text.isNotEmpty;
  }

  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _countController = TextEditingController(text: "1");
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _countController.text = '1'; // default value

    // Fill email with logged-in user's email
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      _emailController.text = user.email!;
    }
  }

  int get quantity {
    final val = int.tryParse(_countController.text);
    return (val != null && val >= 1) ? val : 1;
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _countController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String dateDisplay = widget.selectedEndDate != null
        ? "${_formatDate(widget.selectedStartDate)} - ${_formatDate(widget.selectedEndDate!)}"
        : _formatDate(widget.selectedStartDate);

    final int quantity = int.tryParse(_countController.text) ?? 1;
    final int numberOfDays = widget.selectedEndDate != null
        ? widget.selectedEndDate!.difference(widget.selectedStartDate).inDays + 1
        : 1;

    final double totalPrice = widget.price * quantity * numberOfDays;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Detail Booking", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Get the best out of Trombol by creating an account", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
          
              _infoRow(Icons.calendar_today, "Selected date: $dateDisplay"),
              const SizedBox(height: 12),
              _infoRow(Icons.access_time, "Duration: $numberOfDays day(s)"),
              const SizedBox(height: 24),
          
              _textField("Guest name", _guestNameController, onChanged: (_) => setState(() {})),
              const SizedBox(height: 16),
          
              _textField(
                  widget.productType == 'accommodation'
                      ? "Total Guest"
                      : "Total ${widget.productName} Needed",
                  _countController,
                  keyboardType: TextInputType.number, onChanged: (_) => setState(() {})
              ),
          
              const SizedBox(height: 16),
          
              _phoneField(),
              const SizedBox(height: 16),
          
              _textField("Email", _emailController, hintText: "mymymy@gmail.com", keyboardType: TextInputType.emailAddress, onChanged: (_) => setState(() {})),
              const SizedBox(height: 16),

              _textField("IC / Passport", _idController, onChanged: (_) => setState(() {})),

              const SizedBox(height: 16),
          
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: 'RM${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF085374)),
                children: [
                  TextSpan(
                    text: widget.productType == 'accommodation'
                        ? ' /$quantity Guest × $numberOfDays day(s)'
                        : ' /$quantity ${widget.productName} × $numberOfDays day(s)',

                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF085374)),
                  ),
                ],
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF085374),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isFormValid()
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentPage(
                      selectedDate: widget.selectedStartDate, 
                      email: widget.userEmail,
                      endDate: widget.selectedEndDate,
                      guestName: _guestNameController.text,
                      idNumber: _idController.text,
                      phone: _phoneController.text,
                      productId: widget.productId,
                      productImage: widget.productImage,
                      productName: widget.productName,
                      startDate: widget.selectedStartDate,
                      totalGuest: int.tryParse(_countController.text) ?? 1,
                      totalPrice: totalPrice,
                      
                      
                      
                      
                    ),
                  ),
                );
              }
                  : null,
              child: const Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )

          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller,
      {TextInputType? keyboardType, String? hintText, void Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _phoneField() {
    return Row(
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Text("+60")),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "123 456 789",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ), onChanged: (_) => setState(() {})
          ),
        ),
      ],
    );
  }
}
