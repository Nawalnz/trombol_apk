import 'package:flutter/material.dart';
import 'package:mobcom/screens/available_date.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DamaiLagoonResortPage(),
    );
  }
}

class DamaiLagoonResortPage extends StatelessWidget {
  const DamaiLagoonResortPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: const TextSpan(
                text: 'RM600',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF085374),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '/Person',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF085374),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF085374),
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingCalendar()),
                );
              },
              child: const Text('Book Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                    'folder/damai.jpeg'),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context); // this will navigate back
                      },
                    ),
                  ),
                ),
                const Positioned(
                  top: 40,
                  right: 16,
                  child: FavoriteButton(),
                ),
                const Positioned(
                  bottom: 10,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Damai Lagoon Resort',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          Icon(Icons.star_half, color: Colors.orange, size: 16),
                          Icon(Icons.star_border,
                              color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          Text('100 reviews',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit... Read all'),
                  const SizedBox(height: 20),
                  const Text('What is included',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 10,
                    children: [
                      IncludedItem(
                          icon: Icons.directions_bus,
                          label: 'Bus\nTransportation'),
                      IncludedItem(
                          icon: Icons.calendar_today,
                          label: '2 day 1 night\nDuration'),
                      IncludedItem(
                          icon: Icons.qr_code,
                          label: 'TAC200812695\nProduct code'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Where will you stay',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Map Placeholder')),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                      'Damai Lagoon Resort\nTeluk Penyu Santubong, Kuching 93762 Malaysia'),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List<Widget>.generate(
                        4,
                            (index) => Image.network(
                            'folder/damaii.jpeg'
                            'folder/damai.jpeg'
                            'folder/damaiii.jpeg')),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('See all +20 photos'),
                  ),
                  const SizedBox(height: 20),
                  const Text('Reviews',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const ReviewTile(),
                  const SizedBox(height: 20),
                  const ReviewAndFAQSection(),
                  const SizedBox(height: 80),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IncludedItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const IncludedItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mak Limah',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('16 Dec 2021', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Icon(Icons.star_half, color: Colors.orange, size: 16),
                    Icon(Icons.star_border, color: Colors.orange, size: 16),
                  ],
                ),
                SizedBox(height: 4),
                Text('Good Place',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Okay okay je price not bad'),
                SizedBox(height: 4),
                Text('Visited date: Dec 2021',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ReviewAndFAQSection extends StatelessWidget {
  const ReviewAndFAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('See all +97 reviews'),
          ),
        ),
        const SizedBox(height: 20),
        const Text('People frequently ask',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildFAQItem('About this place'),
        _buildFAQItem('Term and condition'),
        _buildFAQItem('Cancellation Policy'),
      ],
    );
  }

  Widget _buildFAQItem(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: const Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. A id diam nisl, non justo, in odio...',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : Colors.black,
        ),
        onPressed: () {
          setState(() {
            isLiked = !isLiked;
          });
        },
      ),
    );
  }
}
