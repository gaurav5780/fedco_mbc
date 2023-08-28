import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Constants/billingrecommendation_constants.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:fedco_mbc/models/billing_recommendation.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';

class RecommendationDetail extends StatelessWidget {
  final BillingRecommendation recommendation;
  final User thisUser;
  final List<BillingPerformance> performance;
  const RecommendationDetail({
    Key? key,
    required this.recommendation,
    required this.thisUser,
    required this.performance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final capex = recommendation.meterCost +
        recommendation.meterBoxCost +
        recommendation.installationCost;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Priority ${recommendation.recommendationPriority}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius:
                            BorderRadius.circular(AppConstants.cardRadius)),
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${recommendation.numberOfCases}',
                          style: const TextStyle(
                              fontSize: AppConstants.xlFont,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text('Cases'),
                      ],
                    ),
                  ),
                  horizontalSpacing(AppConstants.marginLarge),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        padding:
                            const EdgeInsets.all(AppConstants.paddingLarge),
                        child: Column(
                          children: [
                            Text(
                              '${getBillingRecommendationTypeFromInt(recommendation.recommendationType)} in ${getAreaName(recommendation.billingPerformance, performance)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${getBillingRecommendationCategoryFromInt(recommendation.recommendationCategory)} totalling loss of INR. ${recommendation.amountLost} per month',
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
            verticalSpacing(AppConstants.marginSmall),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius)),
              margin: const EdgeInsets.all(AppConstants.marginLarge),
              padding: const EdgeInsets.all(AppConstants.marginLarge),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacing(AppConstants.marginLarge),
                    Text(
                      '${recommendation.paybackPeriodMonths} months payback period',
                    ),
                    verticalSpacing(AppConstants.marginLarge),
                    const Divider(
                      thickness: 1,
                    ),
                    verticalSpacing(AppConstants.marginLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Meter cost'),
                        Text('INR ${recommendation.meterCost.toString()}'),
                      ],
                    ),
                    verticalSpacing(AppConstants.marginLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Meter boxes'),
                        Text('INR ${recommendation.meterBoxCost.toString()}'),
                      ],
                    ),
                    verticalSpacing(AppConstants.marginSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Installation cost'),
                        Text(
                            'INR ${recommendation.installationCost.toString()}'),
                      ],
                    ),
                    verticalSpacing(AppConstants.marginSmall),
                    const Divider(
                      thickness: 1,
                    ),
                    verticalSpacing(AppConstants.marginSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total cost',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'INR $capex',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ]),
            ),
            verticalSpacing(AppConstants.marginLarge),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  PageNavigator.goToAssignTask(
                      context, recommendation, performance, thisUser);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                child: const Text(
                  'Assign actions',
                ),
              ),
            ),
            verticalSpacing(AppConstants.marginLarge),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                child: const Text(
                  'Defer to next month',
                ),
              ),
            ),
            verticalSpacing(AppConstants.marginLarge),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Ignore and remove',
                ),
                style: ElevatedButton.styleFrom(
                    //primary: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  getAreaName(int billingPerformance, List<BillingPerformance> perf) {
    int area = AreaIDs.meghalaya;
    for (var i = 0; i < perf.length; i++) {
      if (perf[i].id == billingPerformance) {
        area = perf[i].area;
        break;
      }
    }
    return getAreaNamefromInt(area);
  }
}
