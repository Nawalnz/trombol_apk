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
  late List<String> images;
  late String title;
  late String description;
  late String location;
  late String address;
  late double price;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    final data = widget.tourData;
    images = (data['image'] as List?)?.cast<String>() ?? [];
    title = data['name'] ?? 'No title';
    description = data['description'] ?? 'No description';
    location = data['location'] ?? 'Unknown location';
    address = data['address'] ?? '';
    price = double.tryParse(data['price'].toString()) ?? 0.0;
    _loadLikedState();
  }

  Future<void> _loadLikedState() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final liked = List<String>.from(doc.data()?['likedProducts'] ?? []);
    final id = widget.tourData['id']; // Ensure this ID is passed in `tourData`
    setState(() {
      isLiked = id != null && liked.contains(id);
    });
  }

  Future<void> _toggleLike() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final id = widget.tourData['id'];
    if (uid == null || id == null) return;

    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    setState(() => isLiked = !isLiked);

    await ref.update({
      'likedProducts': isLiked
          ? FieldValue.arrayUnion([id])
          : FieldValue.arrayRemove([id]),
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainImage = images.isNotEmpty ? images.first : 'https://via.placeholder.com/150';
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.4;

    return Scaffold(
      body: Stack(
        children: [

          ListView(
            children: [
              Stack(
                children: [
                  Image.network(
                    mainImage,
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: _circleIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: _circleIconButton(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      onPressed: _toggleLike,
                      color: isLiked ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showGallery(context),
                          child: _roundedSmallBox('+${images.length} Photos', context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _ratingRow(),
                    const SizedBox(height: 24),
                    _sectionTitle('About'),
                    const SizedBox(height: 8),
                    Text(description),
                    const SizedBox(height: 24),
                    const Divider(),
                    _sectionTitle('Reviews'),
                    const SizedBox(height: 8),
                    _buildReviewItem('Mak Limah', 'Good Place', 'Okay okay je price not bad'),
                    _buildReviewItem("Walid's Wife", 'Good Place', 'Not bad but not good lah'),
                    const SizedBox(height: 24),
                    const Divider(),
                    _sectionTitle('People frequently ask'),
                    const SizedBox(height: 8),
                    _buildFAQItem('About this place', 'Lorem ipsum dolor sit amet.'),
                    _buildFAQItem('Terms and Conditions', 'Lorem ipsum dolor sit amet.'),
                    _buildFAQItem('Cancellation Policy', 'Lorem ipsum dolor sit amet.'),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BookingCalendar()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF085373),
                      minimumSize: const Size(150, 48),
                    ),
                    child: const Text('Book Now', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGallery(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              itemBuilder: (_, index) {
                return InteractiveViewer(
                  child: Center(
                    child: Image.network(
                      images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
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

  Widget _buildGoogleMapsPreview() => GestureDetector(
    onTap: () async {
      const url = 'https://goo.gl/maps/2dCjdRfwRzbpM3G79';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        'https://maps.googleapis.com/maps/api/staticmap?center=1.467022,110.239303&zoom=15&size=600x300',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget _circleIconButton({required IconData icon, VoidCallback? onPressed, Color color = Colors.black}) =>
      CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(icon: Icon(icon, color: color), onPressed: onPressed),
      );

  Widget _sectionTitle(String title) => Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

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

  Widget _roundedSmallBox(String text, BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.grey.shade300,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(text, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
  );

  Widget _includedItems(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      _includedCard(Icons.directions_bus, 'Bus', 'Transportation', context),
      _includedCard(Icons.access_time, '2 day 1 night', 'Duration', context),
      _includedCard(Icons.qr_code, 'TAC200812695', 'Product code', context),
    ],
  );

  Widget _includedCard(IconData icon, String title, String subtitle, BuildContext context) => Container(
    width: 160,
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300,
      ),
      borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).colorScheme.surface,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(178),
          ),
        ),
      ],
    ),
  );

  Widget _buildReviewItem(String name, String title, String comment) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.grey),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(comment),
          const SizedBox(height: 4),
          const Text('Visited date: Dec 2021', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
      trailing: const Icon(Icons.arrow_upward),
    ),
  );

  Widget _buildFAQItem(String title, String description) => ListTile(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(description, maxLines: 1, overflow: TextOverflow.ellipsis),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  );

}