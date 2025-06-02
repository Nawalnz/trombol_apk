import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trombol_apk/screens/bookplace/tour_detail.dart';
import 'package:trombol_apk/screens/homepage/search.dart';
import 'package:trombol_apk/screens/navbar_button/booking/booked_list.dart';
import 'package:trombol_apk/screens/navbar_button/notification/notification.dart';
import 'package:trombol_apk/screens/navbar_button/profile/profile.dart';

class ExploreToday extends StatefulWidget {
  const ExploreToday({super.key});

  @override
  State<ExploreToday> createState() => _ExploreTodayScreenState();
}

class _ExploreTodayScreenState extends State<ExploreToday> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ExploreTodayContent(),
    const BookingsPage(),
    NotificationPage(),
    const ProfilePage(),
  ];


  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notification"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class ExploreTodayContent extends StatefulWidget {
  const ExploreTodayContent({super.key});

  @override
  State<ExploreTodayContent> createState() => _ExploreTodayContentState();
}

class _ExploreTodayContentState extends State<ExploreTodayContent> {
  Set<String> likedProductIds = {};

  @override
  void initState() {
    super.initState();
    _loadLikedProducts();
  }

  Future<void> _loadLikedProducts() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final liked = List<String>.from(doc.data()?['likedProducts'] ?? []);
    setState(() => likedProductIds = liked.toSet());
  }

  Future<void> _toggleLike(String productId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);

    setState(() {
      if (likedProductIds.contains(productId)) {
        likedProductIds.remove(productId);
      } else {
        likedProductIds.add(productId);
      }
    });

    final isLiked = likedProductIds.contains(productId);
    await ref.update({
      'likedProducts': isLiked
          ? FieldValue.arrayUnion([productId])
          : FieldValue.arrayRemove([productId]),
    });
  }

  Widget _buildCategoryButton(BuildContext context, IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withAlpha(102)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 14, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildCard(String image, String title, String subtitle, String productId) {
    final isLiked = likedProductIds.contains(productId);
    return Container(
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
                const Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    Icon(Icons.star_border, size: 14, color: Colors.orange),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle.length > 40 ? '${subtitle.substring(0, 40)}...' : subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('type', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 230,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("No items available in this category"),
          );
        }

        return SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12), // <-- spacing between items
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final image = (data['image'] as List?)?.cast<String>().firstOrNull ?? '';
              final title = data['name'] ?? 'Unnamed';
              final desc = data['description'] ?? 'No description';
              final productId = docs[index].id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TourDetailPage(tourData: {
                        'id': productId,
                        'name': data['name'],
                        'description': data['description'],
                        'price': data['price'],
                        'image': data['image'],
                      }),
                    ),
                  );
                },
                child: _buildCard(image, title, desc, productId),
              );
            },
          ),

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/trombol.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        "Explore today",
                        style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Paradise • take your relaxation to next level",
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SearchScreen()),
                          );
                        },
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: IgnorePointer(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Where do you plan to go?",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(Icons.search),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // SizedBox(
                      //   height: 40,
                      //   child: ListView(
                      //     scrollDirection: Axis.horizontal,
                      //     children: [
                      //       _buildCategoryButton(context, Icons.hotel, "Accommodations"),
                      //       _buildCategoryButton(context, Icons.directions_boat, "Activities"),
                      //       _buildCategoryButton(context, Icons.energy_savings_leaf, "Nature"),
                      //       _buildCategoryButton(context, Icons.local_drink, "Relaxation"),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Accommodations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildProductList('accommodation'),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Activities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildProductList('activity'),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Nature", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildProductList('nature'),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Relaxation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildProductList('relaxation'),
          ],
        ),
      ),
    );
  }
}