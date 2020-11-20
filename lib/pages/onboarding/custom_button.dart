import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final PageController pageController;
  CustomButton({this.text, this.pageController});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue,
      onPressed: () {
        text == 'Previous'
            ? pageController.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              )
            : pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
