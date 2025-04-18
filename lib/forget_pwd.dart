import 'package:flutter/material.dart';

void main() {
  runApp(const ExploreToday());
}

class ExploreToday extends StatelessWidget {
  const ExploreToday({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Today',
      debugShowCheckedModeBanner: false,
      home: const ExploreTodayScreen(),
    );
  }
}

class ExploreTodayScreen extends StatelessWidget {
  const ExploreTodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Bookings"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), label: "Notification"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background Image + Header
            Stack(
              children: [
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/trombol.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60), // Moves text below status bar
                      const Text(
                        "Explore today",
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Paradise • take your relaxation to next level",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 20),
                      // Search Bar
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search destination",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Icon(Icons.search),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Category buttons
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            buildCategoryButton(Icons.hotel, "Accomodations"),
                            buildCategoryButton(Icons.flight, "Attractions"),
                            buildCategoryButton(Icons.directions, "Travelling"),
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
              child: Text("Popular Activities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            buildHorizontalList([
              buildCard("assets/ATV.png", "Riding ATV", "100 reviews"),
              buildCard("assets/beach_volleyball.jpeg", "Beach Volleyball", "87 reviews"),
            ]),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Food & Refreshments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            buildHorizontalList([
              buildCard("assets/oden.png", "Oden", "Nice street food"),
              buildCard("assets/air_balang.jpeg", "Air Balang", "Refreshment"),
            ]),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text("Travel beyond the boundary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            buildHorizontalList([
              buildCard("assets/monkey.png", "Bako National Park", "100 reviews"),
              buildCard("assets/borneo_jungle.jpeg", "Borneo Jungle", "RM50.00+"),
            ]),
          ],
        ),
      ),
    );
  }

  static Widget buildCategoryButton(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  static Widget buildHorizontalList(List<Widget> items) {
    return SizedBox(
      height: 230,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: items
            .map((item) => Padding(
          padding: const EdgeInsets.only(right: 15),
          child: item,
        ))
            .toList(),
      ),
    );
  }

  static Widget buildCard(String image, String title, String subtitle) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
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
                    topRight: Radius.circular(12)),
                child: Image.asset(image,
                    height: 100, width: 160, fit: BoxFit.cover),
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
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    Icon(Icons.star_border, size: 14, color: Colors.orange),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
