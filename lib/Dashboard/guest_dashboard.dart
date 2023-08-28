import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';

class GuestDashboard extends StatefulWidget {
  final User currentUser;
  const GuestDashboard({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<GuestDashboard> createState() => _GuestDashboardState();
}

class _GuestDashboardState extends State<GuestDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guest Dashboard')),
    );
  }
}
