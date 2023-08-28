// Defining model class for BillingAssignment:

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BillingAssignment {
  final int id;
  final int user;
  final int billingTask;
  final int incentive;
  final bool isVolunteered;
  final bool isAllDay;
  final String recurrenceRule;
  final DateTime plannedStartDate;
  final DateTime plannedEndDate;
  final DateTime actualStartDate;
  final DateTime actualEndDate;

  BillingAssignment({
    required this.id,
    required this.user,
    required this.billingTask,
    required this.incentive,
    required this.isVolunteered,
    required this.isAllDay,
    required this.recurrenceRule,
    required this.plannedStartDate,
    required this.plannedEndDate,
    required this.actualStartDate,
    required this.actualEndDate,
  });

  factory BillingAssignment.fromJson(Map<String, dynamic> json) =>
      BillingAssignmentFromJson(json);

  Map<String, dynamic> toJson() => _$BillingAssignmentToJson(this);

  static List<BillingAssignment> listFromJson(List<dynamic> list) =>
      List<BillingAssignment>.from(
          list.map((x) => BillingAssignment.fromJson(x)));
}

BillingAssignment BillingAssignmentFromJson(Map<String, dynamic> json) =>
    BillingAssignment(
      id: json['id'] as int,
      user: json['user'] as int,
      billingTask: json['billingTask'] as int,
      incentive: json['incentive'] as int,
      isVolunteered: json['isVolunteered'] as bool,
      isAllDay: json['isAllDay'] as bool,
      recurrenceRule: json['recurrenceRule'] as String,
      plannedStartDate: DateTime.parse(json['plannedStartDate'] as String),
      plannedEndDate: DateTime.parse(json['plannedEndDate'] as String),
      actualStartDate: DateTime.parse(json['actualStartDate'] as String),
      actualEndDate: DateTime.parse(json['actualEndDate'] as String),
    );

Map<String, dynamic> _$BillingAssignmentToJson(BillingAssignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'billingTask': instance.billingTask,
      'incentive': instance.incentive,
      'isVolunteered': instance.isVolunteered,
      'isAllDay': instance.isAllDay,
      'recurrenceRule': instance.recurrenceRule,
      'plannedStartDate': instance.plannedStartDate.toIso8601String(),
      'plannedEndDate': instance.plannedEndDate.toIso8601String(),
      'actualStartDate': instance.actualStartDate.toIso8601String(),
      'actualEndDate': instance.actualEndDate.toIso8601String(),
    };

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
