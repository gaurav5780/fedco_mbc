import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Constants/billingrecommendation_constants.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/billing_recommendation.dart';

class AssignTask extends StatefulWidget {
  final BillingRecommendation recommendation;
  final List<BillingPerformance> performances;
  final User thisUser;
  const AssignTask(
      {Key? key,
      required this.recommendation,
      required this.performances,
      required this.thisUser})
      : super(key: key);

  @override
  State<AssignTask> createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  double incentiveScore = AppConstants.defaultIncentive;
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      end: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: 5)));

  @override
  void dispose() {
    descriptionController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    String area = findArea(widget.recommendation, widget.performances);
    DateTime start = dateRange.start;
    DateTime end = dateRange.end;
    fromDateController.text = DateFormat('dd-MMM-yyyy').format(start);
    toDateController.text = DateFormat('dd-MMM-yyyy').format(end);
    descriptionController.text =
        'Rectify ${widget.recommendation.numberOfCases} ${getBillingRecommendationTypeFromInt(widget.recommendation.recommendationType)} in $area';
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Assign task to team',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: SingleChildScrollView(
          child: Column(
        children: [
          makeTopDetail(widget.recommendation, area),
          Container(
            padding: const EdgeInsets.all(AppConstants.marginLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STEP 1 - Add a description:',
                  style: TextStyle(fontSize: 16),
                ),
                verticalSpacing(AppConstants.marginLarge),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Task description',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary))),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                verticalSpacing(AppConstants.marginLarge),
                const Divider(thickness: 1.0),
                verticalSpacing(AppConstants.marginLarge),
                const Text(
                  'STEP 2 - Add time period:',
                  style: TextStyle(fontSize: 16),
                ),
                verticalSpacing(AppConstants.marginLarge),
                TextFormField(
                  onTap: makeDateRangePicker,
                  keyboardType: TextInputType.none,
                  controller: fromDateController,
                  decoration: InputDecoration(
                      labelText: 'From date',
                      suffixIcon: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.calendar_month_rounded)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary))),
                  style: const TextStyle(fontSize: 18),
                ),
                verticalSpacing(AppConstants.marginLarge),
                TextFormField(
                  onTap: makeDateRangePicker,
                  keyboardType: TextInputType.none,
                  controller: toDateController,
                  decoration: InputDecoration(
                      labelText: 'To date',
                      suffixIcon: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.calendar_month_rounded)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary))),
                  style: const TextStyle(fontSize: 18),
                ),
                verticalSpacing(AppConstants.marginLarge),
                Divider(
                  thickness: 1.0,
                ),
                verticalSpacing(AppConstants.marginLarge),
                const Text(
                  'STEP 3 - Offer incentive points:',
                  style: TextStyle(fontSize: 16),
                ),
                verticalSpacing(AppConstants.marginLarge),
                Slider(
                  value: incentiveScore,
                  divisions: 9,
                  onChanged: onChanged,
                  max: 100,
                  min: 10,
                  label: incentiveScore.round().toString(),
                ),
                verticalSpacing(AppConstants.marginLarge),
                Divider(
                  thickness: 1.0,
                ),
                verticalSpacing(AppConstants.marginLarge),
                const Text(
                  'STEP 4 - Assign team members:',
                  style: TextStyle(fontSize: 16),
                ),
                verticalSpacing(AppConstants.marginLarge),
                Divider(
                  thickness: 1.0,
                ),
                verticalSpacing(AppConstants.marginLarge),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      onPressed: () {
                        onPressed(widget.thisUser, widget.recommendation, area);
                      },
                      child: const Text(
                        'Choose members',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  makeTopDetail(BillingRecommendation? recommendation, String area) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(AppConstants.cardRadius)),
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${recommendation!.numberOfCases}',
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
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    Text(
                      '${getBillingRecommendationTypeFromInt(recommendation.recommendationType)} in ${findArea(recommendation, widget.performances)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${getBillingRecommendationCategoryFromInt(recommendation.recommendationCategory)} totalling loss of INR. ${recommendation.amountLost} per month',
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future makeDateRangePicker() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(2019),
        lastDate: DateTime(2025));
    if (newDateRange == null) {
      return;
    }
    setState(() {
      dateRange = newDateRange;
    });
  }

  void onChanged(double value) {
    setState(() {
      incentiveScore = value;
    });
  }

  void onPressed(User user, BillingRecommendation recommendation, String area) {
    BillingTask task = BillingTask(
      billingRecommendation: recommendation.id,
      description: descriptionController.text.toString(),
      createdBy: user.id,
      createdDate: DateTime.now(),
      status: 0,
    );
    debugPrint(
        'billingRecommendation: ${recommendation.id}, description: ${descriptionController.text.toString()}, createdBy: ${user.id}, createdDate: DateTime.now(), status: 0');
    BillingAssignment assignment = BillingAssignment(
        id: 0,
        user: 0,
        billingTask: recommendation.id,
        incentive: int.parse(incentiveScore.round().toString()),
        isVolunteered: false,
        isAllDay: true,
        recurrenceRule: 'recurrenceRule',
        plannedStartDate: dateRange.start,
        plannedEndDate: dateRange.end,
        actualStartDate: dateRange.start,
        actualEndDate: dateRange.end);
    PageNavigator.goToSelectTeam(
        context, task, assignment, user, area, recommendation);
  }

  String findArea(BillingRecommendation recommendation,
      List<BillingPerformance> performances) {
    int area = 0;
    for (var i = 0; i < performances.length; i++) {
      if (performances[i].id == recommendation.billingPerformance) {
        area = performances[i].area;
        break;
      }
    }
    return getAreaNamefromInt(area);
  }
}
