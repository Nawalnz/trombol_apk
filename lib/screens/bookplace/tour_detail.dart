import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'available_date.dart';

class TourDetailPage extends StatefulWidget {
  final Map<String, dynamic> tourData;

  const TourDetailPage({super.key, required this.tourData});

  @override
  State<TourDetailPage> createState() => _TourDetailPageState();
}

class _TourDetailPageState extends State<TourDetailPage> {
  late final List<String> images;
  late final String title;
  late final String description;
  late final String location;
  late final String address;
  late final double price;
  late final String type;
  late final String productId;
  late final String preview;

  bool isLiked = false;

  @override
  void initState() {
    super.initState();

    final data = widget.tourData;

    // ✅ SAFELY EXTRACT REQUIRED FIELDS
    productId = data['id'] ?? '';
    type = data['type'] ?? '';
    images = (data['image'] as List?)?.cast<String>() ?? [];
    title = data['name'] ?? 'No title';
    description = data['description'] ?? 'No description';
    location = data['location'] ?? 'Unknown location';
    address = data['address'] ?? '';
    price = double.tryParse(data['price'].toString()) ?? 0.0;

    preview = images.isNotEmpty ? images.first : 'https://via.placeholder.com/150';

    _loadLikedState();
  }

  Future<void> _loadLikedState() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || productId.isEmpty) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final liked = List<String>.from(doc.data()?['likedProducts'] ?? []);

    setState(() => isLiked = liked.contains(productId));
  }

  Future<void> _toggleLike() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || productId.isEmpty) return;

    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    setState(() => isLiked = !isLiked);

    await ref.update({
      'likedProducts': isLiked
          ? FieldValue.arrayUnion([productId])
          : FieldValue.arrayRemove([productId]),
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainImage = images.isNotEmpty ? images.first : 'https://via.placeholder.com/150';

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Stack(
                children: [
                  Image.network(
                    mainImage,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: _circleIconButton(icon: Icons.arrow_back, onPressed: () => Navigator.pop(context)),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: _circleIconButton(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.black,
                      onPressed: _toggleLike,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleRow(),
                    const SizedBox(height: 8),
                    _ratingRow(),
                    const SizedBox(height: 24),
                    _sectionTitle("About"),
                    const SizedBox(height: 8),
                    Text(description),
                    const SizedBox(height: 24),
                    const Divider(),
                    _sectionTitle("Reviews"),
                    _buildReviewItem("Mak Limah", "Good Place", "Okay okay je price not bad"),
                    _buildReviewItem("Walid's Wife", "Good Place", "Not bad but not good lah"),
                    const SizedBox(height: 24),
                    const Divider(),
                    _sectionTitle("FAQ"),
                    _buildFAQItem("About this place", "Lorem ipsum dolor sit amet."),
                    _buildFAQItem("Cancellation", "Lorem ipsum dolor sit amet."),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _titleRow() {
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        GestureDetector(
          onTap: () => _showGallery(context),
          child: _roundedSmallBox('+${images.length} Photos'),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'RM${price.toStringAsFixed(2)}/Person',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingCalendar(
                      productId: productId,
                      productName: title,
                      productType: type,
                      price: price,
                      productImage: preview,
                    ),
                  ),
                );
              },
              child: const Text('Book Now'),
            ),

          ],
        ),
      ),
    );
  }

  void _showGallery(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              itemBuilder: (_, index) => Center(child: Image.network(images[index], fit: BoxFit.contain)),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, VoidCallback? onPressed, Color color = Colors.black}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(icon: Icon(icon, color: color), onPressed: onPressed),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _ratingRow() => const Row(
    children: [
      Icon(Icons.star, color: Colors.orange, size: 16),
      Icon(Icons.star, color: Colors.orange, size: 16),
      Icon(Icons.star, color: Colors.orange, size: 16),
      Icon(Icons.star, color: Colors.orange, size: 16),
      Icon(Icons.star_border, color: Colors.orange, size: 16),
      SizedBox(width: 8),
      Text('. 100 reviews', style: TextStyle(color: Colors.grey)),
    ],
  );

  Widget _roundedSmallBox(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
    child: Text(text, style: const TextStyle(fontSize: 12)),
  );

  Widget _buildReviewItem(String name, String title, String comment) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.grey),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(comment),
          const Text('Visited date: Dec 2021', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    ),
  );

  Widget _buildFAQItem(String title, String description) => ListTile(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(description, maxLines: 1, overflow: TextOverflow.ellipsis),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  );
}
