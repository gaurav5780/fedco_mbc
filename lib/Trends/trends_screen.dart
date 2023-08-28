import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';

class TrendScreen extends StatefulWidget {
  final User thisUser;
  const TrendScreen({Key? key, required this.thisUser}) : super(key: key);

  @override
  State<TrendScreen> createState() => _TrendScreenState();
}

class _TrendScreenState extends State<TrendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Performance Trends',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            children: [
              makeGridTile('Billing Efficiency', Icons.trending_up_sharp, 1),
              makeGridTile(
                  'Meter reading errors', Icons.error_outline_rounded, 2),
              makeGridTile('Stopped meters', Icons.color_lens_sharp, 3),
              makeGridTile('No meter cases', Icons.no_accounts_sharp, 4),
              makeGridTile('Billed on actuals', Icons.done_rounded, 5),
              makeGridTile('Live consumers', Icons.person_add_alt_1_rounded, 6),
            ],
          ),
        ),
      )),
    );
  }

  makeGridTile(String footer, IconData icon, int index) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius)),
      child: InkWell(
        onTap: (() {
          switch (index) {
            case 1:
              PageNavigator.goToBillingPerformance(context, widget.thisUser);
              break;
            default:
          }
        }),
        child: GridTile(
          footer: Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Center(child: Text(footer))),
          child: Icon(
            icon,
            size: 50,
          ),
        ),
      ),
    );
  }
}
