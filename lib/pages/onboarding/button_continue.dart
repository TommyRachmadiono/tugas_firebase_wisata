import 'package:flutter/material.dart';
import 'package:tugas_firebase_wisata/pages/auth/login_screen.dart';

class ButtonContinue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.blue,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        child: Text(
          "Let's Go",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
