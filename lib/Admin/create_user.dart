import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:flutter/material.dart';
import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/user_constants.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:fedco_mbc/services/area_services.dart';
import 'package:fedco_mbc/services/user_services.dart';
import '../models/area.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  // Defining global formkey:
  final _formKey = GlobalKey<FormState>();

  // Defining controllers & Constants for the User model inputs:

  final userNameController = TextEditingController();
  final userAvatarController = TextEditingController();
  final userEmailController = TextEditingController();
  final userPassController = TextEditingController();
  final userBioController = TextEditingController();
  final phoneNumberController = TextEditingController();
  String deviceIdentifier = 'Dummy value';
  int dummyID = 0;
  int userLevel = 0;
  int userArea = 0;
  bool isUserLoggedIn = false;
  bool hasSeenIntro = false;
  int userReportsTo = 0;
  int userIncentiveScore = 0;
  Future<List<Area>>? areaList;
  List<Area> allAreas = List.empty(growable: true);
  bool isValid = false;

  // Defining a new uninitialized User;
  Future<User>? _futureUser;

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
    // Dispose all the controllers when state is destroyed:
    userNameController.dispose();
    userAvatarController.dispose();
    userEmailController.dispose();
    userPassController.dispose();
    userBioController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create new user',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: (_futureUser == null)
              ? fetchAreaListFirst()
              : buildFutureBuilder(),
        ));
  }

  fetchAreaListFirst() {
    areaList = getAllAreas();
    debugPrint('in fetchAreaListFirst : $areaList');
    return (areaList != null) ? areaFutureBuilder() : buildUI();
  }

  SingleChildScrollView buildUI() {
    return SingleChildScrollView(
        child: Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              makeTextFormField("Name", userNameController),
              const SizedBox(
                height: 40,
              ),
              makeTextFormField(
                  "Avatar link from Flickr", userAvatarController),
              const SizedBox(
                height: 40,
              ),
              makeTextFormField("Email ID", userEmailController),
              const SizedBox(
                height: 40,
              ),
              makeTextFormField("Password", userPassController),
              const SizedBox(
                height: 40,
              ),
              makeTextFormField("About", userBioController),
              const SizedBox(
                height: 40,
              ),
              makeTextFormField("Phone Number", phoneNumberController),
              const SizedBox(
                height: 40,
              ),
              makeDropDownButtonForUserArea(),
              const SizedBox(
                height: 40,
              ),
              makeDropDownButtonForUserLevel(),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                height: 50,
                width: 300,
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
              ),
            ],
          ),
        ),
      ),
    ));
  }

  validateForm() {
    isValid = _formKey.currentState!.validate();
    if ((userLevel != 0) && (userArea != 0)) {
      setState(() => {isValid = true});
    } else {
      setState(() => {isValid = false});
    }
  }

  onPressed() {
    //Validate that all inputs are entered:
    validateForm();
    if (isValid) {
      int dummyID = 1;
      //Populate the User with input values
      User user = User(
          id: dummyID,
          area: userArea,
          isUserLoggedIn: isUserLoggedIn,
          hasSeenIntro: hasSeenIntro,
          userName: userNameController.text,
          userAvatar: userAvatarController.text,
          userEmail: userEmailController.text,
          userPass: userPassController.text,
          userBio: userBioController.text,
          phoneNumber: phoneNumberController.text,
          deviceIdentifier: deviceIdentifier,
          userLevel: userLevel,
          userReportsTo: userReportsTo,
          userIncentiveScore: userIncentiveScore);
      debugPrint('Name :');
      debugPrint(user.userName);

      debugPrint('Avatar :');
      debugPrint(user.userAvatar);

      // create a user in the database:
      setState(() {
        _futureUser = createUserInDatabase(user);
      });
      //buildFutureBuilder();
    } else {
      // throw exception
      throw ('Check all the details are filled or not');
    }
  }

  makeTextFormField(String? label, TextEditingController controller) {
    String? labelText = label;
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 20,
          //color: Colors.blueAccent
        ),
        errorStyle: const TextStyle(
          //color: Colors.red,
          fontSize: 14,
        ),
      ),
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a value';
        }
      },
    );
  }

  makeDropDownButtonForUserArea() {
    return DropdownButtonFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: userAreaChoices,
        hint: const Text(
          'Select User Area',
          style: TextStyle(
              //color: Colors.blueAccent,
              fontSize: 20),
        ),
        onChanged: onChangedArea);
  }

  makeDropDownButtonForUserLevel() {
    return DropdownButtonFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: userLevelChoices,
        hint: const Text('Select User Level',
            style: TextStyle(
                //color: Colors.blueAccent,
                fontSize: 20)),
        onChanged: onChangedLevel);
  }

  List<DropdownMenuItem<String>> get userAreaChoices {
    List<DropdownMenuItem<String>> menuItems = allAreas.map((item) {
      debugPrint('Item : $item');
      return DropdownMenuItem(
        value: '${item.areaName}',
        child: Text(getAreaNamefromInt(item.areaName)),
      );
    }).toList();
    return menuItems;
  }

  List<DropdownMenuItem<String>> get userLevelChoices {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: '${UserLevelID.admin}', child: Text(UserLevelName.admin)),
      const DropdownMenuItem(
          value: '${UserLevelID.guest}', child: Text(UserLevelName.guest)),
      const DropdownMenuItem(
          value: '${UserLevelID.chief}', child: Text(UserLevelName.chief)),
      const DropdownMenuItem(
          value: '${UserLevelID.manager}', child: Text(UserLevelName.manager)),
      const DropdownMenuItem(
          value: '${UserLevelID.executive}',
          child: Text(UserLevelName.executive)),
      const DropdownMenuItem(
          value: '${UserLevelID.meterReader}',
          child: Text(UserLevelName.meterReader)),
    ];
    return menuItems;
  }

  void onChangedLevel(String? level) {
    if (level != null) {
      setState(() {
        userLevel = int.parse(level);
      });
    }
  }

  void onChangedArea(String? area) {
    debugPrint('Area selected : $area');
    if (area != null) {
      setState(() {
        userArea = int.parse(area);
      });
    }
  }

  FutureBuilder<List<Area>> areaFutureBuilder() {
    return FutureBuilder<List<Area>>(
        future: areaList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            allAreas = snapshot.data as List<Area>;
            debugPrint('All areas : $allAreas');
            return buildUI();
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return LoaderTransparent();
        });
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.userName);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return LoaderTransparent();
      },
    );
  }
}
