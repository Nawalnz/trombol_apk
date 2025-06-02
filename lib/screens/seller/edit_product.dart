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
  List<File> _imageFiles = [];
  List<String> _existingImageUrls = [];
  List<DateTime> _unavailableDates = [];

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

    _nameController.text = p['name'] ?? '';
    final rawPrice = p['prod_pricePerPax'] ?? p['price'];
    _priceController.text = rawPrice != null ? rawPrice.toString() : '';
    _descriptionController.text = p['description'] ?? '';
    _category = p['type'];
    final images = (p['image'] as List?)?.cast<String>() ?? [];
    _existingImageUrls = images;
    final List<dynamic>? dates = p['unavailableDates'];
    if (dates != null) {
      _unavailableDates = dates.map((d) => DateTime.parse(d.toString())).toList();
    }

  }

  Future<void> _pickImage() async {
    if (_imageFiles.length + _existingImageUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can upload up to 5 images only')),
      );
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFiles.add(File(picked.path));
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final description = _descriptionController.text.trim();
    List<String> uploadedUrls = [];
    for (var imageFile in _imageFiles) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final ref = FirebaseStorage.instance.ref().child('product_images/$fileName');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      uploadedUrls.add(url);
    }

    final allImages = [..._existingImageUrls, ...uploadedUrls];

    final searchIndex = {
      ...name.toLowerCase().split(' '),
      ...description.toLowerCase().split(' '),
      name.toLowerCase(),
      description.toLowerCase(),
    }.toList();

    final products = {
      'name': name,
      'price': price,
      'type': _category,
      'description': description,
      'image': allImages,
      'edited': FieldValue.serverTimestamp(),
      'unavailableDates': _unavailableDates.map((d) => d.toIso8601String()).toList(),
      'searchIndex': searchIndex,
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

                          items: ['accommodation', 'relaxation', 'nature', 'activity']

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
                  child: const Icon(Icons.upload, size: 40, color: Colors.grey),
                ),
              ),


              SizedBox(height: 8),
              _buildImagePreview(),

              const SizedBox(height: 16),
              const Text("Unavailable Dates", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._unavailableDates.map((date) => Chip(
                    label: Text("${date.toLocal()}".split(' ')[0]),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() => _unavailableDates.remove(date));
                    },
                  )),
                  ActionChip(
                    label: const Text("Add Date"),
                    avatar: const Icon(Icons.date_range),
                    onPressed: () async {
                      final pickedRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedRange != null) {
                        final range = List.generate(
                          pickedRange.end.difference(pickedRange.start).inDays + 1,
                              (i) => DateTime(
                            pickedRange.start.year,
                            pickedRange.start.month,
                            pickedRange.start.day + i,
                          ),
                        );
                        setState(() {
                          for (final d in range) {
                            if (!_unavailableDates.contains(d)) {
                              _unavailableDates.add(d);
                            }
                          }
                        });
                      }

                    },
                  )
                ],
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