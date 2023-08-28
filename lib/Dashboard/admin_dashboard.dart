import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Dashboard/nav_drawer.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  final User currentUser;
  const AdminDashboard({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // drawer: NavigationDrawer(
      //   user: widget.currentUser,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: makeCreateButtons(),
        ),
      ),
    );
  }

  makeCreateButtons() {
    return Column(
      children: [
        ListTile(
          title: const Text('Create User'),
          subtitle: const Text('Tap here to create a new user'),
          leading: const Icon(Icons.create_outlined),
          onTap: () => PageNavigator.goToCreateUser(context),
          //tileColor: Colors.grey[900],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0.5,
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text('Create Area'),
          subtitle: const Text('Tap here to create a new area'),
          leading: const Icon(Icons.create_new_folder_outlined),
          onTap: () =>
              PageNavigator.goToCreateArea(context, widget.currentUser),
          //tileColor: Colors.grey[900],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0.5,
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text('Create Area Performance'),
          subtitle: const Text(
              'Tap here to create a performance parameters for an area'),
          leading: const Icon(Icons.percent_rounded),
          onTap: () => PageNavigator.goToCreateAreaPerformance(context),
          //tileColor: Colors.grey[900],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0.5,
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text('Create Recommendations'),
          subtitle:
              const Text('Tap here to create a new dummy recommendations'),
          leading: const Icon(Icons.face_retouching_natural),
          onTap: () => PageNavigator.goToCreateRecommendation(context),
          //tileColor: Colors.grey[900],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0.5,
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text('Create Action'),
          subtitle: const Text('Tap here to create a new dummy action'),
          leading: const Icon(Icons.call_to_action_rounded),
          onTap: () =>
              PageNavigator.goToCreateArea(context, widget.currentUser),
          //tileColor: Colors.grey[900],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0.5,
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text('Create Update'),
          subtitle: const Text('Tap here to create a dummy update'),
          leading: const Icon(Icons.update_outlined),
          onTap: () =>
              PageNavigator.goToCreateArea(context, widget.currentUser),
          //tileColor: Colors.grey[900],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0.5,
        ),
      ],
    );
  }
}
