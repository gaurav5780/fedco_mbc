import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController descriptionController = TextEditingController();
    descriptionController.text = user.userBio;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            verticalSpacing(AppConstants.marginLarge),
            //Header:
            Padding(
              padding: const EdgeInsets.all(AppConstants.marginLarge),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.cardRadius)),
                child: Column(children: [
                  verticalSpacing(AppConstants.marginLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      horizontalSpacing(AppConstants.marginLarge),
                      //Profile Image
                      makeProfileImage(user),
                      makeContactButtons(context, user),
                    ],
                  ),
                  verticalSpacing(AppConstants.marginSmall),
                ]),
              ),
            ),
            verticalSpacing(AppConstants.marginLarge),
            if ((user.userLevel != UserLevelID.admin) &&
                (user.userLevel != UserLevelID.chief) &&
                (user.userLevel != UserLevelID.guest))
              makeIncentiveScore(user, screenWidth)
            else
              verticalSpacing(0),
            verticalSpacing(AppConstants.marginLarge),
            Container(
              margin: const EdgeInsets.all(AppConstants.marginLarge),
              child: Column(
                children: [
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                  ),
                  verticalSpacing(AppConstants.marginLarge),
                  const Divider(
                    thickness: 1,
                  ),
                  verticalSpacing(AppConstants.marginLarge),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

//TODO: Add URLs for these:
  void onPhonePressed() {}

  void onWhatsAppPressed() {}

  void onEmailPressed() {}

  makeProfileImage(User user) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(AppConstants.marginLarge),
          padding: const EdgeInsets.all(AppConstants.marginLarge),
          child: CircleAvatar(
            radius: AppConstants.imageRadiusXXL,
            backgroundImage: NetworkImage(user.userAvatar),
          ),
        ),
        verticalSpacing(AppConstants.marginSmall),
        Text(
          user.userName,
          style: const TextStyle(
            fontSize: AppConstants.largeFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${getUserLevelFromInt(user.userLevel)}, ${getAreaNamefromInt(user.area)}',
          style: const TextStyle(
            fontSize: AppConstants.mediumFont,
          ),
        ),
      ],
    );
  }

  makeContactButtons(BuildContext context, User user) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.marginLarge),
      padding: const EdgeInsets.all(AppConstants.marginLarge),
      child: Column(
        children: [
          //Contact Icon buttons:
          verticalSpacing(AppConstants.marginLarge),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: AppConstants.imageRadiusMedium,
            child: IconButton(
                iconSize: AppConstants.imageRadiusLarge,
                onPressed: () =>
                    launchUrl(Uri.parse('tel: ${user.phoneNumber}')),
                icon: const Icon(Icons.phone_rounded)),
          ),
          verticalSpacing(AppConstants.marginLarge),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: AppConstants.imageRadiusMedium,
            child: IconButton(
                iconSize: AppConstants.imageRadiusLarge,
                onPressed: () => onWhatsAppPressed,
                icon: const Icon(Icons.whatshot_rounded)),
          ),
          verticalSpacing(AppConstants.marginLarge),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: AppConstants.imageRadiusMedium,
            child: IconButton(
                iconSize: AppConstants.imageRadiusLarge,
                onPressed: () => onEmailPressed,
                icon: const Icon(Icons.email_rounded)),
          ),
          verticalSpacing(AppConstants.marginLarge),
        ],
      ),
    );
  }

  makeIncentiveScore(User user, double screenWidth) {
    return SizedBox(
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: ElevatedButton(
          onPressed: (() {}),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Text(
              'Incentive Score: ${user.userIncentiveScore}',
              style: const TextStyle(
                fontSize: AppConstants.largeFont,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
