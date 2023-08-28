import 'dart:math';
import 'package:fedco_mbc/Services/billingassignment_services.dart';
import 'package:fedco_mbc/Services/billingtask_services.dart';
import 'package:fedco_mbc/Services/user_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TeamCalendar extends StatefulWidget {
  const TeamCalendar({Key? key}) : super(key: key);

  @override
  State<TeamCalendar> createState() => _TeamCalendarState();
}

class _TeamCalendarState extends State<TeamCalendar> {
  Future<List<BillingAssignment>>? futureAssignments;
  Future<List<BillingTask>>? futureTasks;
  Future<List<User>>? futureUsers;

  List<BillingAssignment> assignments = List.empty(growable: true);
  List<BillingTask> tasks = List.empty(growable: true);
  List<User> users = List.empty(growable: true);

  bool allLoaded = false;

  final CalendarController _controller = CalendarController();
  //final Color _viewHeaderColor = Colors.blueGrey;
  //final Color _calendarColor = Colors.black;

  @override
  void initState() {
    futureAssignments = getAllBillingAssignments();
    futureTasks = getAllBillingTasks();
    futureUsers = getAllUsers();
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
            child: (!allLoaded) ? makeAssignmentBuilder() : makeCalendar()));
  }

  makeAssignmentBuilder() {
    return FutureBuilder(
      future: futureAssignments,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          assignments = snapshot.data as List<BillingAssignment>;
          return makeTaskBuilder();
        } else if (snapshot.hasError) {
          return SnackBar(content: Text('Error : ${snapshot.error}'));
        } else {
          return LoaderTransparent();
        }
      },
    );
  }

  makeTaskBuilder() {
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
              return makeUserBuilder();
            }
          default:
            break;
        }
        return Container();
      },
    );
  }

  makeUserBuilder() {
    return FutureBuilder(
      future: futureUsers,
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
              users = snapshot.data as List<User>;
              allLoaded = true;
              return makeCalendar();
            }

          default:
            break;
        }
        return Container();
      },
    );
  }

  makeCalendar() {
    return SfCalendar(
      view: CalendarView.timelineMonth,
      dataSource: AppointmentDataSource(getCalendarData(), getResourceData()),
      viewHeaderStyle: ViewHeaderStyle(
          //backgroundColor: _viewHeaderColor
          ),
      resourceViewSettings:
          ResourceViewSettings(displayNameTextStyle: TextStyle(fontSize: 16)),
      //backgroundColor: _calendarColor,
      controller: _controller,
      initialDisplayDate: DateTime.now(),
      timeSlotViewSettings:
          const TimeSlotViewSettings(startHour: 9, endHour: 20),
    );
  }

  findCalendarResources() {}

  List<Appointment> getCalendarData() {
    List<Appointment> appointments = [];

    for (var i = 0; i < tasks.length; i++) {
      String text = 'Dummy description';
      List<int> resources = [];
      for (var j = 0; j < assignments.length; j++) {
        if (assignments[j].billingTask == tasks[i].billingRecommendation) {
          text = tasks[i].description;
          resources.add(assignments[j].user);
        }
      }
      appointments.add(Appointment(
        resourceIds: resources,
        subject: text,
        startTime: assignments[i].plannedStartDate,
        endTime: assignments[i].plannedEndDate,
        isAllDay: true,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ));
    }
    return appointments;
  }

  List<CalendarResource> getResourceData() {
    List<User> calanderUsers = [];
    List<CalendarResource> resourceColl = [];
    List<int> calendarUsersID = getIDs();
    for (var i = 0; i < users.length; i++) {
      if (calendarUsersID.contains(users[i].id)) {
        calanderUsers.add(users[i]);
        CalendarResource resource = CalendarResource(
            id: users[i].id,
            displayName: users[i].userName,
            image: NetworkImage(users[i].userAvatar),
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)]);
        resourceColl.add(resource);
      }
    }
    return resourceColl;
  }

  getIDs() {
    List<int> calendarUsersID = [];
    for (var i = 0; i < assignments.length; i++) {
      if (!calendarUsersID.contains(assignments[i].user)) {
        calendarUsersID.add(assignments[i].user);
      }
    }
    return calendarUsersID;
  }
}
