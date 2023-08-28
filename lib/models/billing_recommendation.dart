// Defining modal class for BillingRecommendation:

import 'dart:core';

class BillingRecommendation {
  //Identifiers
  final int id;
  final int billingPerformance;
  final DateTime recommendationDate;
  //Details of the BillingRecommendation
  final int recommendationPriority;
  final int numberOfCases;
  final int recommendationType;
  final int recommendationCategory;
  final int unitsLost;
  final double amountLost;
  // Capex related info
  final double meterCost;
  final double meterBoxCost;
  final double installationCost;
  final int paybackPeriodMonths;
  //current status
  final int currentStatus;

  BillingRecommendation({
    required this.id,
    required this.billingPerformance,
    required this.recommendationDate,
    required this.recommendationPriority,
    required this.numberOfCases,
    required this.recommendationType,
    required this.recommendationCategory,
    required this.unitsLost,
    required this.amountLost,
    required this.meterCost,
    required this.meterBoxCost,
    required this.installationCost,
    required this.paybackPeriodMonths,
    required this.currentStatus,
  });

  factory BillingRecommendation.fromJson(Map<String, dynamic> json) =>
      _$BillingRecommendationFromJson(json);

  Map<String, dynamic> toJson() => _$BillingRecommendationToJson(this);

  static List<BillingRecommendation> listFromJson(List<dynamic> list) =>
      List<BillingRecommendation>.from(
          list.map((x) => BillingRecommendation.fromJson(x)));
}

BillingRecommendation _$BillingRecommendationFromJson(
        Map<String, dynamic> json) =>
    BillingRecommendation(
      id: json['id'] as int,
      billingPerformance: json['billingPerformance'] as int,
      recommendationDate: DateTime.parse(json['recommendationDate'] as String),
      recommendationPriority: json['recommendationPriority'] as int,
      numberOfCases: json['numberOfCases'] as int,
      recommendationType: json['recommendationType'] as int,
      recommendationCategory: json['recommendationCategory'] as int,
      unitsLost: json['unitsLost'] as int,
      amountLost: double.tryParse(json['amountLost']) as double,
      meterCost: double.tryParse(json['meterCost']) as double,
      meterBoxCost: double.tryParse(json['meterBoxCost']) as double,
      installationCost: double.tryParse(json['installationCost']) as double,
      paybackPeriodMonths: json['paybackPeriodMonths'] as int,
      currentStatus: json['currentStatus'] as int,
    );

Map<String, dynamic> _$BillingRecommendationToJson(
        BillingRecommendation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'billingPerformance': instance.billingPerformance,
      'recommendationDate': instance.recommendationDate.toIso8601String(),
      'recommendationPriority': instance.recommendationPriority,
      'numberOfCases': instance.numberOfCases,
      'recommendationType': instance.recommendationType,
      'recommendationCategory': instance.recommendationCategory,
      'unitsLost': instance.unitsLost,
      'amountLost': instance.amountLost,
      'meterCost': instance.meterCost,
      'meterBoxCost': instance.meterBoxCost,
      'installationCost': instance.installationCost,
      'paybackPeriodMonths': instance.paybackPeriodMonths,
      'currentStatus': instance.currentStatus,
    };
