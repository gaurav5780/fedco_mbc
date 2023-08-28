import 'package:fedco_mbc/Constants/billingrecommendation_constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Dashboard/dashboard_tools.dart';
import 'package:fedco_mbc/Services/billingrecommendation_services.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_recommendation.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Utilities/progress_loader.dart';

class UpdateRecommendation extends StatefulWidget {
  final BillingTask task;
  final BillingAssignment assignment;
  final List<User> users;
  final BillingRecommendation recommendation;
  const UpdateRecommendation(
      {Key? key,
      required this.task,
      required this.assignment,
      required this.users,
      required this.recommendation})
      : super(key: key);

  @override
  State<UpdateRecommendation> createState() => _UpdateRecommendationState();
}

class _UpdateRecommendationState extends State<UpdateRecommendation> {
  bool loadingComplete = false;
  Future<BillingRecommendation>? futureRec;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Updating Recommendation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: (loadingComplete)
          ? goToCalendar()
          : makeRecommendationFuture(widget.recommendation, widget.assignment,
              widget.task, widget.users),
    );
  }

  makeRecommendationFuture(BillingRecommendation recommendation,
      BillingAssignment assignment, BillingTask task, List<User> users) {
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
    updateRec(billingRecommendation);
    FutureBuilder(
      future: futureRec,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Fluttertoast.showToast(msg: 'Success : ${snapshot.data}');
          loadingComplete = true;
          goToCalendar();
          return Container();
        } else if (snapshot.hasError) {
          Fluttertoast.showToast(msg: 'Error : ${snapshot.error}');
          return Container();
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  Future updateRec(BillingRecommendation billingRecommendation) async {
    futureRec = await putBillingRecommendationByID(
            billingRecommendation, billingRecommendation.id)
        as Future<BillingRecommendation>;
  }

  goToCalendar() {
    PageNavigator.goToTeamCalendar(context);
  }
}
