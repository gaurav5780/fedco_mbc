import 'dart:math';
import 'package:fedco_mbc/Services/billingassignment_services.dart';
import 'package:fedco_mbc/Services/billingtask_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Future<List<BillingAssignment>>? futureAssignments;
  Future<List<BillingTask>>? futureTasks;

  List<BillingAssignment> assignments = List.empty(growable: true);
  List<BillingTask> tasks = List.empty(growable: true);

  bool assignmentsLoaded = false;
  bool tasksLoaded = false;

  final CalendarController _controller = CalendarController();
  //final Color _viewHeaderColor = Colors.blueGrey;
  //final Color _calendarColor = Colors.black;

  @override
  void initState() {
    futureAssignments = getAllBillingAssignments();
    futureTasks = getAllBillingTasks();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Workforce Calendar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
            //child: (!assignmentsLoaded) ? makeCalendar() : makeFutureBuilder()),
            child: (!tasksLoaded) ? makeFutureBuilder() : makeCalendar()));
  }

  makeFutureBuilder() {
    return FutureBuilder(
      future: futureAssignments,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          assignments = snapshot.data as List<BillingAssignment>;
          assignmentsLoaded = true;
          return makeAnotherFutureBuilder();
        } else if (snapshot.hasError) {
          return SnackBar(content: Text('Error : ${snapshot.error}'));
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  makeCalendar() {
    return SfCalendar(
      view: CalendarView.month,
      dataSource: MeetingDataSource(getCalendarData()),
      allowedViews: const [
        CalendarView.schedule,
        CalendarView.month,
        CalendarView.timelineMonth,
        CalendarView.timelineWeek,
      ],
      scheduleViewSettings: ScheduleViewSettings(hideEmptyScheduleWeek: true),
      // viewHeaderStyle: ViewHeaderStyle(
      //     //backgroundColor: _viewHeaderColor
      //     ),
      //backgroundColor: _calendarColor,
      controller: _controller,
      initialDisplayDate: DateTime.now(),
      onTap: calendarTapped,
      monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          navigationDirection: MonthNavigationDirection.vertical,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      timeSlotViewSettings:
          const TimeSlotViewSettings(startHour: 9, endHour: 20),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }
  }

  List<Meeting> getCalendarData() {
    List<Meeting> meetings = List.empty(growable: true);
    for (var i = 0; i < assignments.length; i++) {
      String text = 'Dummy descripyion';
      for (var j = 0; j < tasks.length; j++) {
        if (assignments[i].billingTask == tasks[j].billingRecommendation) {
          text = tasks[j].description;
        }
      }
      meetings.add(Meeting(
          text,
          assignments[i].plannedStartDate,
          assignments[i].plannedEndDate,
          Colors.primaries[Random().nextInt(Colors.primaries.length)],
          true));
    }
    return meetings;
  }

  makeAnotherFutureBuilder() {
    return FutureBuilder(
      future: futureTasks,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoaderTransparent();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error : ${snapshot.error}');
            } else {
              tasks = snapshot.data as List<BillingTask>;
              tasksLoaded = true;
              return makeCalendar();
            }

          default:
            break;
        }
        return Container();
      },
    );
  }
}
