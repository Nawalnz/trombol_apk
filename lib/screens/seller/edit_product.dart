import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final String docId;

  const EditProductPage({
    super.key,
    required this.product,
    required this.docId,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage>
    with AutomaticKeepAliveClientMixin<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  File? _imageFile;
  String? _existingImageUrl;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController.text        = p['name'] ?? '';
    // support both price field keys
    final rawPrice = p['prod_pricePerPax'] ?? p['price'];
    _priceController.text       = rawPrice != null ? rawPrice.toString() : '';
    _descriptionController.text = p['description'] ?? '';
    _category                   = p['type'];
    final imageList = p['image'] as List<dynamic>? ?? [];
    _existingImageUrl = imageList.isNotEmpty ? imageList.first as String : null;

  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        _existingImageUrl = null;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final name        = _nameController.text.trim();
    final price       = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final description = _descriptionController.text.trim();
    String? imageUrl  = _existingImageUrl;

    if (_imageFile != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_imageFile!.path.split('/').last}';
      final ref = FirebaseStorage.instance
          .ref()
          .child('product_images/$fileName');
      await ref.putFile(_imageFile!);
      imageUrl = await ref.getDownloadURL();
    }

    final products = {
      'name'        : name,
      'price'       : price,
      'type'       : _category,
      'description'        : description,
      'image'            : imageUrl,
      'edited' : FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.docId)
          .update(products);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating product: $e')),
      );
    }
  }

  Future<void> _deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this product?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.docId)
          .delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product: $e')),
      );
    }
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
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: _scrollController,
            children: [
              const Text(
                "Let them know your hidden gems!",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              const Text("Product Name", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Enter product name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter product name' : null,
              ),

              const SizedBox(height: 16),
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
                        const Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
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
                ],
              ),

              const SizedBox(height: 16),
              const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Describe your product'),
                maxLines: 3,
              ),

              const SizedBox(height: 16),
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
                  child: _imageFile != null
                      ? Image.file(_imageFile!, height: 100, fit: BoxFit.cover)
                      : (_existingImageUrl != null
                      ? Image.network(_existingImageUrl!, height: 100, fit: BoxFit.cover)
                      : const Icon(Icons.upload, size: 40)),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
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
                      child: const Text('Update', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _deleteProduct,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFB00020)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Delete', style: TextStyle(color: Color(0xFFB00020))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
