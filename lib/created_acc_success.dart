import "package:flutter/material.dart";

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CreateAccountScreen()),
  );
}

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, -0.00),
          end: Alignment(0.50, 1.00),
          colors: [
            const Color(0xFF085374),
            const Color(0x75085374),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, //to show gradient
        body: Stack(
          children: [
            //Logo
            Positioned(
              left: 113,
              top: 160,
              child: Container(
                width: 111,
                height: 108,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/trombol_logo.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            // Welcome Box
            Positioned(
              left: 20,
              top: 269,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 372,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 295,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 295,
                                          child: Text(
                                            'Successfully',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 29,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              height: 1.38,
                                              letterSpacing: -0.17,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 295,
                                          child: Text(
                                            'Created an Account!',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              height: 1.60,
                                              letterSpacing: -0.17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 295,
                                      child: Text(
                                        'After this you can explore Trombol Paradise Beach!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withAlpha(204),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Uniform Gradient Bottom Navigation
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                //print("Let's Explore tapped");
              },
              child: const Text(
                "Let's Explore",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
