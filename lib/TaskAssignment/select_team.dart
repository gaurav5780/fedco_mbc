import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:fedco_mbc/Services/user_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_recommendation.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'users_list_tile_widget.dart';

class SelectTeam extends StatefulWidget {
  final BillingTask task;
  final BillingAssignment assignment;
  final User currentUser;
  final String area;
  final BillingRecommendation recommendation;
  const SelectTeam(
      {Key? key,
      required this.task,
      required this.assignment,
      required this.currentUser,
      required this.area,
      required this.recommendation})
      : super(key: key);

  @override
  State<SelectTeam> createState() => _SelectTeamState();
}

class _SelectTeamState extends State<SelectTeam> {
  // Future Lists to handle all the database queries:
  Future<List<User>>? allUsers;

  // For holding Users and assignment data:

  List<User> selectedUsers = <User>[];
  List<User> subordinateUsers = <User>[];
  List<User> userList = <User>[];
  // Bool field to define the status of data fetching and updation:
  bool loadingCompleted = false;

  @override
  void initState() {
    // Get all Users from Database:
    allUsers = getAllUsers();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Step 4 - Select team',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: (loadingCompleted)
          ? buildMemberSelection(subordinateUsers, widget.recommendation,
              widget.task, widget.assignment)
          : makeUserBuilder(widget.recommendation, widget.task,
              widget.assignment, widget.currentUser, widget.area),
    );
  }

  makeUserBuilder(BillingRecommendation recommendation, BillingTask task,
      BillingAssignment assignment, User currentUser, String area) {
    debugPrint('makeUserBuilder');
    return FutureBuilder(
        future: allUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userList = snapshot.data as List<User>;
            findSubordinates(userList, currentUser, area);
            debugPrint('findSubordinates : ${subordinateUsers.length}');
            // Now build the UI for selection of team members:

            loadingCompleted = true;
            //return LoaderTransparent();
            return buildMemberSelection(
                subordinateUsers, recommendation, task, assignment);
          } else if (snapshot.hasError) {
            return ErrorWidget(Text('Error : ${snapshot.error}'));
          } else {
            return LoaderTransparent();
          }
        });
  }

  buildMemberSelection(List<User> users, BillingRecommendation recommendation,
      BillingTask task, BillingAssignment assignment) {
    debugPrint('buildMemberSelection');
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: users.map((user) {
              final isSelected = selectedUsers.contains(user);
              return UsersListTileWidget(
                user: user,
                isSelected: isSelected,
                onSelectedUser: (selectedUsers) {
                  teamSelection(user);
                },
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              //color: Colors.blueAccent,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    //primary: Colors.blueAccent,
                    //shadowColor: Colors.amberAccent
                  ),
                  onPressed: (() {
                    debugPrint('Tested');
                    PageNavigator.goToCreateTask(
                        context, task, assignment, users, recommendation);
                  }),
                  //buttonPressed(recommendation, task, assignment),
                  child: Text(
                    buttonText(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      //color: Colors.white
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  buttonPressed(BillingRecommendation recommendation, BillingTask task,
      BillingAssignment assignment) {
    debugPrint('buttonPressed');
    if (selectedUsers.isEmpty) {
      ErrorWidget(
        const Text('Minimum 1 team member is required'),
      );
    } else {
      // ArgsRecTaskAssignmentUsers args = ArgsRecTaskAssignmentUsers(
      //     task, assignment, selectedUsers, recommendation);
      // PageNavigator.goToCreateTask(context, args);
    }
  }

  teamSelection(User user) {
    final isSelected = selectedUsers.contains(user);
    setState(() {
      isSelected ? selectedUsers.remove(user) : selectedUsers.add(user);
    });
  }

  String buttonText() {
    String text = '';
    if (selectedUsers.length == 1) {
      text = "${selectedUsers.length} member selected";
    } else {
      text = "${selectedUsers.length} members selected";
    }
    return text;
  }

  findSubordinates(List<User> userList, User currentUser, String area) {
    List<User> users = userList;
    for (var element in users) {
      if ((element.userLevel == UserLevelID.manager) ||
          (element.userLevel == UserLevelID.executive) ||
          (element.userLevel == UserLevelID.meterReader)) {
        subordinateUsers.add(element);
      }
    }
    int areaID = getAreaNamefromString(area);
    debugPrint('$areaID');
  }
}
