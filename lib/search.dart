import 'package:flutter/material.dart';

void main() {
  runApp(const SearchScreen());
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: TourList(),
          ),
        ),
      ),
    );
  }
}

class TourList extends StatelessWidget {
  const TourList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSearchHeader(),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Text(
              'Place name "Kuching"',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          buildTourCard(
            'Borneo Happy Farm',
            '100 reviews',
            'Kuching, Sarawak',
            'from RM30+',
            '/person',
            '1 day',
            'assets/borneo_happy_farm.png',
            screenWidth,
          ),
          divider(),

          buildTourCard(
            '2 day 1 night Kuching Tour',
            '100 reviews',
            'Kuching, Sarawak',
            'from RM350',
            '/person',
            '2 day 1 night',
            'assets/kch_waterfront.png',
            screenWidth,
          ),
          divider(),

          buildTourCard(
            '1-Day Cultural Museum Tour',
            '100 reviews',
            'Kuching, Sarawak',
            'from RM20+',
            '/person',
            '1 day',
            'assets/cultural_museum.png',
            screenWidth,
          ),
          divider(),

          Padding(
            padding: const EdgeInsets.only(left: 24, top: 15, bottom: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Show +15 more available',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() => Container(
    width: double.infinity,
    height: 1,
    color: Colors.black,
  );

  Widget buildSearchHeader() {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              // Handle back action
            },
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Kuching',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 2,
                        height: 14,
                        color: const Color(0xFF4D9FEA),
                      ),
                    ],
                  ),
                  const Icon(Icons.search, size: 16, color: Colors.black),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(
                Icons.drag_indicator, color: Colors.black),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
      ),
    );
  }

  Widget buildTourCard(
      String title,
      String reviews,
      String location,
      String price,
      String priceSuffix,
      String duration,
      String imagePath,
      double screenWidth,
      ) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tour image
          Container(
            width: 122,
            height: 122,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),

          // Tour details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                // Star icons + reviews
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const Icon(Icons.star_border, size: 14, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text(
                      reviews,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: priceSuffix,
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
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
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
