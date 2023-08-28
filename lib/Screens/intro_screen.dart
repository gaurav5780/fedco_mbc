import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Services/user_services.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  final User currentUser;
  const IntroScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 20),
      pageColor: Colors.blueAccent,
      imagePadding: EdgeInsets.all(30),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: IntroductionScreen(
              globalBackgroundColor:
                  WalkthroughConstants.walkthroughGlobalColor,
              dotsDecorator: const DotsDecorator(color: Colors.white),
              onSkip: () => navigate(),
              onDone: () => navigate(),
              skip: const Text(WalkthroughConstants.skip,
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.white)),
              showSkipButton: true,
              next: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              done: const Text(WalkthroughConstants.gotIt,
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.white)),
              curve: Curves.fastLinearToSlowEaseIn,
              controlsMargin: const EdgeInsets.all(8),
              pages: [
                PageViewModel(
                  title: WalkthroughConstants.title1,
                  body: WalkthroughConstants.content1,
                  image: WalkthroughConstants.image1,
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: WalkthroughConstants.title2,
                  body: WalkthroughConstants.content2,
                  image: WalkthroughConstants.image2,
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: WalkthroughConstants.title3,
                  body: WalkthroughConstants.content3,
                  image: WalkthroughConstants.image3,
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: WalkthroughConstants.title4,
                  body: WalkthroughConstants.content4,
                  image: WalkthroughConstants.image4,
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: WalkthroughConstants.title5,
                  body: WalkthroughConstants.content5,
                  image: WalkthroughConstants.image5,
                  decoration: pageDecoration,
                ),
              ]),
        ),
      ),
    );
  }

  navigate() {
    User user = widget.currentUser;
    user.hasSeenIntro = true;
    putUserByID(user, user.id);
    PageNavigator.navigateBasedOnUserLevel(context, widget.currentUser);
  }
}
