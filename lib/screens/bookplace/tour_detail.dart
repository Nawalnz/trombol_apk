import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/bookplace/available_date.dart';
import 'package:url_launcher/url_launcher.dart'; // Make sure to add this import

class TourDetailPage extends StatelessWidget {
  final Map<String, dynamic> tourData;

  const TourDetailPage({super.key, required this.tourData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Stack(
                children: [
                  Image.asset(
                    tourData['image'],
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
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
                    right: 70,
                    child: _circleIconButton(icon: Icons.share),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: _circleIconButton(icon: Icons.favorite_border),
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
                          child: Text(
                            tourData['title'],
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _roundedSmallBox('+100 Photos'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _ratingRow(),

                    const SizedBox(height: 24),
                    _sectionTitle('About'),
                    const SizedBox(height: 8),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                          'Consectetur condimentum morbi non egestas enim amet sagittis. '
                          'Proin sed aliquet rhoncus ut pellentesque ullamcorper sit eget ac. '
                          'Sit nisi, cras amet varius eget egestas pellentesque. '
                          'Cursus gravida euismod non...',
                    ),
                    const SizedBox(height: 8),
                    const Text('Read all', style: TextStyle(color: Colors.blue)),

                    const SizedBox(height: 24),
                    const Divider(),

                    _sectionTitle('What is included'),
                    const SizedBox(height: 16),
                    _includedItems(),

                    const SizedBox(height: 24),
                    const Divider(),

                    _sectionTitle('Where will you stay'),
                    const SizedBox(height: 8),
                    _buildGoogleMapsPreview(),

                    const SizedBox(height: 8),
                    const Text('Borneo Happy Farm'),
                    const Text('Kuching, Sarawak, Malaysia'),

                    const SizedBox(height: 24),
                    const Divider(),

                    _sectionTitle('Reviews'),
                    const SizedBox(height: 8),
                    _buildReviewItem('Mak Limah', 'Good Place', 'Okay okay je price not bad'),
                    _buildReviewItem('Walid\'s Wife', 'Good Place', 'Not bad but not good lah'),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('See all +97 reviews'),
                    ),

                    const SizedBox(height: 24),
                    const Divider(),

                    _sectionTitle('People frequently ask'),
                    const SizedBox(height: 8),
                    _buildFAQItem('About this place', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                    _buildFAQItem('Terms and Conditions', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                    _buildFAQItem('Cancellation Policy', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),

          // Bottom Book Now bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${tourData['price']}/Person',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingCalendar(), // <- Navigate to AvailableDate page!
                        ),
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

  // ========== Widgets ==========

  Widget _buildGoogleMapsPreview() {
    return GestureDetector(
      onTap: () async {
        const googleMapsUrl = 'https://goo.gl/maps/2dCjdRfwRzbpM3G79'; // Link for Borneo Happy Farm

        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl));
        } else {
          throw 'Could not open Google Maps.';
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

    // ⚡ Later for dynamic location, you can use this:
    /*
    onTap: () async {
      final latitude = tourData['latitude'];
      final longitude = tourData['longitude'];
      final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      ...
    }
    */
  }

  Widget _circleIconButton({required IconData icon, VoidCallback? onPressed}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _ratingRow() {
    return Row(
      children: const [
        Icon(Icons.star, color: Colors.orange, size: 16),
        Icon(Icons.star, color: Colors.orange, size: 16),
        Icon(Icons.star, color: Colors.orange, size: 16),
        Icon(Icons.star, color: Colors.orange, size: 16),
        Icon(Icons.star_border, color: Colors.orange, size: 16),
        SizedBox(width: 8),
        Text('. 100 reviews', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _roundedSmallBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _includedItems() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _includedCard(Icons.directions_bus, 'Bus', 'Transportation'),
        _includedCard(Icons.access_time, '2 day 1 night', 'Duration'),
        _includedCard(Icons.qr_code, 'TAC200812695', 'Product code'),
      ],
    );
  }

  Widget _includedCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: Colors.black),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String title, String comment) {
    return Padding(
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
  }

  Widget _buildFAQItem(String title, String description) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
