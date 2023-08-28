import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResourceWiseCard extends StatelessWidget {
  final User user;
  final List<BillingTask> tasks;
  final List<BillingAssignment> assignments;
  const ResourceWiseCard(
      {Key? key,
      required this.user,
      required this.assignments,
      required this.tasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BillingAssignment> relevantAssignments = findRelevantAssignments();
    List<BillingTask> relevantTask = findRelevantTask(relevantAssignments);
    return Card(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            //color: Theme.of(context).cardColor,
            borderRadius:
                const BorderRadiusDirectional.all(Radius.circular(20))),
        child: Column(children: [
          makeUserBlock(context),
          Divider(
            height: 0.5,
          ),
          makeAssignmentBlock(context, relevantAssignments, relevantTask),
        ]),
      ),
    );
  }

  makeUserBlock(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      //width: MediaQuery.of(context).size.width * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CircleAvatar(
                maxRadius: 32, child: Image.network(user.userAvatar)),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.userName),
              const SizedBox(
                height: 8,
              ),
              Text(
                  '${getUserLevelFromInt(user.userLevel)}, ${getAreaNamefromInt(user.area)}'),
            ],
          )
        ],
      ),
    );
  }

  makeAssignmentBlock(
      BuildContext context,
      List<BillingAssignment> relevantAssignments,
      List<BillingTask> relevantTask) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 500,
          minHeight: 100,
          maxWidth: MediaQuery.of(context).size.width * 0.95,
          minWidth: 300),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: relevantTask.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(4),
            child: ListTile(
                //tileColor: Theme.of(context).hoverColor,
                leading: CircleAvatar(
                  //backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    '${(index + 1)}',
                    style: const TextStyle(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                      //color: Colors.white
                    ),
                  ),
                ),
                title: Text(relevantTask[index].description),
                subtitle: Text(
                    '${DateFormat('dd-MMM-yyyy').format(relevantAssignments[index].plannedStartDate)} to ${DateFormat('dd-MMM-yyyy').format(relevantAssignments[index].plannedEndDate)}'),
                trailing: CircularPercentIndicator(
                  center: Text('${relevantTask[index].status} %'),
                  animation: true,
                  radius: 25,
                  //backgroundColor: Colors.white24,
                  percent: double.parse(
                    '${relevantTask[index].status / 100}',
                  ),
                  //progressColor: Colors.blueAccent,
                )),
          );
        },
      ),
    );
  }

  List<BillingAssignment> findRelevantAssignments() {
    List<BillingAssignment> temp = <BillingAssignment>[];
    for (var i = 0; i < assignments.length; i++) {
      debugPrint('USER ID: ${user.id}');
      debugPrint('ASSIGNMENT ID: ${assignments[i].user}');
      if (user.id == assignments[i].user) {
        temp.add(assignments[i]);
        debugPrint('ADDED');
      }
    }
    return temp;
  }

  List<BillingTask> findRelevantTask(
      List<BillingAssignment> relevantAssignments) {
    List<BillingTask> temp = [];
    for (var i = 0; i < tasks.length; i++) {
      for (var j = 0; j < relevantAssignments.length; j++) {
        if (tasks[i].billingRecommendation ==
            relevantAssignments[j].billingTask) {
          temp.add(tasks[i]);
          break;
        }
      }
    }
    return temp;
  }
}
