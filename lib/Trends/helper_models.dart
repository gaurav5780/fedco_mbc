import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillingEff {
  BillingEff(
    this.month,
    this.year,
    this.percentage,
  );
  String month;
  int year;
  double percentage;
}

// Calculate last 6 - months Billing Efficiency for Dashboard:

List<BillingEff> calculateBillingEffDashboard(
    List<BillingPerformance> performance) {
  List<BillingEff> bf = List.empty(growable: true);
  for (int i = 0; i < performance.length; i++) {
    double frac =
        (performance[i].billedEnergy * 100) / performance[i].inputEnergy;
    double percent = double.parse(frac.toStringAsFixed(1));
    String month =
        DateFormat('MMM').format(DateTime(0, performance[i].performanceMonth));
    String monthYear = '$month, ${performance[i].performanceYear}';
    bf.add(BillingEff(monthYear, performance[i].performanceYear, percent));
  }
  return bf;
}

// Calculate Billing Issues for detailed trends page:

List<BillingEff> calculateBillingEfficiency(
    List<BillingPerformance> performance, int year) {
  List<BillingEff> bf = List.empty(growable: true);
  for (int i = 0; i < performance.length; i++) {
    if (performance[i].performanceYear == year) {
      double frac =
          (performance[i].billedEnergy * 100) / performance[i].inputEnergy;
      double percent = double.parse(frac.toStringAsFixed(1));
      String month = DateFormat('MMM')
          .format(DateTime(0, performance[i].performanceMonth));
      bf.add(BillingEff(month, performance[i].performanceYear, percent));
    }
  }
  return bf;
}

// For trend of Stopped Meter, No meter, Reading error cases:

class BillingIssues {
  BillingIssues(
    this.month,
    this.year,
    this.cases,
  );
  String month;
  int year;
  int cases;
}

// Calculate last 6 - months BillingIssues for Dashboard:

List<BillingIssues> calculateBillingIssuesDashboard(
    List<BillingPerformance> performance, int issueType) {
  List<BillingIssues> bi = List.empty(growable: true);
  int cases = 0;
  String month = '';
  String monthYear = '';
  for (int i = 0; i < performance.length; i++) {
    switch (issueType) {
      case DashboardConstants.billedOnActualReading:
        cases = performance[i].billedOnActualReading;
        break;
      case DashboardConstants.readingInaccuracies:
        cases = performance[i].readingInaccuracies;
        break;
      case DashboardConstants.noMeter:
        cases = performance[i].noMeter;
        break;
      case DashboardConstants.stoppedMeter:
        cases = performance[i].stoppedMeter;
        break;
      default:
        break;
    }
    month =
        DateFormat('MMM').format(DateTime(0, performance[i].performanceMonth));
    monthYear = '$month, ${performance[i].performanceYear}';
    bi.add(BillingIssues(monthYear, performance[i].performanceYear, cases));
  }
  return bi;
}

// Calculate Billing Issues for detailed trends page:

List<BillingIssues> calculateBillingIssues(
    List<BillingPerformance> performance, int year, int issueType) {
  List<BillingIssues> bi = List.empty(growable: true);
  int cases = 0;
  String month = '';
  for (int i = 0; i < performance.length; i++) {
    if (performance[i].performanceYear == year) {
      switch (issueType) {
        case DashboardConstants.billedOnActualReading:
          cases = performance[i].billedOnActualReading;
          break;
        case DashboardConstants.readingInaccuracies:
          cases = performance[i].readingInaccuracies;
          break;
        case DashboardConstants.noMeter:
          cases = performance[i].noMeter;
          break;
        case DashboardConstants.stoppedMeter:
          cases = performance[i].stoppedMeter;
          break;
        default:
          break;
      }
      month = DateFormat('MMM')
          .format(DateTime(0, performance[i].performanceMonth));
      bi.add(BillingIssues(month, performance[i].performanceYear, cases));
    }
  }
  return bi;
}

// Color Pallette for Charts:

chartPallette(BuildContext context) {
  return <Color>[
    Theme.of(context).colorScheme.surfaceTint,
    Theme.of(context).colorScheme.tertiary,
    Theme.of(context).colorScheme.onErrorContainer,
    Theme.of(context).colorScheme.inverseSurface,
    Theme.of(context).colorScheme.onSurface,
    Theme.of(context).colorScheme.onBackground,
    Theme.of(context).colorScheme.onError,
    Theme.of(context).colorScheme.onSurfaceVariant,
    Theme.of(context).colorScheme.secondary,
  ];
}
