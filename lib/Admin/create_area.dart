import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/page_navigator.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/area.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:fedco_mbc/services/area_services.dart';
import 'package:flutter/material.dart';

class CreateArea extends StatefulWidget {
  final User user;
  const CreateArea({Key? key, required this.user}) : super(key: key);

  @override
  State<CreateArea> createState() => _CreateAreaState();
}

class _CreateAreaState extends State<CreateArea> {
  // Initialize values for each attribute:
  int dummyID = 0;
  int areaName = 0;
  final areaDescriptionController = TextEditingController();
  int areaType = 0;
  String areaColor = '';
  String textLabel = 'Area description';

  // Defining global formkey:
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  Future<Area>? _futureArea;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    areaDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create new Area',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          //alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureArea == null) ? buildUI() : buildFutureBuilder(),
        ));
  }

  SingleChildScrollView buildUI() {
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            makeAreaNameDropDown(),
            const SizedBox(height: 40),
            makeAreaDescriptionText(),
            const SizedBox(height: 40),
            makeAreaTypeDropDown(),
            const SizedBox(height: 40),
            makeAreaColorDropDown(),
            const SizedBox(height: 60),
            makeSubmitButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ));
  }

  makeAreaNameDropDown() {
    return DropdownButtonFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        hint: const Text('Select Area name'),
        //focusColor: Colors.white,
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: areaNameChoices,
        onChanged: onChangedAreaName);
  }

  makeAreaDescriptionText() {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        labelText: textLabel,
        labelStyle: TextStyle(fontSize: 20, color: ThemeData().primaryColor),
        errorStyle: TextStyle(
          //color: ThemeData().errorColor,
          fontSize: 14,
        ),
      ),
      controller: areaDescriptionController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a value';
        } else {
          return null;
        }
      },
    );
  }

  makeAreaTypeDropDown() {
    return DropdownButtonFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        hint: const Text('Select Area type'),
        //focusColor: Colors.white,
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: areaTypeChoices,
        onChanged: onChangedAreaType);
  }

  makeAreaColorDropDown() {
    return DropdownButtonFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        hint: const Text('Select Color'),
        //focusColor: Colors.white,
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: areaColorChoices,
        onChanged: onChangedAreaColor);
  }

  List<DropdownMenuItem<String>> get areaNameChoices {
    List<DropdownMenuItem<String>> nameItems = [
      const DropdownMenuItem(
          value: '${AreaIDs.all}', child: Text(AreasNames.all)),
      const DropdownMenuItem(
          value: '${AreaIDs.meghalaya}', child: Text(AreasNames.meghalaya)),
      const DropdownMenuItem(
          value: '${AreaIDs.mawsynram}', child: Text(AreasNames.mawsynram)),
      const DropdownMenuItem(
          value: '${AreaIDs.nongalbibra}', child: Text(AreasNames.nongalbibra)),
      const DropdownMenuItem(
          value: '${AreaIDs.phulbari}', child: Text(AreasNames.phulbari)),
      const DropdownMenuItem(
          value: '${AreaIDs.tripura}', child: Text(AreasNames.tripura)),
      const DropdownMenuItem(
          value: '${AreaIDs.ambassa}', child: Text(AreasNames.ambassa)),
      const DropdownMenuItem(
          value: '${AreaIDs.gandachera}', child: Text(AreasNames.gandachera)),
      const DropdownMenuItem(
          value: '${AreaIDs.manu}', child: Text(AreasNames.manu)),
      const DropdownMenuItem(
          value: '${AreaIDs.chawmanu}', child: Text(AreasNames.chawmanu)),
      const DropdownMenuItem(
          value: '${AreaIDs.mohanpur}', child: Text(AreasNames.mohanpur)),
      const DropdownMenuItem(
          value: '${AreaIDs.bamutia}', child: Text(AreasNames.bamutia)),
      const DropdownMenuItem(
          value: '${AreaIDs.hezamara}', child: Text(AreasNames.hezamara)),
      const DropdownMenuItem(
          value: '${AreaIDs.lefunga}', child: Text(AreasNames.lefunga)),
      const DropdownMenuItem(
          value: '${AreaIDs.sabroom}', child: Text(AreasNames.sabroom)),
      const DropdownMenuItem(
          value: '${AreaIDs.satchand}', child: Text(AreasNames.satchand)),
    ];
    return nameItems;
  }

  List<DropdownMenuItem<String>> get areaTypeChoices {
    List<DropdownMenuItem<String>> typeItems = [
      const DropdownMenuItem(
          value: '${AreaTypeID.discom}', child: Text(AreaTypeNames.discom)),
      const DropdownMenuItem(
          value: '${AreaTypeID.zone}', child: Text(AreaTypeNames.zone)),
      const DropdownMenuItem(
          value: '${AreaTypeID.circle}', child: Text(AreaTypeNames.circle)),
      const DropdownMenuItem(
          value: '${AreaTypeID.division}', child: Text(AreaTypeNames.division)),
      const DropdownMenuItem(
          value: '${AreaTypeID.subDivision}',
          child: Text(AreaTypeNames.subDivision)),
      const DropdownMenuItem(
          value: '${AreaTypeID.section}', child: Text(AreaTypeNames.section)),
      const DropdownMenuItem(
          value: '${AreaTypeID.htFeeder}', child: Text(AreaTypeNames.htFeeder)),
      const DropdownMenuItem(
          value: '${AreaTypeID.htFeederBranch}',
          child: Text(AreaTypeNames.htFeederBranch)),
      const DropdownMenuItem(
          value: '${AreaTypeID.distributionTransformer}',
          child: Text(AreaTypeNames.distributionTransformer)),
      const DropdownMenuItem(
          value: '${AreaTypeID.ltFeeder}', child: Text(AreaTypeNames.ltFeeder)),
      const DropdownMenuItem(
          value: '${AreaTypeID.ltFeederBranch}',
          child: Text(AreaTypeNames.ltFeederBranch)),
    ];
    return typeItems;
  }

  List<DropdownMenuItem<String>> get areaColorChoices {
    List<DropdownMenuItem<String>> colorItems = [
      const DropdownMenuItem(
          value: 'Colors.redAccent', child: Text('Red Accent')),
      const DropdownMenuItem(
          value: 'Colors.blueAccent', child: Text('Blue Accent')),
      const DropdownMenuItem(
          value: 'Colors.amberAccent', child: Text('Amber Accent')),
      const DropdownMenuItem(value: 'Colors.cyan', child: Text('Cyan')),
      const DropdownMenuItem(value: 'Colors.orange', child: Text('Orange')),
    ];
    return colorItems;
  }

  void onChangedAreaName(String? name) {
    if (name != null) {
      setState(() {
        areaName = int.parse(name);
      });
    }
  }

  void onChangedAreaType(String? type) {
    if (type != null) {
      setState(() {
        areaType = int.parse(type);
      });
    }
  }

  void onChangedAreaColor(String? color) {
    if (color != null) {
      setState(() {
        areaColor = color;
      });
    }
  }

  validateForm() {
    isValid = _formKey.currentState!.validate();
    if ((areaName != 0) &&
        (areaType != 0) &&
        (areaColor != '') &&
        (areaDescriptionController.text != '')) {
      setState(() => {isValid = true});
    } else {
      setState(() => {isValid = false});
    }
  }

  onPressed() {
    //Validate that all inputs are entered:
    validateForm();
    if (isValid) {
      //Populate the Area with input values
      Area area = Area(
          id: dummyID,
          areaName: areaName,
          areaDescription: areaDescriptionController.text,
          areaType: areaType,
          areaColor: areaColor);
      //create a new area in the database:
      setState(() {
        _futureArea = createAreaInDatabase(area);
      });
      buildFutureBuilder();
    } else {
      // throw exception
      throw ('Check all the details are filled or not');
    }
  }

  FutureBuilder<Area> buildFutureBuilder() {
    return FutureBuilder<Area>(
      future: _futureArea,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AlertDialog(
            title: const Text('Area Created'),
            content: const Text('New area has been created'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    PageNavigator.goToAdminDashboard(context, widget.user);
                  },
                  child: const Text('Ok')),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return LoaderTransparent();
      },
    );
  }

  makeSubmitButton() {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            //primary: Colors.blueAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: onPressed,
        child: const Text(
          'Create',
          style: TextStyle(
              fontSize: 18,
              //color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
