import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Trends/helper_models.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BillingEfficiency extends StatefulWidget {
  final List<BillingPerformance> filteredBilling;
  final int areaID;
  const BillingEfficiency(
      {Key? key, required this.filteredBilling, required this.areaID})
      : super(key: key);

  @override
  State<BillingEfficiency> createState() => _BillingEfficiencyState();
}

class _BillingEfficiencyState extends State<BillingEfficiency> {
  final controller = PageController();
  List<BillingEff> bill2019 = List.empty(growable: true);
  List<BillingEff> bill2020 = List.empty(growable: true);
  List<BillingEff> bill2021 = List.empty(growable: true);
  List<BillingEff> bill2022 = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    List<BillingPerformance> perf = widget.filteredBilling;
    Size size = MediaQuery.of(context).size;
    if (widget.areaID == AreaIDs.meghalaya) {
      for (var i = 0; i < perf.length; i++) {
        if (perf[i].area != AreaIDs.meghalaya) {
          perf.remove(perf[i]);
        }
      }
    }
    bill2019 = calculateBillingEfficiency(perf, 2019);
    bill2020 = calculateBillingEfficiency(perf, 2020);
    bill2021 = calculateBillingEfficiency(perf, 2021);
    bill2022 = calculateBillingEfficiency(perf, 2022);
    debugPrint(
        'GK3: ${bill2019[0].percentage}, ${bill2019[0].month}, ${bill2019[0].year} ');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Billing Efficiency',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: makePageView(size),
      ),
    );
  }

  Column makePageView(Size size) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.8,
          width: size.width * 0.9,
          child: PageView(
            controller: controller,
            children: [
              makeChart('${getAreaNamefromInt(widget.areaID)} 2022', bill2022),
              makeChart('${getAreaNamefromInt(widget.areaID)} 2021', bill2021),
              makeChart('${getAreaNamefromInt(widget.areaID)} 2020', bill2020),
              makeChart('${getAreaNamefromInt(widget.areaID)} 2019', bill2019),
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
            majorTickLines: const MajorTickLines(
                //color: Colors.transparent
                )),
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
}
