import 'package:flutter/material.dart';
import 'package:tugas_firebase_wisata/pages/form/form_screen.dart';

class MyFloatingButton extends StatefulWidget {
  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormScreen(),
          ),
        );
        setState(() {});
      },
      child: Icon(Icons.add_location_alt),
    );
  }
}
