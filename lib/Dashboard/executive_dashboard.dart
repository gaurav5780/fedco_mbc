import 'package:fedco_mbc/Constants/billingtask_constants.dart';
import 'package:fedco_mbc/Dashboard/dashboard_tools.dart';
import 'package:fedco_mbc/Dashboard/nav_drawer.dart';
import 'package:fedco_mbc/Services/billingtask_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExecutiveDashboard extends StatefulWidget {
  final User currentUser;
  const ExecutiveDashboard({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<ExecutiveDashboard> createState() => _ExecutiveDashboardState();
}

class _ExecutiveDashboardState extends State<ExecutiveDashboard> {
  Future<List<BillingTask>>? futureTasks;
  List<BillingTask> allTasks = <BillingTask>[];
  List<BillingTask> completedTasks = <BillingTask>[];
  List<BillingTask> progressTasks = <BillingTask>[];
  List<BillingTask> delayedTasks = <BillingTask>[];
  List<BillingTask> createdTasks = <BillingTask>[];
  bool isComplete = false;

  @override
  void initState() {
    futureTasks = getAllBillingTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Executive Dashboard')),
      body: (isComplete) ? makeDashboard() : makeTaskFuture(),
      //drawer: NavigationDrawer(user: widget.currentUser),
    );
  }

  FutureBuilder makeTaskFuture() {
    return FutureBuilder(
      future: futureTasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has data');
          allTasks = snapshot.data as List<BillingTask>;
          isComplete = true;
          debugPrint(allTasks.first.description);
          return makeDashboard();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has error');
          Fluttertoast.showToast(msg: '${snapshot.error}');
          debugPrint('${snapshot.error}');
          return Text('${snapshot.error}');
        } else {
          debugPrint('snapshot is waiting for data');
          return LoaderTransparent();
        }
      },
    );
  }

  makeDashboard() {
    debugPrint('makeDashboard');
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.95;
    // for (var i = 0; i < allTasks.length; i++) {
    //   switch (allTasks[i].status) {
    //     case TaskStatusID.completed:
    //       completedTasks.add(allTasks[i]);
    //       break;
    //     case TaskStatusID.created:
    //       createdTasks.add(allTasks[i]);
    //       break;
    //     case TaskStatusID.delayed:
    //       delayedTasks.add(allTasks[i]);
    //       break;
    //     case TaskStatusID.inProgress:
    //       progressTasks.add(allTasks[i]);
    //       break;
    //     default:
    //       break;
    //   }
    // }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            makeHeading('Tasks overview'),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.8,
                children: [
                  // makeSmallCard(TaskStatusID.completed, completedTasks),
                  // makeSmallCard(TaskStatusID.inProgress, progressTasks),
                  // makeSmallCard(TaskStatusID.delayed, delayedTasks),
                  // makeSmallCard(TaskStatusID.created, createdTasks),
                ],
              ),
            ),
            makeHeading('My tasks'),
          ],
        ),
      ),
    );
  }

  makeSmallCard(int status, List<BillingTask> tasks) {
    //String heading = getTaskStatusfromInt(status);
    Icon icon = const Icon(Icons.abc_rounded);
    //MaterialAccentColor colors = Colors.blueAccent;
    // switch (status) {
    //   case TaskStatusID.completed:
    //     icon = const Icon(Icons.check_box_outlined);
    //     colors = Colors.deepPurpleAccent;
    //     break;
    //   case TaskStatusID.created:
    //     icon = const Icon(Icons.create_outlined);
    //     colors = Colors.blueAccent;
    //     break;
    //   case TaskStatusID.inProgress:
    //     icon = const Icon(Icons.hourglass_bottom_rounded);
    //     colors = Colors.orangeAccent;
    //     break;
    //   case TaskStatusID.delayed:
    //     icon = const Icon(Icons.timelapse_rounded);
    //     colors = Colors.redAccent;
    //     break;
    //   default:
    //     break;
    // }
    int numbers = tasks.length;
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          //color: colors
        ),
        child: Column(children: [
          Row(
            children: [
              icon,
              const SizedBox(
                width: 20,
              ),
              Text(
                '$numbers',
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'test',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  makeHeading(String heading) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        const Divider(
          height: 0.5,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          heading,
          style: headingStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0.5,
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  //TODO: Make common heading styles in theme:
  get headingStyle =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
}
