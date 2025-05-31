import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/contactus.dart';
import 'package:trombol_apk/screens/homepage/explore.dart';
import 'package:trombol_apk/screens/login/login_user.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    Center(child: Text('Page 1', style: TextStyle(fontSize: 24, color: Colors.transparent))),
    Center(child: Text('Page 2', style: TextStyle(fontSize: 24, color: Colors.transparent))),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
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
                    Scaffold.of(context).openEndDrawer();
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
                // SizedBox(height: 20),
                // ListTile(
                //   leading: Icon(Icons.travel_explore, size: 30.0),
                //   title: Text('Explore Beach', style: TextStyle(fontSize: 20.0)),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
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
                children: [
                  Expanded(
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
                Spacer(),

                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white, // Change to your desired color and opacity
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      'assets/images/Logo.png',
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 32), // Optional: space from the bottom

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    // child: ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => const ExploreToday()),
                    //     );
                    //   },
                    //
                    // //   style: ElevatedButton.styleFrom(
                    // //     backgroundColor: Color(0xFF085373),
                    // //     shape: RoundedRectangleBorder(
                    // //       borderRadius: BorderRadius.circular(12),
                    // //     ),
                    // //   ),
                    // //   child: Text('Explore Beach', style: TextStyle(fontSize: 18, color: Colors.white)),
                    // ),
                  ),
                  // SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginUser()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF085373),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Log In', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Rectangle page slider at the very bottom
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
                ]),
            ),
          ))));
  }
}
