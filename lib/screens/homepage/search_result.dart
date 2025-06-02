import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/bookplace/tour_detail.dart';

class SearchResult extends StatefulWidget {
  final String searchKeyword;

  const SearchResult({super.key, required this.searchKeyword});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = [];
  Set<String> likedProductIds = {};

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchKeyword;
    _loadRecentSearches();
    _loadLikedProducts();
  }

  Future<void> _loadRecentSearches() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      recentSearches = List<String>.from(doc.data()?['recentSearches'] ?? []);
    });
  }

  Future<void> _saveRecentSearch(String value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    List<String> updatedSearches = List.from(recentSearches);

    updatedSearches.remove(value);
    updatedSearches.insert(0, value);
    if (updatedSearches.length > 3) {
      updatedSearches = updatedSearches.sublist(0, 3);
    }

    await docRef.update({'recentSearches': updatedSearches});
    setState(() => recentSearches = updatedSearches);
  }

  Future<void> _loadLikedProducts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      likedProductIds = Set<String>.from(doc.data()?['likedProducts'] ?? []);
    });
  }

  Future<void> _toggleLike(String productId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);

    final isLiked = likedProductIds.contains(productId);
    setState(() {
      if (isLiked) {
        likedProductIds.remove(productId);
      } else {
        likedProductIds.add(productId);
      }
    });

    await ref.update({
      'likedProducts': isLiked
          ? FieldValue.arrayRemove([productId])
          : FieldValue.arrayUnion([productId])
    });
  }

  Future<QuerySnapshot> _fetchSearchResults() {
    final keyword = widget.searchKeyword.toLowerCase();
    return FirebaseFirestore.instance
        .collection('products')
        .where('searchIndex', arrayContains: keyword)
        .get();
  }

  Widget _buildCard(Map<String, dynamic> data, String productId) {
    final image = (data['image'] as List?)?.cast<String>().firstOrNull ?? '';
    final title = data['name'] ?? 'Unnamed';
    final desc = data['description'] ?? 'No description';
    final price = data['price']?.toString() ?? '-';
    final isLiked = likedProductIds.contains(productId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TourDetailPage(tourData: {
              'id': productId,
              'name': title,
              'description': desc,
              'price': data['price'],
              'image': data['image'],
            }),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(image, height: 100, width: 160, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleLike(productId),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    desc.length > 40 ? '${desc.substring(0, 40)}...' : desc,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text('RM$price', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Where do you plan to go?',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    await _saveRecentSearch(value);
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchResult(searchKeyword: value),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _fetchSearchResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          final docs = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 16,
              children: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildCard(data, doc.id);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
