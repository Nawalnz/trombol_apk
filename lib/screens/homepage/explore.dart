import "package:flutter/material.dart";
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
  int _currentIndex = 0; // track bottom nav index

  final List<Widget> _pages = [
    const ExploreTodayContent(),  // Home content
    const BookingsPage(),         // Booking content
    NotificationPage(),     // Notification content
    const ProfilePage(),          // Profile content
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // update current page
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

// --- Separate Home page content into widget ---
class ExploreTodayContent extends StatelessWidget {
  const ExploreTodayContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with background image
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
                      // Search Bar
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
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCategoryButton(context, Icons.hotel, "Accommodations"),
                            _buildCategoryButton(context, Icons.flight, "Attractions"),
                            _buildCategoryButton(context, Icons.directions, "Travelling"),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Popular Activities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildHorizontalList([
              _buildCard("assets/images/atv.png", "Riding ATV", "100 reviews"),
              _buildCard("assets/images/beach_volleyball.jpeg", "Beach Volleyball", "87 reviews"),
            ]),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Food & Refreshments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildHorizontalList([
              _buildCard("assets/images/oden.png", "Oden", "Nice street food"),
              _buildCard("assets/images/air_balang.jpeg", "Air Balang", "Refreshment"),
            ]),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Travel beyond the boundary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildHorizontalList([
              _buildCard("assets/images/monkey.png", "Bako National Park", "100 reviews"),
              _buildCard("assets/images/borneo_jungle.jpeg", "Borneo Jungle", "RM50.00+"),
            ]),
          ],
        ),
      ),
    );
  }

  static Widget _buildCategoryButton(BuildContext context,IconData icon, String label) {
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
          Icon(
            icon, size: 16,
            color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black, ),
          const SizedBox(width: 6),
          Text(
              label,
              style: TextStyle(fontSize: 14, color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black)
          ),
        ],
      ),
    );
  }

  static Widget _buildHorizontalList(List<Widget> items) {
    return SizedBox(
      height: 230,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(right: 15),
          child: item,
        )).toList(),
      ),
    );
  }

  static Widget _buildCard(String image, String title, String subtitle) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
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
                child: Image.asset(image, height: 100, width: 160, fit: BoxFit.cover),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, size: 16),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                    )
                ),
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
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
