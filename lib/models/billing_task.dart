// Defining model class for BillingTask:
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BillingTask {
  final int billingRecommendation;
  final String description;
  final int createdBy;
  final DateTime createdDate;
  final int status;

  BillingTask({
    required this.billingRecommendation,
    required this.description,
    required this.createdBy,
    required this.createdDate,
    required this.status,
  });

  factory BillingTask.fromJson(Map<String, dynamic> json) =>
      _$BillingTaskFromJson(json);

  Map<String, dynamic> toJson() => _$BillingTaskToJson(this);

  static List<BillingTask> listFromJson(List<dynamic> list) =>
      List<BillingTask>.from(list.map((x) => BillingTask.fromJson(x)));
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(
      List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
  @override
  List<Object> getResourceIds(int index) {
    return appointments![index].ids;
  }
}

BillingTask _$BillingTaskFromJson(Map<String, dynamic> json) => BillingTask(
      billingRecommendation: json['billingRecommendation'] as int,
      description: json['description'] as String,
      createdBy: json['createdBy'] as int,
      createdDate: DateTime.parse(json['createdDate'] as String),
      status: json['status'] as int,
    );

Map<String, dynamic> _$BillingTaskToJson(BillingTask instance) =>
    <String, dynamic>{
      'billingRecommendation': instance.billingRecommendation,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate.toIso8601String(),
      'status': instance.status,
    };
