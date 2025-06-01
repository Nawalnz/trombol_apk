import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required String name, required String docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('created', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading products: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              final doc = docs[i];
              final data = doc.data()! as Map<String, dynamic>;
              final imageList = data['image'] as List<dynamic>? ?? [];
              final imageUrl = imageList.isNotEmpty ? imageList.first as String : '';
              final isNetworkImage = imageUrl.startsWith('http');


              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl.isNotEmpty
                        ? (isNetworkImage
                        ? Image.network(imageUrl,
                        width: 60, height: 60, fit: BoxFit.cover)
                        : Image.asset(imageUrl,
                        width: 60, height: 60, fit: BoxFit.cover))
                        : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    data['name'] ?? '—',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${data['type'] ?? '—'} • \R\M${data['price'] ?? '—'}',
                  ),
                  onTap: () {
                    // Navigate and pass product data + docId
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditProductPage(
                          product: data,
                          docId: doc.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}