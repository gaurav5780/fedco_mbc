import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/ListViews/user_tile.dart';
import 'package:fedco_mbc/Updates/create_update.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BillingTaskDetail extends StatelessWidget {
  final BillingTask task;
  final List<User> users;
  final List<BillingAssignment> assignments;
  final int? id;
  const BillingTaskDetail(
      {Key? key,
      required this.task,
      required this.users,
      required this.assignments,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BillingAssignment> relevantAssignments = findRelevantAssignments();
    List<User> relevantUsers = findRelevantUsers(relevantAssignments);

    //String ownerAvatar = getOwnerAvatar();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task detail'),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          makeTopRow(context, relevantAssignments),
          verticalSpacing(AppConstants.marginLarge),
          makeStatusRow(context),
          verticalSpacing(AppConstants.marginLarge),
          makeScheduleBlock(context, relevantAssignments),
          verticalSpacing(AppConstants.marginLarge),
          makeContributorBlock(context, relevantUsers),
          verticalSpacing(AppConstants.marginLarge),
          const Divider(
            thickness: 1,
          ),
          verticalSpacing(AppConstants.marginLarge),
          makeButtonBlock(context, relevantAssignments, relevantUsers),
          verticalSpacing(AppConstants.marginLarge),
        ]),
      )),
    );
  }

  statusContainer(BuildContext context) {
    return CircularPercentIndicator(
      progressColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      center: Text('${task.status} %'),
      animation: true,
      radius: 25,
      percent: double.parse(
        '${task.status / 100}',
      ),
    );
  }

  List<BillingAssignment> findRelevantAssignments() {
    List<BillingAssignment> relevant = [];
    for (var i = 0; i < assignments.length; i++) {
      debugPrint('${assignments[i].billingTask}');
      debugPrint('${task.billingRecommendation}');
      if (assignments[i].billingTask == task.billingRecommendation) {
        relevant.add(assignments[i]);
      }
    }
    return relevant;
  }

  List<User> findRelevantUsers(List<BillingAssignment> bA) {
    List<User> relevants = [];
    for (var i = 0; i < bA.length; i++) {
      for (var j = 0; j < users.length; j++) {
        if (bA[i].user == users[j].id) {
          relevants.add(users[j]);
          debugPrint('added');
          debugPrint('${relevants.length}');
        }
      }
    }
    return relevants;
  }

  String getOwnerAvatar() {
    String avatar =
        'https://live.staticflickr.com/65535/52211351040_382aa8e83d_m.jpg';
    for (var i = 0; i < users.length; i++) {
      if (users[i].id == task.createdBy) {
        avatar = users[i].userAvatar;
      }
    }
    return avatar;
  }

  makeIncentiveBox(
      BuildContext context, List<BillingAssignment> relevantAssignments) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${relevantAssignments.first.incentive}',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Incentive',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  makeContributors(List<User> relevantUsers) {
    List<Widget> list = [];
    for (var i = 0; i < relevantUsers.length; i++) {
      if (i < 3) {
        list.add(ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CircleAvatar(
              maxRadius: 16, child: Image.network(relevantUsers[i].userAvatar)),
        ));
      }
    }
    return list;
  }

  makeHeading(BuildContext context, BillingTask task) {
    return Expanded(
      child: Container(
          height: 110,
          padding: const EdgeInsets.all(AppConstants.paddingSmall),
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              borderRadius: BorderRadius.circular(AppConstants.cardRadius)),
          child: Center(
              child: Text(
            task.description,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: AppConstants.mediumFont),
          ))),
    );
  }

  makeTopRow(BuildContext context, relevantAssignments) {
    return Row(
      children: [
        makeIncentiveBox(context, relevantAssignments),
        horizontalSpacing(AppConstants.marginSmall),
        makeHeading(context, task),
      ],
    );
  }

  makeScheduleBlock(
      BuildContext context, List<BillingAssignment> relevantAssignments) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            makeScheduleHeading('Planned :'),
            const SizedBox(
              height: 8,
            ),
            makeShowDates(relevantAssignments.first.plannedStartDate,
                relevantAssignments.first.plannedEndDate),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              thickness: 0.5,
            ),
            const SizedBox(
              height: 16,
            ),
            makeScheduleHeading('Actual :'),
            const SizedBox(
              height: 8,
            ),
            makeShowDates(relevantAssignments.first.actualStartDate,
                relevantAssignments.first.actualEndDate),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  makeScheduleHeading(String label) {
    return Row(
      children: [
        const Icon(Icons.calendar_today),
        const SizedBox(
          width: 16,
        ),
        Text(label),
      ],
    );
  }

  makeShowDates(DateTime startDate, DateTime endDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Start : ${DateFormat('dd-MMM-yyyy').format(startDate)}'),
        const SizedBox(
          width: 16,
        ),
        Text('End : ${DateFormat('dd-MMM-yyyy').format(endDate)}'),
      ],
    );
  }

  makeContributorBlock(BuildContext context, List<User> relevantUsers) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: const [
              Icon(Icons.person_add_alt_1_rounded),
              SizedBox(
                width: 16,
              ),
              Text('Contributors'),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          makeUserTiles(relevantUsers),
        ]),
      ),
    );
  }

  makeUserTiles(List<User> relevantUsers) {
    relevantUsers
        .sort(((b, a) => a.userIncentiveScore.compareTo(b.userIncentiveScore)));
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: relevantUsers.length,
        itemBuilder: (context, index) {
          return userTile(context, relevantUsers, index);
        },
      ),
    );
  }

  makeStatusRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.person_pin),
              horizontalSpacing(AppConstants.marginLarge),
              Text('Task owner'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  makeOwnerRow(),
                ],
              ),
              statusContainer(context),
            ],
          ),
        ],
      ),
    );
  }

  makeOwnerRow() {
    User? owner;
    for (var i = 0; i < users.length; i++) {
      if (task.createdBy == users[i].id) {
        owner = users[i];
        break;
      }
    }
    if (owner != null) {
      return Container(
        padding: EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CircleAvatar(
                  maxRadius: 16, child: Image.network(owner.userAvatar)),
            ),
            SizedBox(
              width: 12,
            ),
            Text('${owner.userName}'),
          ],
        ),
      );
    }
  }

  makeButtonBlock(BuildContext context,
      List<BillingAssignment> relevantAssignments, List<User> relevantUsers) {
    return (checkContributionStatus(relevantUsers))
        ? makeUpdateButton(context, relevantAssignments, relevantUsers)
        : makeVolunteerButton(context, relevantAssignments);
  }

  checkContributionStatus(List<User> relevantUsers) {
    bool status = false;
    if (id != null) {
      for (var i = 0; i < relevantUsers.length; i++) {
        if (relevantUsers[i].id == id) {
          status = true;
          break;
        }
      }
    }
    debugPrint('User is a contributor: $status');
    return status;
  }

  makeUpdateButton(BuildContext context,
      List<BillingAssignment> relevantAssignments, List<User> relevantUsers) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              User? user;
              BillingAssignment? billingAssignment;
              for (var i = 0; i < relevantUsers.length; i++) {
                if (relevantUsers[i].id == id) {
                  user = relevantUsers[i];
                  break;
                }
              }
              for (var i = 0; i < relevantAssignments.length; i++) {
                if (relevantAssignments[i].user == id) {
                  billingAssignment = relevantAssignments[i];
                  break;
                }
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateUpdate(
                            billingAssignment: billingAssignment,
                            billingTask: task,
                            user: user,
                          )));
            },
            style: ElevatedButton.styleFrom(
                //primary: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
            child: const Text(
              'Post update',
              style: TextStyle(
                fontSize: 18,
                //color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }

  makeVolunteerButton(
      BuildContext context, List<BillingAssignment> relevantAssignments) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Text(
            'You can earn ${relevantAssignments.first.incentive} points if you volunteer'),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              //PageNavigator.goToAssignTask(context, args);
            },
            style: ElevatedButton.styleFrom(
                //primary: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
            child: const Text(
              'Volunteer now',
              style: TextStyle(
                fontSize: 18,
                //color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }
}
