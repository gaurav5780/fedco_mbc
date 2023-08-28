import 'package:fedco_mbc/Dashboard/chief_dashboard.dart';
import 'package:fedco_mbc/Services/billingassignment_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';

class MemberAssignments extends StatefulWidget {
  final User user;
  const MemberAssignments({Key? key, required this.user}) : super(key: key);

  @override
  State<MemberAssignments> createState() => _MemberAssignmentsState();
}

class _MemberAssignmentsState extends State<MemberAssignments> {
  Future<List<BillingAssignment>>? futureAssignments;
  List<BillingAssignment> allAssignments = <BillingAssignment>[];
  List<BillingAssignment> userAssignments = <BillingAssignment>[];
  bool isLoaded = false;

  @override
  void initState() {
    futureAssignments = getAllBillingAssignments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Tasks'),
      ),
      body: (isLoaded) ? makeList() : makeFuture(widget.user),
    );

    // Lists all the tasks in Users' area:
  }

  makeFuture(User user) {
    return Center(
      child: FutureBuilder(
        future: futureAssignments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Snapshot has data: ${snapshot.data}');
            allAssignments = snapshot.data as List<BillingAssignment>;
            // for (var i = 0; i < allAssignments.length; i++) {
            //   if (user.id == allAssignments[i].user) {
            //     userAssignments.add(allAssignments[i]);
            //     break;
            //   }
            // }
            isLoaded = true;
            return makeList();
          } else if (snapshot.hasError) {
            debugPrint('Snapshot has error: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          } else {
            return LoaderTransparent();
          }
        },
      ),
    );
  }

  makeList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allAssignments.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              //final assignments = userAssignments[index];
              return ListTile(
                title: Text(
                  '${allAssignments[index].plannedStartDate}',
                ),
                subtitle: Text('${allAssignments[index].plannedEndDate}'),
                //{
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const RecommendationDetail(),
                //         //settings: RouteSettings(arguments: args),
                //       ));
                // },
              );
            },
          ),
        ),
      ],
    );
  }
}
