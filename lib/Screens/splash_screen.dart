import 'dart:async';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            //child: makeSplashScreen(),
            child: makeSplashScreen()),
      ),
    );
  }

  makeSplashScreen() {
    Future.delayed(const Duration(seconds: AppConstants.splashScreenDuration),
        () {
      Navigator.pop(context);
      PageNavigator.goToNavScreen(context);
    });
    return Container(
      color: Theme.of(context).colorScheme.primary,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/dapp-splash.png',
            height: 250,
            width: 250,
            fit: BoxFit.scaleDown,
          ),
          verticalSpacing(AppConstants.marginLarge),
          Text(
            'Loading ...',
            style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: AppConstants.largeFont,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
