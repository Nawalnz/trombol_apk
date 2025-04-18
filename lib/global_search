import 'package:flutter/material.dart';

void main() {
  runApp(const GlobalSearch());
}

class GlobalSearch extends StatelessWidget {
  const GlobalSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const Scaffold(
        body: SafeArea(
          child: SearchGlobal(),
        ),
      ),
    );
  }
}

class SearchGlobal extends StatefulWidget {
  const SearchGlobal({super.key});

  @override
  State<SearchGlobal> createState() => _SearchGlobalState();
}

class _SearchGlobalState extends State<SearchGlobal> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchBar(),
            const SizedBox(height: 20),
            buildNearbySearchSection(),
            const SizedBox(height: 20),
            buildRecentlySearchSection(),
            const SizedBox(height: 20),
            buildRecommendedSection(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.black),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Where do you plan to go?',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNearbySearchSection() {
    return Row(
      children: const [
        Icon(Icons.location_on, color: Colors.black),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Search places nearby',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRecentlySearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Searches',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        buildSearchItem('Coconut smoothie'),
        buildSearchItem('Oden fishball'),
      ],
    );
  }

  Widget buildSearchItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.history, size: 20, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 266.78,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              buildRecommendedItem(
                "Niah National Park",
                "100 reviews",
                "Beautiful rainforest and caves.",
                "assets/niah.jpeg",
              ),
              const SizedBox(width: 15),
              buildRecommendedItem(
                "Riding ATV",
                "85 reviews",
                "Thrilling ride in muddy terrain.",
                "assets/ATV.png",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRecommendedItem(
      String title,
      String reviews,
      String description,
      String imageUrl,
      ) {
    return Container(
      width: 191.75,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.83, color: Colors.black),
          borderRadius: BorderRadius.circular(12.51),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.51),
                topRight: Radius.circular(12.51),
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(10),
                width: 30.01,
                height: 30.01,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: CircleBorder(),
                ),
                child: const Icon(Icons.favorite_border, size: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13.34,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reviews,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
