import 'package:fedco_mbc/Constants/billingrecommendation_constants.dart';
import 'package:fedco_mbc/Dashboard/dashboard_tools.dart';
import 'package:fedco_mbc/Services/billingassignment_services.dart';
import 'package:fedco_mbc/Services/billingrecommendation_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_recommendation.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Constants/page_navigator.dart';
import '../Services/billingtask_services.dart';

class CreateTask extends StatefulWidget {
  final BillingTask task;
  final BillingAssignment assignment;
  final List<User> users;
  final BillingRecommendation recommendation;
  const CreateTask(
      {Key? key,
      required this.task,
      required this.assignment,
      required this.users,
      required this.recommendation})
      : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  // Future<BillingTask>? task;
  // Future<BillingAssignment>? futureAssignment;
  bool loadingComplete = false;
  bool taskCreated = false;
  @override
  void initState() {
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
          'Creating Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: (taskCreated)
          ? (loadingComplete)
              ? goToCalendar()
              : makeAssignmentFuture(widget.recommendation, widget.assignment,
                  widget.task, widget.users)
          : makeTaskBuilder(widget.recommendation, widget.assignment,
              widget.task, widget.users),
    );
  }

  makeTaskBuilder(BillingRecommendation recommendation,
      BillingAssignment assignment, BillingTask task, List<User> users) {
    return FutureBuilder(
      future: createBillingTaskInDatabase(task),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has data');
          // Make alert that the task is created
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: 'Success : ${snapshot.data}');
          makeAssignmentFuture(recommendation, assignment, task, users);
          return Container();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has error');
          debugPrint('Error : ${snapshot.error}');
          Fluttertoast.showToast(msg: 'Error : ${snapshot.error}');
          return Text('Error : ${snapshot.error}');
        } else {
          debugPrint('snapshot is waiting for data');
          return LoaderTransparent();
        }
      },
    );
  }

  Future createTask(BillingTask task) async {
    await createBillingTaskInDatabase(task);
  }

  makeAssignmentFuture(BillingRecommendation recommendation,
      BillingAssignment assignment, BillingTask task, List<User> users) {
    List<BillingAssignment> assignments = <BillingAssignment>[];
    for (int i = 0; i < users.length; i++) {
      BillingAssignment newAssignment = BillingAssignment(
          //ID is auto-generated, so this id is dummy:
          id: assignment.id,
          // Assignment will be created for each user selected in step 4::
          user: users[i].id,
          // This will be the task ID aka BillingRecommendation id:
          billingTask: task.billingRecommendation,
          incentive: assignment.incentive,
          isVolunteered: assignment.isVolunteered,
          isAllDay: assignment.isAllDay,
          recurrenceRule: assignment.recurrenceRule,
          plannedStartDate: assignment.plannedStartDate,
          plannedEndDate: assignment.plannedEndDate,
          actualStartDate: assignment.actualStartDate,
          actualEndDate: assignment.actualEndDate);
      // Add each assignment (one for each user) to the list of assignments
      //assignments.add(newAssignment);
      // Create each assignment in database:
      debugPrint('Assigment #[$i] added');
      assignments.add(newAssignment);
    }
    taskCreated = true;
    FutureBuilder(
      future: Future.wait([createAssignments(assignments)]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: 'Success : ${snapshot.data}');
          debugPrint('Assignment Success : ${snapshot.data}');
          updateRecommendation(recommendation);
          return Container();
        } else if (snapshot.hasError) {
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG, msg: 'Error : ${snapshot.error}');
          debugPrint('Assignment Error : ${snapshot.error}');
          return Container();
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  Future createAssignments(List<BillingAssignment> newAssignments) async {
    for (var i = 0; i < newAssignments.length; i++) {
      //return list of Futures:
      createBillingAssignmentInDatabase(newAssignments[i]);
    }
  }

  void updateRecommendation(BillingRecommendation recommendation) {
    BillingRecommendation billingRecommendation = BillingRecommendation(
        id: recommendation.id,
        billingPerformance: recommendation.billingPerformance,
        recommendationDate: recommendation.recommendationDate,
        recommendationPriority: recommendation.recommendationPriority,
        numberOfCases: recommendation.numberOfCases,
        recommendationType: recommendation.recommendationType,
        recommendationCategory: recommendation.recommendationCategory,
        unitsLost: recommendation.unitsLost,
        amountLost: recommendation.amountLost,
        meterCost: recommendation.meterCost,
        meterBoxCost: recommendation.meterBoxCost,
        installationCost: recommendation.installationCost,
        paybackPeriodMonths: recommendation.paybackPeriodMonths,
        currentStatus: BillingRecommendationStatusID.progressRec);
    FutureBuilder(
      future: updateRec(billingRecommendation),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: 'Success : ${snapshot.data}');
          loadingComplete = true;
          goToCalendar();
          return Container();
        } else if (snapshot.hasError) {
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG, msg: 'Error : ${snapshot.error}');
          debugPrint('Error : ${snapshot.error}');
          return Container();
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  Future updateRec(BillingRecommendation billingRecommendation) async {
    await putBillingRecommendationByID(
        billingRecommendation, billingRecommendation.id);
  }

  goToCalendar() {
    PageNavigator.goToTeamCalendar(context);
  }
}

  // goToCreateAssignments(BillingRecommendation recommendation,
  //     BillingAssignment assignment, BillingTask task, List<User> users) {
  //   debugPrint('goToCreateAssignments');
  //   ArgsRecTaskAssignmentUsers args =
  //       ArgsRecTaskAssignmentUsers(task, assignment, users, recommendation);
  //   //Navigator.pop(context);

  //   PageNavigator.goToCreateAssignments(context, args);
  // }

