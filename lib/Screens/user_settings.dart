import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/main.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: ListTile(
                title: const Text('App theme mode'),
                subtitle: const Text('Change between light and dark modes'),
                trailing: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: AppConstants.imageRadiusMedium,
                  child: IconButton(
                      icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                          ? Icons.dark_mode
                          : Icons.light_mode),
                      onPressed: () {
                        MyApp.themeNotifier.value =
                            MyApp.themeNotifier.value == ThemeMode.light
                                ? ThemeMode.dark
                                : ThemeMode.light;
                      }),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: ListTile(
                title: Text('Notifications'),
                subtitle: Text('Turn ON / OFF app notifications'),
                trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
        ]),
      )),
    );
  }
}
