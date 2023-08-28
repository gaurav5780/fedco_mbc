import 'package:fedco_mbc/Constants/billingrecommendation_constants.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Dashboard/dashboard_tools.dart';
import 'package:fedco_mbc/Recommendations/recommendation_detail.dart';
import 'package:fedco_mbc/Services/billingperformance_services.dart';
import 'package:fedco_mbc/Services/billingrecommendation_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'billingrecommendation_card.dart';
import '../models/billing_recommendation.dart';

class RecommendationsList extends StatefulWidget {
  final User user;
  const RecommendationsList({Key? key, required this.user}) : super(key: key);

  @override
  State<RecommendationsList> createState() => _RecommendationsListState();
}

class _RecommendationsListState extends State<RecommendationsList> {
  late Future<List<BillingRecommendation>> recommendations;
  late Future<List<BillingPerformance>> performances;
  List<BillingRecommendation> recList = List.empty(growable: true);
  List<BillingPerformance> perfList = List.empty(growable: true);
  List<BillingRecommendation> filteredList = List.empty(growable: true);
  bool isComplete = false;

  @override
  void initState() {
    recommendations = getAllBillingRecommendations();
    performances = getAllBillingPerformances();
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
          'Recommended Actions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: floatingActionButton(),
      body: (isComplete)
          ? makeListView(widget.user)
          : makeFutureBuilder(widget.user),
    );
  }

  makeListView(User user) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final recommendation = filteredList[index];
                return InkWell(
                  child: BillingRecommendationCard(
                      recommendation: recommendation, performances: perfList),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecommendationDetail(
                              recommendation: recommendation,
                              thisUser: user,
                              performance: perfList),
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

  makeFutureBuilder(User thisUser) {
    return FutureBuilder(
        future: recommendations,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            recList = snapshot.data as List<BillingRecommendation>;
            // for (int i = 0; i < recList.length; i++) {
            //   if ((thisUser.area == AreaIDs.all) ||
            //       (thisUser.area == AreaIDs.meghalaya)) {
            //     debugPrint(getAreaNamefromInt(thisUser.area));
            //   } else {
            //     if (recList[i].billingPerformance != thisUser.area) {
            //       recList.remove(recList[i]);
            //     }
            //   }
            // }
            filteredList = recList;
            return makePerformanceBuilder(thisUser);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'));
          } else {
            return LoaderTransparent();
          }
        }));
  }

  makePerformanceBuilder(User thisUser) {
    return FutureBuilder(
      future: performances,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          perfList = snapshot.data as List<BillingPerformance>;
          isComplete = true;
          return makeListView(thisUser);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error : ${snapshot.error}'));
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  void runFilter(int label, List<BillingRecommendation> recList) {
    if (label == 0) {
      setState(() => filteredList = recList);
    } else {
      List<BillingRecommendation> list = List.empty(growable: true);
      for (var i = 0; i < recList.length; i++) {
        if (recList[i].currentStatus == label) {
          list.add(recList[i]);
        }
      }
      if (list.isEmpty) {
        throw Exception('No recommendations for this selection');
      } else {
        setState(() => filteredList = list);
      }
    }
  }

  floatingActionButton() {
    return SpeedDial(
      //backgroundColor: Colors.blueAccent,
      icon: Icons.filter_alt,
      activeIcon: Icons.arrow_upward_outlined,
      //overlayColor: Colors.white,
      //overlayOpacity: 0.7,
      spacing: 12,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.all_inclusive),
            label: 'All',
            onTap: () => {
                  runFilter(0, recList),
                }),
        SpeedDialChild(
            child: const Icon(Icons.done),
            label: BillingRecommendationStatusNames.newRec,
            onTap: () => {
                  runFilter(BillingRecommendationStatusID.newRec, recList),
                }),
        SpeedDialChild(
            child: const Icon(Icons.pending_actions),
            label: BillingRecommendationStatusNames.pendingRec,
            onTap: () => {
                  runFilter(BillingRecommendationStatusID.pendingRec, recList),
                }),
        SpeedDialChild(
            child: const Icon(Icons.access_time),
            label: BillingRecommendationStatusNames.progressRec,
            onTap: () => {
                  runFilter(BillingRecommendationStatusID.progressRec, recList),
                }),
        SpeedDialChild(
            child: const Icon(Icons.bookmark),
            label: BillingRecommendationStatusNames.delayedRec,
            onTap: () => {
                  runFilter(BillingRecommendationStatusID.delayedRec, recList),
                }),
        SpeedDialChild(
            child: const Icon(Icons.no_meeting_room),
            label: BillingRecommendationStatusNames.completedRec,
            onTap: () => {
                  runFilter(
                      BillingRecommendationStatusID.completedRec, recList),
                }),
        SpeedDialChild(
            child: const Icon(Icons.no_meeting_room),
            label: BillingRecommendationStatusNames.deferredRec,
            onTap: () => {
                  runFilter(BillingRecommendationStatusID.deferredRec, recList),
                }),
        SpeedDialChild(
            child: const Icon(Icons.no_meeting_room),
            label: BillingRecommendationStatusNames.droppedRec,
            onTap: () => {
                  runFilter(BillingRecommendationStatusID.droppedRec, recList),
                }),
      ],
    );
  }
}
