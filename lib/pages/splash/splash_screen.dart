import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tugas_firebase_wisata/pages/auth/login_screen.dart';
import 'package:tugas_firebase_wisata/pages/onboarding/onboarding_screen.dart';
import 'package:tugas_firebase_wisata/services/shared_preference_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPrefService sharedPref = SharedPrefService();
  Widget page;

  void checkAlreadyView() async {
    page = await sharedPref.alreadyViewOnboarding() == false
        ? OnboardingScreen()
        : LoginScreen();
  }

  void startTimer() async {
    var second = Duration(seconds: 5);
    Timer(second, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    checkAlreadyView();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/splash.png',
              width: 300,
              height: 300,
            ),
            Text(
              'Flutter Firebase Wisata',
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
