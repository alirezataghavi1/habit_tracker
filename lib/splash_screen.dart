import 'package:final_habit/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F5F8),
      body: Stack(
        children: [
          Positioned.fill(
              child:Image.asset("assets/images/splash/splash.png",fit: BoxFit.cover,)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Center(
                  child: Image.asset(
                "assets/images/splash/splashIcon.png",
                height: 400,
                width: 400,
              )),
              Text(
                'Remember Why You Started...',
                style: TextStyle(
                    fontFamily: 'Roboto', color: Colors.black, fontSize: 18),
              )
            ],
          ),
        ],
      ),
    );
  }
}
