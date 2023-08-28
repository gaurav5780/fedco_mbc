import 'package:fedco_mbc/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/user_services.dart';
import '../models/user.dart';

// As the user has now seen / skipped the intro,
// change value of hasSeenIntro to true in SharedPreferences and database:
notifyPrefDatabase(User user) async {
  if (!user.hasSeenIntro) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(AppConstants.sharedPrefHasSeenIntro, true);
    user.hasSeenIntro = true;
    putUserByID(user, user.id);
  }
}

class BillStatistics {
  BillStatistics(this.attribute, this.value);
  final String attribute;
  final int value;
}
