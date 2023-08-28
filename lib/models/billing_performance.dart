// Defining modal class for BillingPerformance:

class BillingPerformance {
  int id;
  int area;
  int performanceYear;
  int performanceMonth;
  int totalConsumers;
  int liveConsumers;
  int pdConsumers;
  int tdConsumers;
  int billedOnActualReading;
  int readingInaccuracies;
  int noMeter;
  int stoppedMeter;
  int inputEnergy;
  int billedEnergy;

  BillingPerformance({
    required this.id,
    required this.area,
    required this.performanceYear,
    required this.performanceMonth,
    required this.totalConsumers,
    required this.liveConsumers,
    required this.pdConsumers,
    required this.tdConsumers,
    required this.billedOnActualReading,
    required this.readingInaccuracies,
    required this.noMeter,
    required this.stoppedMeter,
    required this.inputEnergy,
    required this.billedEnergy,
  });
  factory BillingPerformance.fromJson(Map<String, dynamic> json) =>
      _$BillingPerformanceFromJson(json);

  Map<String, dynamic> toJson() => _$BillingPerformanceToJson(this);

  static List<BillingPerformance> listFromJson(List<dynamic> list) =>
      List<BillingPerformance>.from(
          list.map((x) => BillingPerformance.fromJson(x)));
}

BillingPerformance _$BillingPerformanceFromJson(Map<String, dynamic> json) =>
    BillingPerformance(
      id: json['id'] as int,
      area: json['area'] as int,
      performanceYear: json['performanceYear'] as int,
      performanceMonth: json['performanceMonth'] as int,
      totalConsumers: json['totalConsumers'] as int,
      liveConsumers: json['liveConsumers'] as int,
      pdConsumers: json['pdConsumers'] as int,
      tdConsumers: json['tdConsumers'] as int,
      billedOnActualReading: json['billedOnActualReading'] as int,
      readingInaccuracies: json['readingInaccuracies'] as int,
      noMeter: json['noMeter'] as int,
      stoppedMeter: json['stoppedMeter'] as int,
      inputEnergy: json['inputEnergy'] as int,
      billedEnergy: json['billedEnergy'] as int,
    );

Map<String, dynamic> _$BillingPerformanceToJson(BillingPerformance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'area': instance.area,
      'performanceYear': instance.performanceYear,
      'performanceMonth': instance.performanceMonth,
      'totalConsumers': instance.totalConsumers,
      'liveConsumers': instance.liveConsumers,
      'pdConsumers': instance.pdConsumers,
      'tdConsumers': instance.tdConsumers,
      'billedOnActualReading': instance.billedOnActualReading,
      'readingInaccuracies': instance.readingInaccuracies,
      'noMeter': instance.noMeter,
      'stoppedMeter': instance.stoppedMeter,
      'inputEnergy': instance.inputEnergy,
      'billedEnergy': instance.billedEnergy,
    };
