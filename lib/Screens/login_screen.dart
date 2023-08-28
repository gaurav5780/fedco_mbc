import 'dart:async';

import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Utilities/helper_methods.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:fedco_mbc/Services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/page_navigator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Future<List<User>> userList;
  List<User> users = List.empty(growable: true);
  User? newUser;
  Future<int?>? userID;
  int? uid;
  bool loadingComplete = false;
  final _formKey = GlobalKey<FormState>();

  // Initialize all login presets to false:
  bool isLoggedIn = false;
  bool userEmailExists = false;
  bool userLoginSuccess = false;
  //Initialize the controllers:
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  double widthOfScreen = 0;
  double heightOfScreen = 0;
  // Initialize the user as Guest:
  @override
  void initState() {
    super.initState();
    userID = getLoginID();
    userList = getAllUsers();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions:
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: (loadingComplete) ? makeForm() : makeFutureBuilder(),
            ),
          ),
        ));
  }

  makeFutureBuilder() {
    return FutureBuilder(
        future: userList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            users = snapshot.data as List<User>;
            debugPrint('Length:${users.length}');
            debugPrint('1st Email:${users.first.userEmail}');
            return makeFutureUser();
          } else if (snapshot.hasError) {
            return Text('MakeFutureBuilder: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  makeForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widthOfScreen,
          child: Column(children: [
            Container(
              margin: const EdgeInsets.all(AppConstants.marginLarge),
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              ),
              width: widthOfScreen * 0.9,
              height: heightOfScreen * 0.88,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(children: [
                  verticalSpacing(AppConstants.marginLarge),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppConstants.cardRadius),
                    child: Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Image.asset(
                        'assets/dapp-splash.png',
                        height: 170,
                        width: 170,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  verticalSpacing(AppConstants.marginLarge),
                  verticalSpacing(AppConstants.marginLarge),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        makeEmailFormField(),
                        verticalSpacing(AppConstants.marginLarge),
                        verticalSpacing(AppConstants.marginLarge),
                        makePasswordFormField(),
                        verticalSpacing(AppConstants.marginLarge),
                        verticalSpacing(AppConstants.marginLarge),
                        SizedBox(
                          height: 50,
                          width: widthOfScreen * 0.8,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.cardRadius))),
                            onPressed: onPressed,
                            child: const Text(
                              'Login',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        )
      ],
    );
  }

  onPressed() {
    if (_formKey.currentState!.validate()) {
      // check if user is successfully logged in -
      if (userLoginSuccess) {
        storeLoginDetails(newUser!);
        isLoggedIn = true;
        // Go to Intro Screen based on value of hasSeenIntro
        Future.delayed(Duration.zero, () {
          if (newUser!.hasSeenIntro) {
            PageNavigator.navigateBasedOnUserLevel(context, newUser!);
          } else {
            PageNavigator.goToIntroScreen(context, newUser!);
          }
        });
      } else {
        return Fluttertoast.showToast(msg: 'Login error');
      }
    } else {
      return Fluttertoast.showToast(msg: 'Validation error');
    }
  }

  storeLoginDetails(User newUser) async {
    // Store login info in shared preferences:

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setInt(AppConstants.sharedPrefUserID, newUser.id);
    sharedPreferences.setInt(AppConstants.sharedPrefUserAreaID, newUser.area);
    sharedPreferences.setBool(AppConstants.sharedPrefIsLoggedIn, true);
    sharedPreferences.setBool(AppConstants.sharedPrefHasSeenIntro, false);
    sharedPreferences.setString(
        AppConstants.sharedPrefUserName, newUser.userPass);
    sharedPreferences.setString(
        AppConstants.sharedPrefUserAvatar, newUser.userAvatar);
    sharedPreferences.setString(
        AppConstants.sharedPrefEmail, newUser.userEmail);
    sharedPreferences.setString(AppConstants.sharedPrefPass, newUser.userPass);
    sharedPreferences.setString(
        AppConstants.sharedPrefUserBio, newUser.userBio);
    sharedPreferences.setString(
        AppConstants.sharedPrefPhone, newUser.phoneNumber);
    sharedPreferences.setString(
        AppConstants.sharedPrefDevice, newUser.deviceIdentifier);
    sharedPreferences.setInt(
        AppConstants.sharedPrefUserLevel, newUser.userLevel);
    sharedPreferences.setInt(
        AppConstants.sharedPrefUserReportsTo, newUser.userReportsTo);
    sharedPreferences.setInt(
        AppConstants.sharedPrefUserIncentiveScore, newUser.userIncentiveScore);
    // Change the value of IsLoggedIn in the database
    newUser.isUserLoggedIn = true;
    putUserByID(newUser, newUser.id);
  }

  makeEmailFormField() {
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        labelText: 'Email ID',
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      controller: emailController,
      validator: (value) {
        if ((emailController.text == '')) {
          return 'Please enter email ID';
        } else if (!value!.contains('@')) {
          return 'Please enter valid email ID';
        } else {
          for (int i = 0; i < users.length; i++) {
            debugPrint(users[i].userEmail);
            if (users[i].userEmail == emailController.text) {
              userEmailExists = true;
              newUser = users[i];
              debugPrint(newUser!.userEmail.toString());
            }
          }
          if (!userEmailExists) {
            return 'This email ID does not exist in the system, \n please get in touch with Admin';
          } else {
            return null;
          }
        }
      },
    );
  }

  makeFutureUser() {
    return FutureBuilder(
      future: userID,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('Snapshot has data:${snapshot.data}');
          uid = snapshot.data as int;
          if (uid != null) {
            for (var i = 0; i < users.length; i++) {
              if (users[i].id == uid) {
                newUser = users[i];
                // Go to Intro Screen based on value of hasSeenIntro
                Future.delayed(Duration.zero, () {
                  if (newUser!.hasSeenIntro) {
                    PageNavigator.navigateBasedOnUserLevel(context, newUser!);
                  } else {
                    PageNavigator.goToIntroScreen(context, newUser!);
                  }
                });
              }
            }
            return Container();
          } else {
            loadingComplete = true;
            debugPrint('uid is null');
            return makeForm();
          }
        } else if (snapshot.hasError) {
          debugPrint('Snapshot has Error : ${snapshot.error}');
          loadingComplete = true;
          return makeForm();
        } else {
          debugPrint('Waiting for login id');
          LoaderTransparent();
          Future.delayed(Duration(seconds: 2), () {
            loadingComplete = true;
            debugPrint('2 secs done');
            return makeForm();
          });
          return makeForm();
        }
      },
    );
  }

  makePasswordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius:
              const BorderRadius.all(Radius.circular(AppConstants.cardRadius)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      controller: passwordController,
      validator: (value) {
        if ((value == null) || (value.isEmpty)) {
          return 'Please enter password';
        } else if (newUser?.userPass == value) {
          userLoginSuccess = true;
          return null;
        } else {
          return 'Please enter correct password';
        }
      },
    );
  }
}
