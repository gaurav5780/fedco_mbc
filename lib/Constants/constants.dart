// Define all the constants used in the app here
import 'package:flutter/material.dart';

class AppConstants {
  static const String appTitle = 'DAPP';

  // Constants for Splash Screen:

  static const int splashScreenDuration = 3;
  static const Color splashScreenFontColor = Colors.white;
  static const Color navDrawerFontColor = Colors.white;
  static const Color widgetBorderColor = Colors.white38;
  static const double defaultIncentive = 50;
  static const double paddingLarge = 16;
  static const double paddingSmall = 8;
  static const double marginLarge = 16;
  static const double marginSmall = 8;
  static const double spaceLarge = 16;
  static const double spaceSmall = 8;
  static const double cardRadius = 20;
  static const double imageRadiusXXL = 70;
  static const double imageRadiusLarge = 32;
  static const double imageRadiusMedium = 24;
  static const double imageRadiusSmall = 18;
  static const double xlFont = 24;
  static const double largeFont = 20;
  static const double mediumFont = 16;
  static const double smallFont = 12;

  // Constants for shared preferences keys:

  static const String sharedPrefUserID = 'userID';
  static const String sharedPrefUserAreaID = 'userAreaID';
  static const String sharedPrefIsLoggedIn = 'isUserLoggedIn';
  static const String sharedPrefHasSeenIntro = 'hasSeenIntro';
  static const String sharedPrefUserName = 'userName';
  static const String sharedPrefUserAvatar = 'userAvatar';
  static const String sharedPrefEmail = 'userEmail';
  static const String sharedPrefPass = 'userPass';
  static const String sharedPrefUserLevel = 'userLevel';
  static const String sharedPrefUserReportsTo = 'reportsTo';
  static const String sharedPrefUserIncentiveScore = 'userIncentiveScore';
  static String sharedPrefUserBio = 'userBio';
  static String sharedPrefPhone = 'userPhone';
  static String sharedPrefDevice = 'userDevice';
}

verticalSpacing(double spacing) {
  return SizedBox(
    height: spacing,
  );
}

horizontalSpacing(double spacing) {
  return SizedBox(
    width: spacing,
  );
}

class DashboardConstants {
  static const String dashboardTitle = "Dashboard";
  static const Color navHeaderColor = Colors.blueAccent;
  static const int billedOnActualReading = 1;
  static const int readingInaccuracies = 2;
  static const int noMeter = 3;
  static const int stoppedMeter = 4;
}

// Define the constants to be used in walkthrough (intro screen)
class WalkthroughConstants {
  static const Color walkthroughGlobalColor = Colors.blueAccent;
  // For the first page of intro screen
  static const String title1 = "Correct Metering";
  static const String content1 =
      "Predict loss due to defective and inaccurate meters";
  static Image image1 = Image.asset('assets/meter.png');

  // For the second page of intro screen
  static const String title2 = "Accurate billing";
  static const String content2 =
      "Prevent innaccurate bills and ensure customer satisfaction";
  static Image image2 = Image.asset('assets/accuracy.png');

  // For the third page of intro screen
  static const String title3 = "Get recommendations";
  static const String content3 = "ML based models help you to perform better";
  static Image image3 = Image.asset('assets/recommendations.png');

  // For the fourth page of intro screen
  static const String title4 = "Plan your actions";
  static const String content4 =
      "Calendar integration helps you and your team to plan their actions better";
  static Image image4 = Image.asset('assets/plan.png');

  // For the fifth page of intro screen
  static const String title5 = "Enjoy incentives";
  static const String content5 =
      "Get points based on your actions and see your performance vis-a-vis your peers";
  static Image image5 = Image.asset('assets/incentive.png');

  // Strings for walkthrough buttons
  static const String skip = "Skip";
  static const String next = "Next";
  static const String gotIt = "Got it!";
}

//TODO: Change server URLs during deployment:

class androidUriConstants {
  static const String areaURL = 'http://10.0.2.2:9000/area';
  static const String userURL = 'http://10.0.2.2:9000/user';
  static const String billingPerformanceURL =
      'http://10.0.2.2:9000/billingperformance';
  static const String specificBillingURL =
      'http://10.0.2.2:9000/specificbilling';

  static const String billingRecommendationURL =
      'http://10.0.2.2:9000/billingrecommendation';
  static const String billingTaskURL = 'http://10.0.2.2:9000/billingtask';
  static const String billingAssignmentURL =
      'http://10.0.2.2:9000/billingassignment';
  static const String billingUpdateURL = 'http://10.0.2.2:9000/billingupdate';
}

class iOSUriConstants {
  static const String areaURL = 'http://localhost:9000/area';
  static const String userURL = 'http://localhost:9000/user';
  static const String billingPerformanceURL =
      'http://localhost:9000/billingperformance';
  static const String specificBillingURL =
      'http://localhost:9000/specificbilling';

  static const String billingRecommendationURL =
      'http://localhost:9000/billingrecommendation';
  static const String billingTaskURL = 'http://localhost:9000/billingtask';
  static const String billingAssignmentURL =
      'http://localhost:9000/billingassignment';
  static const String billingUpdateURL = 'http://localhost:9000/billingupdate';
}
