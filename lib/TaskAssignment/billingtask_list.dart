import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Services/billingassignment_services.dart';
import 'package:fedco_mbc/Services/billingtask_services.dart';
import 'package:fedco_mbc/Services/user_services.dart';
import 'package:fedco_mbc/TaskAssignment/billingtask_card.dart';
import 'package:fedco_mbc/TaskAssignment/billingtask_detail.dart';
import 'package:fedco_mbc/Utilities/helper_methods.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BillingTaskList extends StatefulWidget {
  const BillingTaskList({Key? key}) : super(key: key);

  @override
  State<BillingTaskList> createState() => _BillingTaskListState();
}

class _BillingTaskListState extends State<BillingTaskList> {
  Future<List<User>>? users;
  Future<List<BillingTask>>? tasks;
  Future<List<BillingAssignment>>? assignments;
  Future<int?>? futureUserID;
  bool tasksComplete = false;
  bool assignmentsComplete = false;
  bool usersComplete = false;
  bool loadingComplete = false;
  List<BillingTask> allTasks = <BillingTask>[];
  List<BillingAssignment> allAssignments = <BillingAssignment>[];
  List<User> allUsers = <User>[];
  int? thisUserID;

  @override
  void initState() {
    tasks = getAllBillingTasks();
    assignments = getAllBillingAssignments();
    users = getAllUsers();
    futureUserID = getLoginID();
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
          'Billing related tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: (tasksComplete)
          ? (assignmentsComplete)
              ? (usersComplete)
                  ? (loadingComplete)
                      ? makeListView()
                      : makeIDFuture()
                  : makeUserFuture()
              : makeAssignmentFuture()
          : makeTaskFuture(),
    );
  }

  makeListView() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allTasks.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return InkWell(
                  child: BillingTaskCard(
                    task: allTasks[index],
                    assignments: allAssignments,
                    users: allUsers,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillingTaskDetail(
                            id: thisUserID,
                            assignments: allAssignments,
                            task: allTasks[index],
                            users: allUsers,
                          ),
                          //       settings: RouteSettings(arguments: args),
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  makeTaskFuture() {
    return FutureBuilder(
      future: tasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has data');

          debugPrint('Task Success : ${snapshot.data}');
          allTasks = snapshot.data as List<BillingTask>;
          tasksComplete = true;
          return makeAssignmentFuture();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has error');
          debugPrint('TaskError : ${snapshot.error}');
          Fluttertoast.showToast(msg: 'Error : ${snapshot.error}');
          return Text('Task Error : ${snapshot.error}');
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  makeAssignmentFuture() {
    return FutureBuilder(
      future: assignments,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has data');
          debugPrint('Assignment Success : ${snapshot.data}');
          allAssignments = snapshot.data as List<BillingAssignment>;
          assignmentsComplete = true;
          return makeUserFuture();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has error');
          debugPrint('AssignmentError : ${snapshot.error}');
          Fluttertoast.showToast(msg: 'Error : ${snapshot.error}');
          return Text('Assignment Error : ${snapshot.error}');
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  makeUserFuture() {
    return FutureBuilder(
      future: users,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has data');
          debugPrint('User Success : ${snapshot.data}');
          allUsers = snapshot.data as List<User>;
          usersComplete = true;
          return makeIDFuture();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has error');
          debugPrint('UserError : ${snapshot.error}');
          Fluttertoast.showToast(msg: 'Error : ${snapshot.error}');
          return Text('User Error : ${snapshot.error}');
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  makeIDFuture() {
    return FutureBuilder(
      future: getLoginID(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has data');
          debugPrint('User Success : ${snapshot.data}');
          thisUserID = snapshot.data as int;
          loadingComplete = true;
          return makeListView();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has error');
          debugPrint('UserError : ${snapshot.error}');
          Fluttertoast.showToast(msg: 'Error : ${snapshot.error}');
          return Text('User Error : ${snapshot.error}');
        } else {
          return LoaderTransparent();
        }
      },
    );
  }
}
