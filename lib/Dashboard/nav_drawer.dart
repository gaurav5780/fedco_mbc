import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class NavDrawer extends StatefulWidget {
  final User user;
  const NavDrawer({Key? key, required this.user}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavDrawer> {
  bool isJunior = true;

  @override
  void initState() {
    isJunior = getJunior(widget.user);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Color background = Theme.of(context).colorScheme.onInverseSurface;
    Color primary = Theme.of(context).colorScheme.primary;
    return Drawer(
      child: Material(
        color: background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpacing(AppConstants.marginLarge * 4),
              buildHeader(context, widget.user, primary),
              buildMenuItems(context, widget.user, primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, User theUser, Color primary) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.pop(context);
            PageNavigator.goToProfileScreen(context, theUser);
          },
          leading: CircleAvatar(
            radius: AppConstants.imageRadiusSmall,
            backgroundImage: NetworkImage(theUser.userAvatar),
          ),
          title: Text(
            theUser.userName,
            style: TextStyle(
              fontSize: AppConstants.mediumFont,
              color: primary,
            ),
          ),
          subtitle: Text(
            theUser.userEmail,
            style: TextStyle(
              fontSize: AppConstants.smallFont,
              color: primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMenuItems(
    BuildContext context,
    User theUser,
    Color primary,
  ) =>
      Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Wrap(
          runSpacing: 2,
          children: [
            const Divider(
              thickness: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.home_outlined,
                color: primary,
              ),
              title: Text(
                'Dashboard',
                style: TextStyle(
                  color: primary,
                ),
              ),
              onTap: () =>
                  PageNavigator.navigateBasedOnUserLevel(context, theUser),
            ),
            ListTile(
              leading: Icon(
                Icons.trending_up_outlined,
                color: primary,
              ),
              title: Text(
                'Trends',
                style: TextStyle(
                  color: primary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                PageNavigator.goToTrendsScreen(context, theUser);
              },
            ),
            (isJunior)
                ? makeTaskTile(primary)
                : makeRecommendationTile(primary),
            ListTile(
              leading: Icon(
                Icons.task_outlined,
                color: primary,
              ),
              title: Text(
                'Tasks Assigned',
                style: TextStyle(
                  color: primary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                PageNavigator.goToTaskList(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.task_alt_outlined,
                color: primary,
              ),
              title: Text(
                'Task calendar',
                style: TextStyle(
                  color: primary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                PageNavigator.goToCalendarScreen(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.leaderboard_outlined,
                color: primary,
              ),
              title: Text(
                'Leaderboard',
                style: TextStyle(
                  color: primary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                PageNavigator.goToLeaderBoard(context);
              },
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.help_outline,
                color: primary,
              ),
              title: Text(
                'Help',
                style: TextStyle(
                  color: primary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                //TODO : Go to Help page
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings_outlined,
                color: primary,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: primary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                PageNavigator.goToSettings(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout_outlined,
                color: primary,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: primary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                logoutProcess();
                PageNavigator.goToLoginScreen(context);
              },
            ),
          ],
        ),
      );

  Future<void> logoutProcess() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setInt(AppConstants.sharedPrefUserID, 0);
    sharedPreferences.setBool(AppConstants.sharedPrefIsLoggedIn, false);
    sharedPreferences.setBool(AppConstants.sharedPrefHasSeenIntro, false);
    sharedPreferences.setString(AppConstants.sharedPrefUserName, '');
    sharedPreferences.setString(AppConstants.sharedPrefUserAvatar, '');
    sharedPreferences.setString(AppConstants.sharedPrefEmail, '');
    sharedPreferences.setString(AppConstants.sharedPrefPass, '');
    sharedPreferences.setString(AppConstants.sharedPrefUserAreaID, '');
    sharedPreferences.setString(AppConstants.sharedPrefUserLevel, '');
    sharedPreferences.setInt(AppConstants.sharedPrefUserReportsTo, 0);
    sharedPreferences.setInt(AppConstants.sharedPrefUserIncentiveScore, 0);
  }

  bool getJunior(User user) {
    bool level;
    if (user.userLevel == UserLevelID.meterReader) {
      level = true;
    } else if (user.userLevel == UserLevelID.executive) {
      level = true;
    } else {
      level = false;
    }
    return level;
  }

  makeRecommendationTile(Color primary) {
    return ListTile(
      leading: Icon(
        Icons.recommend_rounded,
        color: primary,
      ),
      title: Text(
        'Recommendations',
        style: TextStyle(
          color: primary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        PageNavigator.goToRecommendationList(context, widget.user);
      },
    );
  }

  makeTaskTile(Color primary) {
    return ListTile(
      leading: Icon(
        Icons.task_outlined,
        color: primary,
      ),
      title: Text(
        'Tasks',
        style: TextStyle(
          color: primary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        PageNavigator.goToMemberTaskList(context, widget.user);
      },
    );
  }
}
