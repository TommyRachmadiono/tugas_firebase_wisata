import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugas_firebase_wisata/pages/auth/login_screen.dart';
import 'package:tugas_firebase_wisata/services/firebase_service.dart';

class MyDrawer extends StatelessWidget {
  final User currentUser;
  final FirebaseService _firebaseService = FirebaseService();

  MyDrawer({this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.lightBlue,
                Colors.blueAccent,
              ]),
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      currentUser.photoURL,
                    ),
                  ),
                  Text(
                    currentUser.displayName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    currentUser.email,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('SIGN OUT'),
            onTap: () async {
              await _firebaseService.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
