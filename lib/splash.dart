import 'package:dairytenantapp/feature/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height, // 🔹 Force full height
            child: Column(
              children: [
                // 🔹 Top Section - Barn + Cows Illustration
                Column(
                  children: [
                    const SizedBox(height: 20), // Top padding
                    SizedBox(
                      width: double.infinity,
                      height: 310,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SvgPicture.asset(
                            'assets/images/splashone.svg',
                            width: double.infinity,
                            height: 230,
                            fit: BoxFit.fitWidth,
                          ),
                          Positioned(
                            top: 160, // controls the overlap
                            child: SvgPicture.asset(
                              'assets/images/splashtwo.svg',
                              width: MediaQuery.of(context).size.width,
                              height: 140,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 🔹 Middle Section - Logo + Title
                Transform.translate(
                  offset: const Offset(0, 10), // move block up slightly
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/Layer.svg',
                        width: 122,
                        height: 121,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 253,
                        child: const Text(
                          "Dairy Collections\nMade Easier",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            height: 1.0,
                            letterSpacing: 0.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(), // 🔹 pushes button down
                // 🔹 Bottom Section - Circular Arrow Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          'assets/images/button.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
