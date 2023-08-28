import 'package:fedco_mbc/Recommendations/recommendation_detail.dart';
import 'package:fedco_mbc/Screens/intro_screen.dart';
import 'package:fedco_mbc/Screens/login_screen.dart';
import 'package:fedco_mbc/Screens/member_assignments.dart';
import 'package:fedco_mbc/Screens/nav_screen.dart';
import 'package:fedco_mbc/Screens/profile_screen.dart';
import 'package:fedco_mbc/Trends/billing_trend.dart';
import 'package:fedco_mbc/Trends/trends_screen.dart';
import 'package:fedco_mbc/Screens/user_settings.dart';
import 'package:fedco_mbc/TaskAssignment/billingtask_list.dart';
import 'package:fedco_mbc/TaskAssignment/update_recommendation.dart';
import 'package:fedco_mbc/TeamView/resourcewise_list.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:fedco_mbc/models/billing_recommendation.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:flutter/material.dart';
import '../Dashboard/chief_dashboard.dart';
import '../models/user.dart';
import 'package:fedco_mbc/Admin/create_area.dart';
import 'package:fedco_mbc/Admin/create_billing_performance.dart';
import 'package:fedco_mbc/Admin/create_recommendation.dart';
import 'package:fedco_mbc/Admin/create_user.dart';
import 'package:fedco_mbc/CalendarViews/calendar_view.dart';
import 'package:fedco_mbc/CalendarViews/team_calendar.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:fedco_mbc/Dashboard/admin_dashboard.dart';
import 'package:fedco_mbc/Dashboard/executive_dashboard.dart';
import 'package:fedco_mbc/Dashboard/guest_dashboard.dart';
import 'package:fedco_mbc/Dashboard/manager_dashboard.dart';
import 'package:fedco_mbc/Dashboard/meterreader_dashboard.dart';
import 'package:fedco_mbc/TaskAssignment/assign_task.dart';
import 'package:fedco_mbc/TaskAssignment/create_task.dart';
import 'package:fedco_mbc/TaskAssignment/select_team.dart';
import 'package:fedco_mbc/Trends/billing_efficiency.dart';
import 'package:fedco_mbc/ListViews/leaderboard_list.dart';
import 'package:fedco_mbc/Recommendations/recommendation_list.dart';

class PageNavigator {
  static void goToNavScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const NavScreen(),
    ));
  }

  static void goToIntroScreen(BuildContext context, User user) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => IntroScreen(currentUser: user),
    ));
  }

  static void goToLoginScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  static void navigateBasedOnUserLevel(BuildContext context, User user) {
    switch (user.userLevel) {
      case UserLevelID.guest:
        goToGuestDashboard(context, user);
        break;
      case UserLevelID.admin:
        goToAdminDashboard(context, user);
        break;
      case UserLevelID.chief:
        goToChiefDashboard(context, user);
        break;
      case UserLevelID.manager:
        goToManagerDashboard(context, user);
        break;
      case UserLevelID.executive:
        goToExecutiveDashboard(context, user);
        break;
      case UserLevelID.meterReader:
        goToMeterReaderDashboard(context, user);
        break;
      default:
        goToGuestDashboard(context, user);
        break;
    }
  }

  static void goToGuestDashboard(BuildContext context, User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GuestDashboard(
          currentUser: user,
        ),
      ),
    );
  }

  static void goToAdminDashboard(BuildContext context, User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdminDashboard(
          currentUser: user,
        ),
      ),
    );
  }

  static void goToChiefDashboard(BuildContext context, User user) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChiefDashboard(
        currentUser: user,
      ),
    ));
  }

  static void goToManagerDashboard(BuildContext context, User user) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ManagerDashboard(
        currentUser: user,
      ),
    ));
  }

  static void goToExecutiveDashboard(BuildContext context, User user) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExecutiveDashboard(
        currentUser: user,
      ),
    ));
  }

  static void goToMeterReaderDashboard(BuildContext context, User user) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MeterReaderDashboard(
        currentUser: user,
      ),
    ));
  }

  static void goToRecommendationList(BuildContext context, User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecommendationsList(user: user),
      ),
    );
  }

  static void goToTaskList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BillingTaskList(),
      ),
    );
  }

  static void goToTrendsScreen(BuildContext context, User thisUser) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrendScreen(
          thisUser: thisUser,
        ),
      ),
    );
  }

  static void goToCalendarScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CalendarScreen(),
      ),
    );
  }

  static goToTeamCalendar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TeamCalendar(),
      ),
    );
  }

  static void goToProfileScreen(BuildContext context, User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(user: user),
      ),
    );
  }

  static void goToLeaderBoard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LeaderBoard(),
      ),
    );
  }

  static void goToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UserSettings(),
      ),
    );
  }

  static void goToAssignTask(
      BuildContext context,
      BillingRecommendation recommendation,
      List<BillingPerformance> perf,
      User thisUser) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AssignTask(
          recommendation: recommendation,
          performances: perf,
          thisUser: thisUser,
        ),
      ),
    );
  }

  static goToCreateArea(BuildContext context, User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateArea(
          user: user,
        ),
      ),
    );
  }

  static goToCreateUser(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateUser(),
      ),
    );
  }

  static goToCreateAreaPerformance(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateBillingPerformance(),
      ),
    );
  }

  static goToCreateRecommendation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateBillingRecommendation(),
      ),
    );
  }

  static goToSelectTeam(
      BuildContext context,
      BillingTask task,
      BillingAssignment assignment,
      User currentUser,
      String area,
      BillingRecommendation recommendation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectTeam(
            task: task,
            area: area,
            assignment: assignment,
            recommendation: recommendation,
            currentUser: currentUser),
      ),
    );
  }

  static void goToCreateTask(
      BuildContext context,
      BillingTask task,
      BillingAssignment assignment,
      List<User> users,
      BillingRecommendation recommendation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateTask(
          task: task,
          assignment: assignment,
          users: users,
          recommendation: recommendation,
        ),
      ),
    );
  }

  static goToRecommendationDetail(
      BuildContext context,
      BillingRecommendation recommendation,
      User thisUser,
      List<BillingPerformance> performance) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecommendationDetail(
            recommendation: recommendation,
            thisUser: thisUser,
            performance: performance),
      ),
    );
  }

  static goToBillingEfficiency(BuildContext context,
      List<BillingPerformance> filteredBilling, int areaID) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BillingEfficiency(
          filteredBilling: filteredBilling,
          areaID: areaID,
        ),
      ),
    );
  }

  static void goToBillingPerformance(BuildContext context, User thisUser) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BillingTrend(
          thisUser: thisUser,
        ),
      ),
    );
  }

  static goToUpdateRecommendation(
      BuildContext context,
      BillingTask task,
      BillingAssignment assignment,
      List<User> users,
      BillingRecommendation recommendation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateRecommendation(
            task: task,
            assignment: assignment,
            recommendation: recommendation,
            users: users),
      ),
    );
  }

  static void goToMemberTaskList(BuildContext context, User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MemberAssignments(
          user: user,
        ),
      ),
    );
  }

  static goToResourceTaskList(BuildContext context, User currentUser) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ResourceWiseList(thisUser: currentUser)));
  }
}
