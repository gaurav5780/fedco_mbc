import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import '../Constants/page_navigator.dart';

userTile(BuildContext context, List<User> relevantUsers, int index) {
  return Card(
    child: ListTile(
      minVerticalPadding: AppConstants.paddingLarge,
      leading: CircleAvatar(
        radius: AppConstants.imageRadiusLarge,
        backgroundImage: NetworkImage(relevantUsers[index].userAvatar),
      ),
      title: Text(relevantUsers[index].userName),
      subtitle: Text(
          '${getUserLevelFromInt(relevantUsers[index].userLevel)}, ${getAreaNamefromInt(relevantUsers[index].area)}'),
      trailing: Text(
        '${relevantUsers[index].userIncentiveScore}',
        style: const TextStyle(fontSize: AppConstants.xlFont),
      ),
      onTap: () {
        PageNavigator.goToProfileScreen(context, relevantUsers[index]);
      },
    ),
  );
}
