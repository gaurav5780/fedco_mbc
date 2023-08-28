import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BillingTaskCard extends StatelessWidget {
  final List<BillingAssignment> assignments;
  final BillingTask task;
  final List<User> users;
  const BillingTaskCard({
    Key? key,
    required this.task,
    required this.assignments,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BillingAssignment> relevantAssignments = findRelevantAssignments();
    List<User> relevantUsers = findRelevantUsers(relevantAssignments);
    String ownerAvatar = getOwnerAvatar();
    return Card(
        child: Column(children: [
      Container(
        padding: const EdgeInsets.all(AppConstants.paddingSmall),
        decoration: const BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(20), topEnd: Radius.circular(20))),
        child: Container(
          //padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                task.description,
                style: const TextStyle(
                    fontSize: AppConstants.mediumFont,
                    fontWeight: FontWeight.bold),
              )),
              statusContainer(context),
            ],
          ),
        ),
      ),
      Container(
          padding: const EdgeInsets.all(AppConstants.paddingSmall),
          decoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(20),
                  bottomEnd: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  makeIncentiveBox(context, relevantAssignments),
                  horizontalSpacing(AppConstants.marginSmall),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              horizontalSpacing(AppConstants.marginSmall),
                              Text(DateFormat('dd-MMM-yyyy')
                                  .format(
                                      relevantAssignments.last.plannedStartDate)
                                  .toString()),
                              const SizedBox(
                                width: 4,
                              ),
                              const Text('-'),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(DateFormat('dd-MMM-yyyy')
                                  .format(
                                      relevantAssignments.last.plannedEndDate)
                                  .toString()),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Text('  Contributors :  '),
                            Row(
                              children: makeContributors(relevantUsers),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(
                height: 0.5,
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('Owner    '),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CircleAvatar(
                                  maxRadius: 16,
                                  child: Image.network(ownerAvatar)),
                            ),
                          ],
                        ),
                        Text(
                            'Created ${DateFormat('dd-MMM-yyyy').format(task.createdDate)}'),
                      ])),
            ],
          )),
    ]));
  }

  statusContainer(BuildContext context) {
    return CircularPercentIndicator(
      progressColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      center: Text('${task.status} %'),
      animation: true,
      radius: AppConstants.imageRadiusMedium,
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
      padding: const EdgeInsets.all(AppConstants.paddingSmall),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(
            '${relevantAssignments.first.incentive}',
            style: const TextStyle(
                fontSize: AppConstants.largeFont, fontWeight: FontWeight.bold),
          ),
          const Text('Incentive'),
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
}
