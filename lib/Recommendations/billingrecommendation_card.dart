import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/billingrecommendation_constants.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:flutter/material.dart';
import '../models/billing_recommendation.dart';

class BillingRecommendationCard extends StatelessWidget {
  final BillingRecommendation recommendation;
  final List<BillingPerformance> performances;

  const BillingRecommendationCard({
    Key? key,
    required this.recommendation,
    required this.performances,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double capex = recommendation.meterBoxCost +
        recommendation.meterBoxCost +
        recommendation.installationCost;
    int area = getArea(recommendation);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      child: Card(
          child: Column(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(20), topEnd: Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              priorityContainer(context),
              statusContainer(context),
            ],
          ),
        ),
        Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: const BoxDecoration(
                //color: Colors.grey[800],
                borderRadius: const BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(20),
                    bottomEnd: Radius.circular(20))),
            child: Column(
              children: [
                billingRecommendationMainDetails(area),
                verticalSpacing(AppConstants.marginSmall),
                const Divider(
                  thickness: 1,
                ),
                verticalSpacing(AppConstants.marginSmall),
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: billingRecommendationCapexDetails(capex)),
              ],
            )),
      ])),
    );
  }

  // assignColorToRecStatus(BuildContext context) {
  //   switch (recommendation.currentStatus) {
  //     case BillingRecommendationStatusID.completedRec:
  //       return Theme.of(context).focusColor;
  //     case BillingRecommendationStatusID.deferredRec:
  //       return Theme.of(context).selectedRowColor;
  //     case BillingRecommendationStatusID.delayedRec:
  //       return Theme.of(context).errorColor;
  //     case BillingRecommendationStatusID.droppedRec:
  //       return Theme.of(context).colorScheme.surface;
  //     case BillingRecommendationStatusID.pendingRec:
  //       return Theme.of(context).toggleableActiveColor;
  //     case BillingRecommendationStatusID.progressRec:
  //       return Colors.indigo;
  //     case BillingRecommendationStatusID.newRec:
  //       return Colors.blue;
  //     default:
  //       return Colors.blueAccent;
  //   }
  // }

  priorityContainer(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        '${recommendation.recommendationPriority}',
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  statusContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          //color: assignColorToRecStatus(context),
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Text(
        getBillingRecommendationStatusFromInt(recommendation.currentStatus),
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onPrimary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  billingRecommendationMainDetails(int area) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(
        '${recommendation.numberOfCases} ${getBillingRecommendationTypeFromInt(recommendation.recommendationType)}',
        maxLines: 1,
        overflow: TextOverflow.fade,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 10.0,
      ),
      Text(
        '${getAreaNamefromInt(area)}, ${getBillingRecommendationCategoryFromInt(recommendation.recommendationCategory)}',
        style: const TextStyle(fontSize: 14),
      ),
    ]);
  }

  billingRecommendationCapexDetails(double capex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${recommendation.unitsLost} units lost',
          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        Text(
          'Capex - INR. $capex',
          style: const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  int getArea(BillingRecommendation recommendation) {
    int area = 0;
    debugPrint('Reco: ${recommendation.billingPerformance}');

    for (var i = 0; i < performances.length; i++) {
      debugPrint('Bill Perf : ${performances[i].id}');
      if (recommendation.billingPerformance == performances[i].id) {
        area = performances[i].area;
        break;
      }
    }
    return area;
  }
}
