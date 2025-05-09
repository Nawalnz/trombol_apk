import 'package:flutter/material.dart';

class UploadProductPage extends StatefulWidget {
  const UploadProductPage({super.key});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  String? _imagePath;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = _priceController.text;
      final description = _descriptionController.text;

      // TODO: Replace with actual database code
      /*
      await FirebaseFirestore.instance.collection('products').add({
        'name': name,
        'price': price,
        'category': _category,
        'description': description,
        'image': _imagePath,
      });
      */

      print("Submitted: $name, $price, $_category, $description, $_imagePath");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product submitted!')),
      );
    }
  }

  void _resetForm() {
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    setState(() {
      _category = null;
      _imagePath = null;
    });
  }

  Future<void> _pickImage() async {
    setState(() {
      _imagePath = 'assets/images/beach.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Upload Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Let them know your hidden gems!",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Product Name
              const Text("Product Name", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Enter product name'),
                validator: (value) => value!.isEmpty ? 'Enter product name' : null,
              ),

              const SizedBox(height: 16),

              // Category & Price
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _category,
                          decoration: _inputDecoration("Select category"),
                          items: ['Adventure', 'Relaxation', 'Nature']
                              .map((String value) =>
                              DropdownMenuItem(value: value, child: Text(value)))
                              .toList(),
                          onChanged: (value) => setState(() => _category = value),
                          validator: (value) => value == null ? 'Select a category' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _priceController,
                          decoration: _inputDecoration('Enter price'),
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? 'Enter price' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Describe your product'),
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              // Upload Image
              const Text("Upload Image", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: _imagePath == null
                      ? const Icon(Icons.upload, size: 40)
                      : const Text('✔ Image Selected'),
                ),
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004C6D), // dark blue
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF004C6D)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Reset', style: TextStyle(color: Color(0xFF004C6D))),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
