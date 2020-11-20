import 'package:flutter/material.dart';

class SliderOnboarding extends StatelessWidget {
  final String img;
  final String text;

  SliderOnboarding({this.img, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Spacer(),
                Text(
                  'HOLIDAY',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(text),
                Spacer(),
                Image.asset(
                  img,
                  height: 300,
                  width: 300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
