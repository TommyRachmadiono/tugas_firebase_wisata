import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class MyDotIndicator extends StatelessWidget {
  final int onBoardingDataLength;
  final int currentIndexPage;

  MyDotIndicator({this.onBoardingDataLength, this.currentIndexPage});

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: onBoardingDataLength,
      position: currentIndexPage.toDouble(),
      decorator: DotsDecorator(
        size: Size.square(9.0),
        activeSize: Size(18.0, 9.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }
}
