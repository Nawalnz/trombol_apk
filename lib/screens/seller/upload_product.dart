import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductPage extends StatefulWidget {
  const UploadProductPage({super.key});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final _formKey = GlobalKey<FormState>();
  String? _prodType;
  String? _imageUrl;
  DocumentReference? _selectedKeyword;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<DocumentSnapshot> _keywords = [];
  List<String> _uploadedImageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchKeywords();
    _fetchUploadedImages();
  }

  Future<void> _fetchKeywords() async {
    final snapshot = await FirebaseFirestore.instance.collection('Keywords').get();
    setState(() {
      _keywords = snapshot.docs;
    });
  }

  Future<void> _fetchUploadedImages() async {
    final ListResult result = await FirebaseStorage.instance.ref('product_images').listAll();
    final urls = await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
    setState(() {
      _uploadedImageUrls = urls;
    });
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('product_images/$fileName');
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
        _uploadedImageUrls.add(downloadUrl);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _imageUrl != null && _selectedKeyword != null) {
      final name = _nameController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final description = _descriptionController.text;

      try {
        await FirebaseFirestore.instance.collection('Product').add({
          'prod_name': name,
          'prod_desc': description,
          'prod_types': _prodType,
          'prod_pricePerPax': price,
          'prod_files': _imageUrl,
          'prod_keywordID': _selectedKeyword,
          'prod_facID': null,
          'prod_reviews': null,
          'prod_FAQ': '',
          'prod_ID': DateTime.now().millisecondsSinceEpoch,
          'prod_timeCreated': Timestamp.now(),
          'prod_lastEdited': Timestamp.now(),
          'prod_lastAccessed': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product submitted to Firestore!')),
        );

        _resetForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  void _resetForm() {
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    setState(() {
      _prodType = null;
      _imageUrl = null;
      _selectedKeyword = null;
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
              const Text("Let them know your hidden gems!", style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 16),

              _buildTextField("Product Name", _nameController, 'Enter product name'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildDropdownField("Product Type", _prodType, ['accommodation', 'nature', 'activity'], (value) => setState(() => _prodType = value))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField("Price per Pax", _priceController, 'Enter price', isNumber: true)),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField("Description", _descriptionController, 'Describe your product', multiline: true),
              const SizedBox(height: 16),

              const Text("Keyword", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<DocumentReference>(
                value: _selectedKeyword,
                decoration: _inputDecoration('Select keyword'),
                items: _keywords.map((doc) => DropdownMenuItem(
                  value: doc.reference,
                  child: Text(doc['name'] ?? doc.id),
                )).toList(),
                onChanged: (value) => setState(() => _selectedKeyword = value),
                validator: (value) => value == null ? 'Select a keyword' : null,
              ),
              const SizedBox(height: 16),

              const Text("Upload Image", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickAndUploadImage,
                child: const Text("Select and Upload Image"),
              ),
              const SizedBox(height: 8),

              if (_imageUrl != null) Image.network(_imageUrl!, height: 150),
              const SizedBox(height: 16),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004C6D),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool isNumber = false, bool multiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: multiline ? 3 : 1,
          decoration: _inputDecoration(hint),
          validator: (value) => value!.isEmpty ? 'Enter $label' : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> options, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: _inputDecoration("Select $label"),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? 'Select $label' : null,
        ),
      ],
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
