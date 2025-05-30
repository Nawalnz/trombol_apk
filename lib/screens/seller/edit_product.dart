import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'product_model.dart';

class EditProductPage extends StatefulWidget {
  final Product productToEdit;

  const EditProductPage({super.key, required this.productToEdit});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  String? _category;
  String? _imagePath; // For new local image path
  String? _existingImageUrl; // To store current image url/path

  bool _isLoading = false;

  // Define your categories list
  final List<String> _categories = ['Adventure', 'Relaxation', 'Nature', 'Popular Activities'];


  @override
  void initState() {
    super.initState();
    // Initialize controllers and state with the product's current data
    _nameController = TextEditingController(text: widget.productToEdit.name);
    _priceController = TextEditingController(text: widget.productToEdit.price);
    _descriptionController = TextEditingController(text: widget.productToEdit.description);
    _category = widget.productToEdit.category;
    _existingImageUrl = widget.productToEdit.image;
    // Ensure the initial category is in the list, if not, set to null or a default
    if (!_categories.contains(_category)) {
      _category = null;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
        _existingImageUrl = null; // Clear existing image if new one is picked
      });
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (widget.productToEdit.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Product ID is missing.')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    // Here you would handle image uploading if _imagePath is new.
    // For simplicity, this example assumes _imagePath is an asset path or new URL.
    // In a real app, if _imagePath is a local file path, upload to Firebase Storage first
    // and get the downloadURL to save in Firestore.

    String finalImageUrl = _existingImageUrl ?? _imagePath ?? widget.productToEdit.image;
    // If _imagePath is a local file path (not an URL/asset path), you'd upload it here
    // and update finalImageUrl with the download URL.

    Map<String, dynamic> updatedData = {
      'name': _nameController.text,
      'price': _priceController.text,
      'category': _category,
      'description': _descriptionController.text,
      'image': finalImageUrl, // This should be the URL after upload or existing URL/asset path
    };

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productToEdit.id)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      if (mounted) {
        Navigator.pop(context, true); // Pop with 'true' to indicate success
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: $e')),
      );
    } finally {
      if(mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Your form UI will go here, similar to UploadProductPage
    // Use _nameController, _priceController, _descriptionController, _category, _imagePath
    // Pre-fill the fields using widget.productToEdit data

    Widget imageDisplay;
    if (_imagePath != null) {
      imageDisplay = Image.file(File(_imagePath!), height: 200, width: double.infinity, fit: BoxFit.cover);
    } else if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty) {
      if (_existingImageUrl!.startsWith('http')) {
        imageDisplay = Image.network(_existingImageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover);
      } else {
        imageDisplay = Image.asset(_existingImageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover);
      }
    } else {
      imageDisplay = Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.productToEdit.name}'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => (value == null || value.isEmpty) ? 'Enter product name' : null,
              ),
              const SizedBox(height: 16),
              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (e.g., RM120.00)'),
                keyboardType: TextInputType.text, // Or number if you parse it strictly
                validator: (value) => (value == null || value.isEmpty) ? 'Enter price' : null,
              ),
              const SizedBox(height: 16),
              // Category
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((String value) { // Use your _categories list
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) => setState(() => _category = value),
                validator: (value) => value == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => (value == null || value.isEmpty) ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),
              // Image Picker
              const Text("Product Image", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: imageDisplay,
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.image_search),
                  label: const Text('Change Image'),
                  onPressed: _pickImage,
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _updateProduct,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
