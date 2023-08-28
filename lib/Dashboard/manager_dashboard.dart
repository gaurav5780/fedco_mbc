import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:fedco_mbc/Dashboard/dashboard_tools.dart';
import 'package:fedco_mbc/Dashboard/nav_drawer.dart';
import 'package:fedco_mbc/ListViews/user_tile.dart';
import 'package:fedco_mbc/Recommendations/billingrecommendation_card.dart';
import 'package:fedco_mbc/Services/billingperformance_services.dart';
import 'package:fedco_mbc/Services/billingrecommendation_services.dart';
import 'package:fedco_mbc/Services/billingtask_services.dart';
import 'package:fedco_mbc/Services/user_services.dart';
import 'package:fedco_mbc/Trends/helper_models.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:fedco_mbc/models/billing_recommendation.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ManagerDashboard extends StatefulWidget {
  final User currentUser;
  const ManagerDashboard({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  // Declare future variables in the state:
  Future<List<BillingPerformance>>? performances;
  Future<List<User>>? users;
  Future<List<BillingRecommendation>>? recommendations;
  Future<List<BillingTask>>? futureTasks;
  // Flag for loading complete:
  bool loadingComplete = false;
  //Controller for PageView:
  final controller = PageController();
  //Empty lists to hold results from database query:
  List<BillingPerformance> perfList = List.empty(growable: true);
  List<User> usersList = List.empty(growable: true);
  List<BillingRecommendation> recommendationList = List.empty(growable: true);
  List<BillingTask> taskList = <BillingTask>[];

  //Empty lists for Area-wise filteration:
  List<BillingPerformance> filteredBilling = <BillingPerformance>[];
  List<BillingRecommendation> filteredRec = <BillingRecommendation>[];
  List<User> filteredUsers = <User>[];
  List<BillingTask> filteredTasks = <BillingTask>[];
  int areaID = AreaIDs.meghalaya;

  ///TODO: Make common heading styles in theme:
  get headingStyle => TextStyle(
      fontSize: AppConstants.largeFont,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary);

  @override
  void initState() {
    // Make data calls to the server in the Init state:
    users = getAllUsers();
    recommendations = getAllBillingRecommendations();
    performances = getAllBillingPerformances();
    futureTasks = getAllBillingTasks();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        '${getAreaNamefromInt(widget.currentUser.area)} Dashboard',
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
      body: (loadingComplete)
          ? makeDashboard(widget.currentUser)
          : makePerformanceFutureBuilder(widget.currentUser),
      drawer: NavDrawer(user: widget.currentUser),
    );
  }

  makePerformanceFutureBuilder(User currentUser) {
    return Center(
      child: FutureBuilder(
          future: performances,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              perfList = snapshot.data as List<BillingPerformance>;
              debugPrint(
                  'MakePerformanceFutureBuilder: ${snapshot.data.toString()}');
              return makeRecommendationBuilder(currentUser);
            } else if (snapshot.hasError) {
              return Text('MakePerformanceFutureBuilder: ${snapshot.error}');
            } else {
              return LoaderTransparent();
            }
          }),
    );
  }

  makeRecommendationBuilder(User currentUser) {
    return FutureBuilder(
        future: recommendations,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            recommendationList = snapshot.data as List<BillingRecommendation>;
            debugPrint('MakeRecommendationFutureBuilder: ${snapshot.data}');
            return makeTaskBuilder(currentUser);
          } else if (snapshot.hasError) {
            return Text('MakeRecommendationFutureBuilder: ${snapshot.error}');
          } else {
            return LoaderTransparent();
          }
        });
  }

  FutureBuilder makeTaskBuilder(User currentUser) {
    return FutureBuilder(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            taskList = snapshot.data as List<BillingTask>;
            debugPrint('MakeTaskFutureBuilder: ${snapshot.data}');
            return makeUserBuilder(currentUser);
          } else if (snapshot.hasError) {
            return Text('MakeTaskFutureBuilder: ${snapshot.error}');
          } else {
            return LoaderTransparent();
          }
        });
  }

  FutureBuilder makeUserBuilder(User currentUser) {
    return FutureBuilder(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            usersList = snapshot.data as List<User>;
            debugPrint('MakeUserFutureBuilder: ${snapshot.data}');
            loadingComplete = true;
            filterListIntoAreas(currentUser);
            return makeDashboard(currentUser);
          } else if (snapshot.hasError) {
            return Text('MakeUserFutureBuilder: ${snapshot.error}');
          } else {
            return LoaderTransparent();
          }
        });
  }

  void filterListIntoAreas(User thisUser) {
    // Filter Billing performances:
    for (var i = 0; i < perfList.length; i++) {
      if (perfList[i].area == thisUser.area) {
        filteredBilling.add(perfList[i]);
      }
    }
    // Filter Recommendations:
    for (var i = 0; i < recommendationList.length; i++) {
      for (var j = 0; j < filteredBilling.length; j++) {
        if (recommendationList[i].billingPerformance == filteredBilling[j].id) {
          filteredRec.add(recommendationList[i]);
        }
      }
    }
    // Filter Users:
    for (var i = 0; i < usersList.length; i++) {
      if (usersList[i].area == thisUser.area) {
        filteredUsers.add(usersList[i]);
      }
    }
    // Filter Tasks:
    for (var i = 0; i < taskList.length; i++) {
      for (var j = 0; j < filteredRec.length; j++) {
        if (taskList[i].billingRecommendation == filteredRec[j].id) {
          filteredTasks.add(taskList[i]);
        }
      }
    }
  }

  SingleChildScrollView makeDashboard(User currentUser) {
    filteredUsers
        .sort(((b, a) => a.userIncentiveScore.compareTo(b.userIncentiveScore)));
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(children: [
          makePageView(currentUser),
          makeHeading('Tasks in progress'),
          makeTaskList(),
          verticalSpacing(AppConstants.marginSmall),
          makeBigButton(
            currentUser,
            'See member-wise tasks',
            'tasks',
          ),
          makeHeading('Top recommendations'),
          makeTopRecommendations(currentUser),
          makeHeading('Top performers'),
          userTile(context, filteredUsers, 0),
          userTile(context, filteredUsers, 1),
          userTile(context, filteredUsers, 2),
          verticalSpacing(AppConstants.marginSmall),
          makeBigButton(
            currentUser,
            'See all top performers',
            'leaderboard',
          ),
          const Divider(
            thickness: 1,
          ),
          verticalSpacing(AppConstants.marginLarge),
        ]),
      ),
    );
  }

  Column makeTopRecommendations(User currentUser) {
    //int index = filteredRec.length;
    return Column(
      children: [
        makeRecCard(0, currentUser),
        makeRecCard(1, currentUser),
        makeRecCard(2, currentUser),
        verticalSpacing(AppConstants.marginSmall),
        makeBigButton(
          currentUser,
          'See all recommended actions',
          'recommendations',
        ),
      ],
    );
  }

  makeRecCard(int index, User currentUser) {
    debugPrint('Index: $index');
    return InkWell(
        onTap: () => PageNavigator.goToRecommendationDetail(
            context, filteredRec[index], currentUser, filteredBilling),
        child: BillingRecommendationCard(
          recommendation: filteredRec[index],
          performances: filteredBilling,
        ));
  }

  makeBillingEffWidget(String heading) {
    List<BillingEff> temp = calculateBillingEffDashboard(filteredBilling);
    List<BillingEff> billLatest = List.empty(growable: true);
    for (var i = 6; i > 0; i--) {
      billLatest.add(
        BillingEff(temp[temp.length - i].month, temp[temp.length - i].year,
            temp[temp.length - i].percentage),
      );
    }
    return Column(children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: SfCartesianChart(
              title: ChartTitle(text: heading),
              palette: chartPallette(context),
              isTransposed: true,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 1,
                  majorGridLines: const MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                  labelFormat: '{value}%',
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: MajorTickLines()),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<BillingEff, String>>[
                ColumnSeries<BillingEff, String>(
                    animationDuration: 1500,
                    // Binding list data to the chart.
                    dataSource: billLatest,
                    xValueMapper: (BillingEff percent, _) => percent.month,
                    yValueMapper: (BillingEff percent, _) => percent.percentage,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    xAxisName: 'Months',
                    yAxisName: 'Efficiency'),
              ]),
        ),
      ),
      verticalSpacing(AppConstants.marginSmall),
      ElevatedButton(
        onPressed: () {
          PageNavigator.goToBillingEfficiency(context, filteredBilling, areaID);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('See more'),
            Icon(Icons.arrow_circle_right_sharp)
          ],
        ),
      )
    ]);
  }

  makeDoughnutWidget(
      String heading, List<CircularSeries<dynamic, dynamic>>? series) {
    return Column(children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: SfCircularChart(
            title: ChartTitle(text: heading),
            palette: chartPallette(context),
            legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap),
            series: series,
          ),
        ),
      ),
      verticalSpacing(AppConstants.marginSmall),
      ElevatedButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('See more'),
            Icon(Icons.arrow_circle_right_sharp)
          ],
        ),
      )
    ]);
  }

  makeHeading(String heading) {
    return Column(
      children: [
        verticalSpacing(AppConstants.marginSmall),
        const Divider(
          thickness: 1,
        ),
        verticalSpacing(AppConstants.marginSmall),
        Text(
          heading,
          style: headingStyle,
        ),
        verticalSpacing(AppConstants.marginSmall),
        const Divider(
          thickness: 1,
        ),
        verticalSpacing(AppConstants.marginSmall),
      ],
    );
  }

  makePageView(User currentUser) {
    return Column(
      children: [
        verticalSpacing(AppConstants.marginSmall),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: PageView(
            controller: controller,
            children: [
              makeBillingEffWidget('Billing Efficiency'),
              makeDoughnutWidget(
                  'Billing statistics - ${DateFormat('MMM').format(DateTime(0, filteredBilling.last.performanceMonth))}, ${filteredBilling.last.performanceYear}',
                  getBillStatisticsseries(getBillStatistics(filteredBilling))),
              makePerformanceWidget(
                  'Reading issues', DashboardConstants.readingInaccuracies),
              makePerformanceWidget(
                  'Stopped meter cases', DashboardConstants.stoppedMeter),
              makePerformanceWidget(
                  'No meter cases', DashboardConstants.noMeter),
              makePerformanceWidget('Billed on Actual reading',
                  DashboardConstants.billedOnActualReading),
              makeDoughnutWidget(
                  'Consumer statistics - ${DateFormat('MMM').format(DateTime(0, filteredBilling.last.performanceMonth))}, ${filteredBilling.last.performanceYear}',
                  getBillStatisticsseries(
                      getConsumerStatistics(filteredBilling))),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: controller,
          count: 7,
          effect: ExpandingDotsEffect(
              activeDotColor: Theme.of(context).colorScheme.primary,
              dotColor: Theme.of(context).colorScheme.onInverseSurface),
        ),
      ],
    );
  }

  List<BillStatistics> getBillStatistics(List<BillingPerformance> performance) {
    return [
      BillStatistics('Actual Reading', performance.last.billedOnActualReading),
      BillStatistics('Reading issues', performance.last.readingInaccuracies),
      BillStatistics('No meters', performance.last.noMeter),
      BillStatistics('Stopped meters', performance.last.stoppedMeter),
    ];
  }

  List<BillStatistics> getConsumerStatistics(
      List<BillingPerformance> performance) {
    return [
      BillStatistics('Live consumers', performance.last.liveConsumers),
      BillStatistics('PD consumers', performance.last.pdConsumers),
      BillStatistics('TD consumers', performance.last.tdConsumers),
    ];
  }

  makeBigButton(User currentUser, String label, String requirement) {
    return ElevatedButton(
      onPressed: () {
        switch (requirement) {
          case 'tasks':
            PageNavigator.goToTaskList(context);
            break;
          case 'leaderboard':
            PageNavigator.goToLeaderBoard(context);
            break;
          case 'recommendations':
            PageNavigator.goToRecommendationList(context, currentUser);
            break;
          default:
            break;
        }
      },
      child: Container(
        margin: const EdgeInsets.all(AppConstants.marginSmall),
        padding: const EdgeInsets.all(AppConstants.paddingSmall),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            label,
          ),
          CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.arrow_forward)),
        ]),
      ),
    );
  }

  Widget showTopUsers(BuildContext context) {
    if (filteredUsers.isEmpty) {
      return const Text('Oops. No team members here.');
    } else {
      filteredUsers.sort(
          ((b, a) => a.userIncentiveScore.compareTo(b.userIncentiveScore)));

      return Column(
        children: [
          makeUserList(context, 0, filteredUsers),
          makeUserList(context, 1, filteredUsers),
          makeUserList(context, 2, filteredUsers),
        ],
      );
    }
  }

  makePerformanceWidget(String label, int type) {
    List<BillingIssues> temp =
        calculateBillingIssuesDashboard(filteredBilling, type);
    List<BillingIssues> billIssues = List.empty(growable: true);
    for (var i = 6; i > 0; i--) {
      billIssues.add(
        BillingIssues(temp[temp.length - i].month, temp[temp.length - i].year,
            temp[temp.length - i].cases),
      );
    }
    return Column(children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: SfCartesianChart(
              title: ChartTitle(text: label),
              palette: chartPallette(context),
              isTransposed: true,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 1,
                  majorGridLines: const MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                  //labelFormat: '{value}',
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(
                      //color: Colors.transparent
                      )),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<BillingIssues, String>>[
                ColumnSeries<BillingIssues, String>(
                    animationDuration: 1500,
                    // Binding list data to the chart.
                    dataSource: billIssues,
                    xValueMapper: (BillingIssues data, _) => data.month,
                    yValueMapper: (BillingIssues data, _) => data.cases,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    xAxisName: 'Months',
                    yAxisName: 'No. of cases'),
              ]),
        ),
      ),
      verticalSpacing(AppConstants.marginSmall),
      ElevatedButton(
        onPressed: () {
          PageNavigator.goToBillingEfficiency(context, filteredBilling, areaID);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('See more'),
            Icon(Icons.arrow_circle_right_sharp)
          ],
        ),
      )
    ]);
  }

  makeTaskList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    '${(index + 1)}',
                  ),
                ),
                title: Text(filteredTasks[index].description),
                trailing: CircularPercentIndicator(
                  progressColor: Theme.of(context).colorScheme.primary,
                  center: Text('${filteredTasks[index].status} %'),
                  animation: true,
                  radius: AppConstants.imageRadiusMedium,
                  percent: double.parse(
                    '${filteredTasks[index].status / 100}',
                  ),
                )),
          ),
        );
      },
    );
  }
}

makeUserList(BuildContext context, int index, List<User> usersList) {
  return Padding(
    padding: const EdgeInsets.all(AppConstants.paddingSmall),
    child: Card(
      child: ListTile(
        //tileColor: Colors.grey[800],
        leading: CircleAvatar(
          radius: AppConstants.imageRadiusSmall,
          backgroundImage: NetworkImage(usersList[index].userAvatar),
        ),
        title: Text(usersList[index].userName),
        subtitle: Text(getUserLevelFromInt(usersList[index].userLevel)),
        trailing: Text(
          '${usersList[index].userIncentiveScore}',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        onTap: () {
          PageNavigator.goToProfileScreen(context, usersList[index]);
        },
      ),
    ),
  );
}

getBillStatisticsseries(List<BillStatistics> statistics) {
  return <CircularSeries>[
    // Renders doughnut chart for the previous month data (Billing or Consumer)
    DoughnutSeries<BillStatistics, String>(
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
        ),
        dataSource: statistics,
        //pointColorMapper:(ChartData data,  _) => data.color,
        xValueMapper: (BillStatistics data, _) => data.attribute,
        yValueMapper: (BillStatistics data, _) => data.value)
  ];
}
