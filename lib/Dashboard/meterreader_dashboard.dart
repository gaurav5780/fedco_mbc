import 'package:fedco_mbc/Dashboard/dashboard_tools.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';

class MeterReaderDashboard extends StatefulWidget {
  final User currentUser;
  const MeterReaderDashboard({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<MeterReaderDashboard> createState() => _MeterReaderDashboardState();
}

class _MeterReaderDashboardState extends State<MeterReaderDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meter Reader Dashboard'),
      ),
    );
  }
}
