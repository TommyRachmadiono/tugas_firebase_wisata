import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tugas_firebase_wisata/pages/home/home_screen.dart';
import 'package:tugas_firebase_wisata/services/firebase_service.dart';
import 'package:tugas_firebase_wisata/services/shared_preference_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = false;
  FirebaseService _firebaseService = FirebaseService();
  SharedPrefService _sharedPrefService = SharedPrefService();

  Future<void> checkLogin() async {
    final result = await _sharedPrefService.isLogin();
    setState(() {
      isLogin = result;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? HomeScreen()
        : Scaffold(
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
                  SignInButton(
                    Buttons.Google,
                    onPressed: () {
                      _firebaseService.handleGoogleSignIn().then((result) {
                        if (result != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                      });
                    },
                    elevation: 5,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ],
              ),
            ),
          );
  }
}
