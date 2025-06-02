import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id; // Firestore document ID
  final String name;
  final String price; // Consider using double for calculations, String for display
  final String category;
  final String description;
  final String image; // Asset path or network URL

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
  });

  // Factory to create a Product from a Firestore document
  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Product(
      id: doc.id,
      name: data['name'] as String? ?? 'No Name',
      price: data['price'] as String? ?? '0.00',
      category: data['category'] as String? ?? 'Uncategorized',
      description: data['description'] as String? ?? 'No Description',
      image: data['image'] as String? ?? 'assets/images/placeholder.png', // Default placeholder
    );
  }

  // Method to convert Product to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'type': category,
      'description': description,
      'image': image,
    };
  }

  // Optional: A copyWith method can be useful for updating
  Product copyWith({
    String? id,
    String? name,
    String? price,
    String? category,
    String? description,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
}