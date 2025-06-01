import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Product',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const UploadProductPage(product: {}, docId: ''),
    );
  }
}

/// A page to create or edit a product, including image upload to Firebase Storage
class UploadProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final String docId;

  const UploadProductPage({super.key, required this.product, required this.docId});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage>
    with AutomaticKeepAliveClientMixin<UploadProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  String? _category;
  File? _imageFile;
  String? _existingImageUrl;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.docId.isNotEmpty) {
      final p = widget.product;
      _nameController.text = p['prod_name'] ?? '';
      _priceController.text = p['prod_price'] ?? '';
      _descriptionController.text = p['prod_desc'] ?? '';
      _category = p['prod_types'] as String?;
      _existingImageUrl = p['image'] as String?;
    }
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        _existingImageUrl = null;
      });
    }
  }

  Future<String?> _uploadToStorage() async {
    if (_imageFile == null) return null;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_'
        '${_imageFile!.path.split('/').last}';
    final ref = FirebaseStorage.instance
        .ref()
        .child('product_images')
        .child(fileName);
    final snapshot = await ref.putFile(_imageFile!);
    return snapshot.ref.getDownloadURL();
  }

  /// UPDATED: Now simply reads user_roles/{uid}.isAdmin
  Future<void> _submitForm() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to upload products')),
      );

      return;
    }

    // Read the isAdmin flag
    final roleDoc = FirebaseFirestore.instance
        .collection('user_roles')
        .doc(user.uid);

    try {
      final snap = await roleDoc.get();
      if (!snap.exists || snap.data()?['isAdmin'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Insufficient permissions: Admin access required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking admin status: $e')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = _priceController.text.trim();
    final desc = _descriptionController.text.trim();

    String? imageUrl = _existingImageUrl;
    if (_imageFile != null) {
      imageUrl = await _uploadToStorage();
    }

    final data = {
      'prod_name': name,
      'prod_price': price,
      'prod_types': _category,
      'prod_desc': desc,
      'image': imageUrl,
      'prod_timeCreated': FieldValue.serverTimestamp(),
    };

    try {
      final coll = FirebaseFirestore.instance.collection('products');
      if (widget.docId.isEmpty) {
        await coll.add(data);
      } else {
        await coll.doc(widget.docId).update(data);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved successfully')),
      );
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving product: $e')),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    setState(() {
      _category = null;
      _imageFile = null;
      _existingImageUrl = null;
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Image.file(_imageFile!, height: 100, fit: BoxFit.cover);
    }
    if (_existingImageUrl != null) {
      return Image.network(_existingImageUrl!, height: 100, fit: BoxFit.cover);
    }
    return const Icon(Icons.upload, size: 40, color: Colors.grey);
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.teal, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: _scrollController,
            children: [
              Text(
                widget.docId.isEmpty
                    ? 'Create a new product'
                    : 'Edit your product',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Enter product name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter product name' : null,
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _category,
                        decoration: _inputDecoration('Select category'),
                        items: ['Adventure', 'Relaxation', 'Nature']
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (c) => setState(() => _category = c),
                        validator: (v) => v == null ? 'Select a category' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _priceController,
                        decoration: _inputDecoration('Enter price'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Describe your product'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const Text('Upload Image', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  child: _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004C6D),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      widget.docId.isEmpty ? 'Create Product' : 'Save Changes',
                      style: const TextStyle(color: Colors.white),
                    ),
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
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
