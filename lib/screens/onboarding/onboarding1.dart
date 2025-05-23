import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/contactus.dart';
import 'package:trombol_apk/screens/onboarding/onboarding2.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Onboarding1(),
  ));
}

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    Center(child: Text('First onboarding page', style: TextStyle(fontSize: 24, color: Colors.transparent))),
    Center(child: Text('Second onboarding page', style: TextStyle(fontSize: 24, color: Colors.transparent))),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/SplashBackground.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment(0.25, 0.0),
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(''),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.animateToPage(
                      _currentPage + 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                },

              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Image.asset(
                        'assets/images/Logo.png',
                        width: 250,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.travel_explore, size: 30.0),
                title: Text('Explore Beach', style: TextStyle(fontSize: 20.0)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.connect_without_contact_rounded, size: 30.0),
                title: Text('Contact Us', style: TextStyle(fontSize: 20.0)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUs()),
                  );
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Spacer(),

                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcATop,
                  ),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 22),

                // Card with onboarding content and Next button
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome to Trombol Paradise Beach!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Trombol Paradise Beach situated in the South China Sea and ranks the 4th among 27 beaches of the Sarawak region.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          height: 22,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            children: _pages,
                          ),
                        ),
                        SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_currentPage < _pages.length - 1) {
                                _pageController.animateToPage(
                                  _currentPage + 1,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage()),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF085373),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _currentPage < _pages.length - 1 ? 'Next': 'Next',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Rectangular slider (page indicator)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      width: _currentPage == index ? 32 : 16,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Color(0xFF085373) : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}