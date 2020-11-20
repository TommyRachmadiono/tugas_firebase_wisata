import 'package:flutter/material.dart';
import 'package:tugas_firebase_wisata/pages/onboarding/button_continue.dart';
import 'package:tugas_firebase_wisata/pages/onboarding/custom_button.dart';
import 'package:tugas_firebase_wisata/pages/onboarding/dot_indicator.dart';
import 'package:tugas_firebase_wisata/pages/onboarding/slider.dart';
import 'package:tugas_firebase_wisata/services/shared_preference_service.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var currentIndexPage = 0;
  PageController pageController = PageController();

  List onBoardingData = [
    {
      "text": "Let's go holiday",
      "image": "assets/img/splash.png",
    },
    {
      "text": "Let's have some fun",
      "image": "assets/img/splash.png",
    },
    {
      "text": "Let's hang out together",
      "image": "assets/img/splash.png",
    },
  ];

  Future<void> saveDatapref() async {
    SharedPrefService pref = SharedPrefService();
    pref.saveDataPref(dataType: 'bool', key: 'alreadyView', value: true);
  }

  @override
  void initState() {
    super.initState();
    saveDatapref();
    pageController = PageController(initialPage: currentIndexPage);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(
                itemCount: onBoardingData.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: Duration(seconds: 1),
                    child: SliderOnboarding(
                      text: onBoardingData[index]['text'],
                      img: onBoardingData[index]['image'],
                    ),
                  );
                },
                controller: pageController,
                physics: ClampingScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    currentIndexPage = value;
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: Column(
                  children: [
                    MyDotIndicator(
                      currentIndexPage: currentIndexPage,
                      onBoardingDataLength: onBoardingData.length,
                    ),
                    Spacer(),
                    currentIndexPage == onBoardingData.length - 1
                        ? ButtonContinue()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                text: 'Previous',
                                pageController: pageController,
                              ),
                              CustomButton(
                                text: 'Next',
                                pageController: pageController,
                              ),
                            ],
                          ),
                    Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
