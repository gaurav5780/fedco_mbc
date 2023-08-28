import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User?>? getLoginDetails() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  User? newUser;
  if (preferences.getBool(AppConstants.sharedPrefIsLoggedIn) != null) {
    if (preferences.getBool(AppConstants.sharedPrefIsLoggedIn) == true) {
      newUser = User(
          id: preferences.getInt(AppConstants.sharedPrefUserID)!,
          area: preferences.getInt(AppConstants.sharedPrefUserAreaID)!,
          isUserLoggedIn:
              preferences.getBool(AppConstants.sharedPrefIsLoggedIn)!,
          hasSeenIntro:
              preferences.getBool(AppConstants.sharedPrefHasSeenIntro)!,
          userName: preferences.getString(AppConstants.sharedPrefUserName)!,
          userAvatar: preferences.getString(AppConstants.sharedPrefUserAvatar)!,
          userEmail: preferences.getString(AppConstants.sharedPrefEmail)!,
          userPass: preferences.getString(AppConstants.sharedPrefPass)!,
          userBio: preferences.getString(AppConstants.sharedPrefUserBio)!,
          phoneNumber: preferences.getString(AppConstants.sharedPrefPhone)!,
          deviceIdentifier:
              preferences.getString(AppConstants.sharedPrefDevice)!,
          userLevel: preferences.getInt(AppConstants.sharedPrefUserLevel)!,
          userReportsTo:
              preferences.getInt(AppConstants.sharedPrefUserReportsTo)!,
          userIncentiveScore:
              preferences.getInt(AppConstants.sharedPrefUserIncentiveScore)!);
    }
  }
  return newUser;
}

Future<int?> getLoginID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int? id;
  if (preferences.getBool(AppConstants.sharedPrefIsLoggedIn) != null) {
    if (preferences.getBool(AppConstants.sharedPrefIsLoggedIn) == true) {
      id = preferences.getInt(AppConstants.sharedPrefUserID)!;
    }
  }
  return id;
}
