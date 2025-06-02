import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final String docId;

  const UploadProductPage({super.key, required this.product, required this.docId});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  String? _category;
  List<File> _imageFiles = [];
  List<String> _existingImageUrls = [];

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.docId.isNotEmpty) {
      final p = widget.product;
      _nameController.text = p['name'] ?? '';
      _priceController.text = p['price']?.toString() ?? '';
      _descriptionController.text = p['description'] ?? '';
      _category = p['type'] as String?;
      final images = (p['image'] as List?)?.cast<String>() ?? [];
      _existingImageUrls = images;
    }
  }

  Future<void> _pickImage() async {
    if (_imageFiles.length + _existingImageUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can upload up to 5 images only')),
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFiles.add(File(picked.path));
      });
    }
  }

  Future<List<String>> _uploadToStorage() async {
    List<String> urls = [];
    for (var imageFile in _imageFiles) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final ref = FirebaseStorage.instance.ref().child('product_images').child(fileName);
      final snapshot = await ref.putFile(imageFile);
      final url = await snapshot.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

      final roleDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
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

      if (!_formKey.currentState!.validate()) return;
      if (_imageFiles.isEmpty && _existingImageUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload at least one image')),
        );
        return;
      }

      final name = _nameController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0;
      final desc = _descriptionController.text.trim();

      final uploadedUrls = await _uploadToStorage();
      final allImageUrls = [..._existingImageUrls, ...uploadedUrls];

      final now = FieldValue.serverTimestamp();

      final searchIndex = [
        ...name.toLowerCase().split(' '),
        ...desc.toLowerCase().split(' '),
        name.toLowerCase(),
        desc.toLowerCase(),
        _category?.toLowerCase() ?? '',
        price.toString(),
      ];


      final data = {
        'name': name,
        'price': price,
        'type': _category,
        'description': desc,
        'image': allImageUrls,
        'edited': now,
        'searchIndex': searchIndex,
      };
      if (widget.docId.isEmpty) data['created'] = now;

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
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    setState(() {
      _category = null;
      _imageFiles = [];
      _existingImageUrls = [];
    });
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Widget _buildImagePreview() {
    final previews = <Widget>[];

    for (var i = 0; i < _existingImageUrls.length; i++) {
      final url = _existingImageUrls[i];
      previews.add(Stack(
        children: [
          Image.network(url, height: 100, width: 100, fit: BoxFit.cover),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => setState(() => _existingImageUrls.removeAt(i)),
              child: const Icon(Icons.close, color: Colors.red),
            ),
          )
        ],
      ));
    }

    for (var i = 0; i < _imageFiles.length; i++) {
      final file = _imageFiles[i];
      previews.add(Stack(
        children: [
          Image.file(file, height: 100, width: 100, fit: BoxFit.cover),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => setState(() => _imageFiles.removeAt(i)),
              child: const Icon(Icons.close, color: Colors.red),
            ),
          )
        ],
      ));
    }

    return Wrap(spacing: 8, runSpacing: 8, children: previews);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Upload New Product')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: _scrollController,
                children: [
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Enter product name'),
                    validator: (v) => v == null || v.isEmpty ? 'Enter product name' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _category,
                        decoration: _inputDecoration('Select category'),
                        items: ['accommodation', 'nature', 'activity']
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (c) => setState(() => _category = c),
                        validator: (v) => v == null ? 'Select a category' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: _inputDecoration('Enter price'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: _inputDecoration('Describe your product'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  const Text('Upload Images (max 5)', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      child: const Icon(Icons.upload, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildImagePreview(),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004C6D),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                        onPressed: _isSubmitting ? null : _resetForm,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF004C6D)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Reset', style: TextStyle(color: Color(0xFF004C6D))),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          if (_isSubmitting)
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
}

