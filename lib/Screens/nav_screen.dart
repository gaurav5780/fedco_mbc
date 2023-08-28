import 'dart:async';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Utilities/helper_methods.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:fedco_mbc/Services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  bool isLoggedIn = false;
  bool hasSeenIntro = false;
  bool isComplete = false;
  Future<User>? futureUser;
  User? newUser;
  Future<int?>? futureID;
  int userID = 0;

  @override
  void initState() {
    futureID = getLoginID();
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
          //child: makeNavScreen(),
          child: (isComplete) ? makeFutureBuilder() : navigate(),
        ),
      ),
    );
  }

  makeFutureBuilder() {
    return FutureBuilder(
        future: futureID,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            userID = snapshot.data as int;
            debugPrint('makeFutureBuilder: ${snapshot.data}');
            futureUser = getUserByID(userID);
            return getUserFromDB();
          } else if (snapshot.hasError) {
            debugPrint('makeFutureBuilder: ${snapshot.error}');
            return navigate();
          } else {
            debugPrint('makeFutureBuilder: Waiting....');
            return LoaderTransparent();
          }
        }));
  }

  getUserFromDB() async {
    return FutureBuilder(
      future: futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          newUser = snapshot.data as User;
          debugPrint('getUserFromDB: ${snapshot.data}');

          isLoggedIn = true;
          hasSeenIntro = newUser!.hasSeenIntro;
          isComplete = true;
          return navigate();
        } else if (snapshot.hasError) {
          debugPrint('getUserFromDB: ${snapshot.error}');
          return navigate();
        } else {
          debugPrint('getUserFromDB: Waiting....');
          return LoaderTransparent();
        }
      },
    );
  }

  navigate() {
    debugPrint('Navigate******');
    Future.delayed(const Duration(seconds: 2), () {
      if (!isLoggedIn) {
        //Navigator.pop(context);
        PageNavigator.goToLoginScreen(context);
      } else {
        if (hasSeenIntro) {
          //Navigator.pop(context);
          PageNavigator.navigateBasedOnUserLevel(context, newUser!);
        } else {
          //Navigator.pop(context);
          PageNavigator.goToIntroScreen(context, newUser!);
        }
      }
      debugPrint("Nav Build Completed");
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // do something
    //   if (!isLoggedIn) {
    //     //Navigator.pop(context);
    //     PageNavigator.goToLoginScreen(context);
    //   } else {
    //     if (hasSeenIntro) {
    //       //Navigator.pop(context);
    //       PageNavigator.navigateBasedOnUserLevel(context, newUser!);
    //     } else {
    //       //Navigator.pop(context);
    //       PageNavigator.goToIntroScreen(context, newUser!);
    //     }
    //   }
    //   debugPrint("Nav Build Completed");
    // });
  }
}
