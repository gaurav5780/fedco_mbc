import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class UsersListTileWidget extends StatelessWidget {
  final User user;
  final bool isSelected;
  final ValueChanged<User> onSelectedUser;

  const UsersListTileWidget({
    Key? key,
    required this.user,
    required this.isSelected,
    required this.onSelectedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = isSelected
        ? const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )
        : const TextStyle(fontSize: 18);
    final subtitleStyle = isSelected
        ? const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
          )
        : const TextStyle(fontSize: 14, fontStyle: FontStyle.italic);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.marginSmall),
        child: ListTile(
          onTap: () => onSelectedUser(user),
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(user.userAvatar),
          ),
          title: Text(
            user.userName,
            style: titleStyle,
          ),
          subtitle: Text(
            '${getUserLevelFromInt(user.userLevel)}, ${getAreaNamefromInt(user.area)}',
            style: subtitleStyle,
          ),
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                )
              : const Icon(
                  Icons.radio_button_unchecked,
                  //color: selectedColor,
                  size: 28,
                ),
        ),
      ),
    );
  }
}
