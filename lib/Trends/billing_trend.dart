import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Services/billingperformance_services.dart';
import 'package:fedco_mbc/Trends/helper_models.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BillingTrend extends StatefulWidget {
  final User thisUser;
  const BillingTrend({Key? key, required this.thisUser}) : super(key: key);

  @override
  State<BillingTrend> createState() => _BillingTrendState();
}

class _BillingTrendState extends State<BillingTrend> {
  Future<List<BillingPerformance>>? futurePerf;
  List<BillingPerformance> performances = [];
  List<BillingPerformance> meghalaya = [];
  List<BillingPerformance> mawsynram = [];
  List<BillingPerformance> nongalbibra = [];
  List<BillingPerformance> filtered = [];
  final controller = PageController();
  List<BillingEff> bill2019 = [];
  List<BillingEff> bill2020 = [];
  List<BillingEff> bill2021 = [];
  List<BillingEff> bill2022 = [];
  bool isLoaded = false;
  int areaID = 0;
  get headingStyle => TextStyle(
      fontSize: AppConstants.largeFont,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onPrimaryContainer);
  @override
  void initState() {
    futurePerf = getAllBillingPerformances();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int initialValue = AreaIDs.meghalaya;
    if (widget.thisUser.area == AreaIDs.mawsynram) {
      initialValue = AreaIDs.mawsynram;
    }
    if (widget.thisUser.area == AreaIDs.nongalbibra) {
      initialValue = AreaIDs.nongalbibra;
    }
    areaID = initialValue;
    return Scaffold(
      appBar: AppBar(
        title: DropdownButtonFormField(
          value: initialValue,
          style: headingStyle,
          items: menuItems(),
          //When dropdown changes, the dashboard values should change:
          onChanged: onChanged,
        ),
      ),
      body: Center(
        child: (isLoaded) ? makePageView(size) : makeFuture(size),
      ),
    );
  }

  menuItems() {
    return [
      const DropdownMenuItem(
        value: AreaIDs.meghalaya,
        child: Text(
          AreasNames.meghalaya,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const DropdownMenuItem(
        value: AreaIDs.mawsynram,
        child: Text(AreasNames.mawsynram),
      ),
      const DropdownMenuItem(
        value: AreaIDs.nongalbibra,
        child: Text(AreasNames.nongalbibra),
      ),
    ];
  }

  onChanged(Object? value) {
    debugPrint(value.toString());
    setState(() {
      switch (value) {
        case AreaIDs.meghalaya:
          filtered = meghalaya;
          areaID = AreaIDs.meghalaya;
          break;
        case AreaIDs.mawsynram:
          filtered = mawsynram;
          areaID = AreaIDs.mawsynram;
          break;
        case AreaIDs.nongalbibra:
          filtered = nongalbibra;
          areaID = AreaIDs.nongalbibra;
          break;
        default:
          break;
      }
    });
    debugPrint('Selection: ${filtered.last.area}');
    bill2019 = calculateBillingEfficiency(filtered, 2019);
    bill2020 = calculateBillingEfficiency(filtered, 2020);
    bill2021 = calculateBillingEfficiency(filtered, 2021);
    bill2022 = calculateBillingEfficiency(filtered, 2022);
  }

  makeFuture(Size size) {
    return FutureBuilder(
      future: futurePerf,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          performances = snapshot.data as List<BillingPerformance>;
          filterListIntoAreas();
          bill2019 = calculateBillingEfficiency(filtered, 2019);
          bill2020 = calculateBillingEfficiency(filtered, 2020);
          bill2021 = calculateBillingEfficiency(filtered, 2021);
          bill2022 = calculateBillingEfficiency(filtered, 2022);
          isLoaded = true;
          return makePageView(size);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  makePageView(Size size) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.8,
          width: size.width * 0.9,
          child: PageView(
            controller: controller,
            children: [
              makeChart('Billing Efficiency 2022', bill2022),
              makeChart('Billing Efficiency 2021', bill2021),
              makeChart('Billing Efficiency 2020', bill2020),
              makeChart('Billing Efficiency 2019', bill2019),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: controller,
          count: 4,
          effect: ExpandingDotsEffect(
              activeDotColor: Theme.of(context).colorScheme.primary,
              dotColor: Theme.of(context).colorScheme.inversePrimary),
        ),
      ],
    );
  }

  makeChart(String label, List<BillingEff> bill) {
    debugPrint('End result: ${bill.length}');
    return SfCartesianChart(
        title: ChartTitle(text: label),
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
            majorTickLines: const MajorTickLines()),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<BillingEff, String>>[
          ColumnSeries<BillingEff, String>(
              animationDuration: 1500,
              // Binding list data to the chart.
              dataSource: bill,
              xValueMapper: (BillingEff percent, _) => percent.month,
              yValueMapper: (BillingEff percent, _) => percent.percentage,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xAxisName: 'Months',
              yAxisName: 'Efficiency'),
        ]);
  }

  void filterListIntoAreas() {
    filtered = performances;
    mawsynram = performances.where((o) => o.area == AreaIDs.mawsynram).toList();
    nongalbibra =
        performances.where((o) => o.area == AreaIDs.nongalbibra).toList();
    //meghalaya = mawsynram + nongalbibra;
    if (mawsynram.length == nongalbibra.length) {
      for (int i = 0; i < mawsynram.length; i++) {
        meghalaya.add(BillingPerformance(
            id: mawsynram[i].id +
                nongalbibra[i].id +
                mawsynram.length +
                nongalbibra.length,
            area: AreaIDs.meghalaya,
            performanceYear: mawsynram[i].performanceYear,
            performanceMonth: mawsynram[i].performanceMonth,
            totalConsumers:
                mawsynram[i].totalConsumers + nongalbibra[i].totalConsumers,
            liveConsumers:
                mawsynram[i].liveConsumers + nongalbibra[i].liveConsumers,
            pdConsumers: mawsynram[i].pdConsumers + nongalbibra[i].pdConsumers,
            tdConsumers: mawsynram[i].tdConsumers + nongalbibra[i].tdConsumers,
            billedOnActualReading: mawsynram[i].billedOnActualReading +
                nongalbibra[i].billedOnActualReading,
            readingInaccuracies: mawsynram[i].readingInaccuracies +
                nongalbibra[i].readingInaccuracies,
            noMeter: mawsynram[i].noMeter + nongalbibra[i].noMeter,
            stoppedMeter:
                mawsynram[i].stoppedMeter + nongalbibra[i].stoppedMeter,
            inputEnergy: mawsynram[i].inputEnergy + nongalbibra[i].inputEnergy,
            billedEnergy:
                mawsynram[i].billedEnergy + nongalbibra[i].billedEnergy));
      }
      for (var i = 0; i < meghalaya.length; i++) {
        if (meghalaya[i].area != AreaIDs.meghalaya) {
          debugPrint('removed from meghalaya: ${meghalaya[i].area}');
          meghalaya.remove(meghalaya[i]);
        }
      }
    } else {
      debugPrint('The list lengths dont match');
    }
    debugPrint('Meghalaya: ${meghalaya.length}');
    debugPrint('Mawsynram: ${mawsynram.length}');
    debugPrint('Nongalbibra: ${nongalbibra.length}');
  }
}
