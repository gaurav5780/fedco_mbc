import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:fedco_mbc/Services/billingassignment_services.dart';
import 'package:fedco_mbc/Services/billingtask_services.dart';
import 'package:fedco_mbc/Services/user_services.dart';
import 'package:fedco_mbc/TeamView/resourcewise_card.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';

class ResourceWiseList extends StatefulWidget {
  final User thisUser;
  const ResourceWiseList({Key? key, required this.thisUser}) : super(key: key);

  @override
  State<ResourceWiseList> createState() => _ResourceWiseListState();
}

class _ResourceWiseListState extends State<ResourceWiseList> {
  Future<List<User>>? futureUsers;
  Future<List<BillingTask>>? futureTasks;
  Future<List<BillingAssignment>>? futureAssignments;
  List<User> allUsers = <User>[];
  List<BillingTask> allTasks = <BillingTask>[];
  List<BillingAssignment> allAssignments = <BillingAssignment>[];
  bool loadingComplete = false;

  @override
  void initState() {
    super.initState();
    futureUsers = getAllUsers();
    futureAssignments = getAllBillingAssignments();
    futureTasks = getAllBillingTasks();
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
        'Resource-wise tasks',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: Center(
        child: (loadingComplete) ? makeList() : makeUserFuture(),
      ),
    );
  }

  makeUserFuture() {
    return FutureBuilder(
      future: futureUsers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has Data ${snapshot.data}');
          allUsers = snapshot.data as List<User>;
          return makeTaskFuture();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has Error ${snapshot.error}');
          return Text('Error : ${snapshot.error}');
        } else {
          debugPrint('snapshot is waiting for data');
          return LoaderTransparent();
        }
      },
    );
  }

  makeTaskFuture() {
    return FutureBuilder(
      future: futureTasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has Data ${snapshot.data}');
          allTasks = snapshot.data as List<BillingTask>;
          return makeAssignmentFuture();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has Error ${snapshot.error}');
          return Text('Error : ${snapshot.error}');
        } else {
          debugPrint('snapshot is waiting for data');
          return LoaderTransparent();
        }
      },
    );
  }

  makeAssignmentFuture() {
    return FutureBuilder(
      future: futureAssignments,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has Data ${snapshot.data}');
          allAssignments = snapshot.data as List<BillingAssignment>;
          loadingComplete = true;
          return makeList();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has Error ${snapshot.error}');
          return Text('Error : ${snapshot.error}');
        } else {
          debugPrint('snapshot is waiting for data');
          return LoaderTransparent();
        }
      },
    );
  }

  makeList() {
    // Find subordinates of thisUser:
    List<User> subordinates = <User>[];
    switch (widget.thisUser.userLevel) {
      case UserLevelID.admin:
      case UserLevelID.chief:
      case UserLevelID.guest:
        for (var i = 0; i < allAssignments.length; i++) {
          for (var j = 0; j < allUsers.length; j++) {
            if (allAssignments[i].user == allUsers[j].id) {
              if (!subordinates.contains(allUsers[j])) {
                subordinates.add(allUsers[j]);
                break;
              }
            }
          }
        }
        break;
      case UserLevelID.executive:
      case UserLevelID.manager:
      case UserLevelID.meterReader:
        for (var i = 0; i < allUsers.length; i++) {
          if (allUsers[i].area == widget.thisUser.area) {
            subordinates.add(allUsers[i]);
          }
        }
        break;
      default:
        break;
    }
    // Make list now:
    return ListView.builder(
      shrinkWrap: true,
      itemCount: subordinates.length,
      itemBuilder: (context, index) {
        return ResourceWiseCard(
            user: subordinates[index],
            assignments: allAssignments,
            tasks: allTasks);
      },
    );
  }
}
