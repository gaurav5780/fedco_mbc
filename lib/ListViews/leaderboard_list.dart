import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:fedco_mbc/ListViews/user_tile.dart';
import 'package:fedco_mbc/Services/user_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  late Future<List<User>> usersList;
  List<User> allUsers = List.empty(growable: true);
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    usersList = getAllUsers();
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
          'Leaderboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: (isLoaded) ? makeList() : makeFuture(),
    );
  }

  makeList() {
    List<User> relevantUsers = <User>[];
    for (var i = 0; i < allUsers.length; i++) {
      if ((allUsers[i].userLevel == UserLevelID.manager) ||
          (allUsers[i].userLevel == UserLevelID.executive) ||
          (allUsers[i].userLevel == UserLevelID.meterReader)) {
        relevantUsers.add(allUsers[i]);
      }
    }
    // sort the list of users by score
    relevantUsers
        .sort(((b, a) => a.userIncentiveScore.compareTo(b.userIncentiveScore)));
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: relevantUsers.length,
        itemBuilder: (context, index) {
          return userTile(context, relevantUsers, index);
        },
      ),
    );
  }

  makeFuture() {
    return FutureBuilder(
        future: usersList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            allUsers = snapshot.data as List<User>;
            isLoaded = true;
            return makeList();
          } else if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          } else {
            return LoaderTransparent();
          }
        });
  }
}
