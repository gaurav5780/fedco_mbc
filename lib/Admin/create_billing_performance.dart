import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Services/billingperformance_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/area.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:fedco_mbc/services/area_services.dart';
import 'package:flutter/material.dart';

class CreateBillingPerformance extends StatefulWidget {
  const CreateBillingPerformance({Key? key}) : super(key: key);

  @override
  State<CreateBillingPerformance> createState() =>
      _CreateBillingPerformanceState();
}

class _CreateBillingPerformanceState extends State<CreateBillingPerformance> {
  // Defining global formkey:
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  Future<BillingPerformance>? _futureBillingPerformance;
  Future<List<Area>>? areaList;
  List<Area> allAreas = List.empty(growable: true);

  // Defining controllers & Constants for the User model inputs:

  final totalConsumersController = TextEditingController();
  final userNameController = TextEditingController();
  final liveConsumersController = TextEditingController();
  final pdConsumersController = TextEditingController();
  final tdConsumersController = TextEditingController();
  final billedOnActualReadingController = TextEditingController();
  final readingInaccuraciesController = TextEditingController();
  final noMeterController = TextEditingController();
  final stoppedMeterController = TextEditingController();
  final inputEnergyController = TextEditingController();
  final billedEnergyController = TextEditingController();
  int areaID = 0;
  int yearNum = 0;
  int monthNum = 0;

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
    totalConsumersController.dispose();
    liveConsumersController.dispose();
    pdConsumersController.dispose();
    tdConsumersController.dispose();
    billedOnActualReadingController.dispose();
    readingInaccuraciesController.dispose();
    noMeterController.dispose();
    stoppedMeterController.dispose();
    inputEnergyController.dispose();
    billedEnergyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Update Area Performance',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureBillingPerformance == null)
              ? fetchAreaList()
              : buildFutureBuilder(),
        ));
  }

  SingleChildScrollView fetchAreaList() {
    areaList = getAllAreas();
    debugPrint('in fetchAreaList : $areaList');
    return SingleChildScrollView(
      child: ((areaList != null) ? areaFutureBuilder() : buildUI()),
    );
  }

  FutureBuilder<BillingPerformance> buildFutureBuilder() {
    return FutureBuilder<BillingPerformance>(
      future: _futureBillingPerformance,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //return Text('${snapshot.data!.area}');
          debugPrint(snapshot.data.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return LoaderTransparent();
      },
    );
  }

  FutureBuilder<List<Area>> areaFutureBuilder() {
    return FutureBuilder<List<Area>>(
        future: areaList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            allAreas = snapshot.data as List<Area>;
            debugPrint('All areas GK: $allAreas');
            return buildUI();
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return LoaderTransparent();
        });
  }

  Center buildUI() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              makeAreaDropDown(),
              const SizedBox(height: 20),
              makeYearDropDown(),
              const SizedBox(height: 20),
              makeMonthDropDown(),
              const SizedBox(height: 20),
              makeTextFormField("Total consumers", totalConsumersController),
              const SizedBox(height: 20),
              makeTextFormField("Live consumers", liveConsumersController),
              const SizedBox(height: 20),
              makeTextFormField("PD consumers", pdConsumersController),
              const SizedBox(height: 20),
              makeTextFormField("TD consumers", tdConsumersController),
              const SizedBox(height: 20),
              makeTextFormField(
                  "Billed on Actual reading", billedOnActualReadingController),
              const SizedBox(height: 20),
              makeTextFormField(
                  "Reading inaccuracies", readingInaccuraciesController),
              const SizedBox(height: 20),
              makeTextFormField("No meter cases", noMeterController),
              const SizedBox(height: 20),
              makeTextFormField("Stopped meter cases", stoppedMeterController),
              const SizedBox(height: 20),
              makeTextFormField("Input energy", inputEnergyController),
              const SizedBox(height: 20),
              makeTextFormField("Billed energy", billedEnergyController),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
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
    );
  }

  makeAreaDropDown() {
    debugPrint('Make Area Drop Down');
    return DropdownButtonFormField(
        hint: const Text('Select Area name'),
        //focusColor: Colors.white,
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: areaChoices,
        onChanged: onChangedArea);
  }

  makeYearDropDown() {
    return DropdownButtonFormField(
        hint: const Text('Select Year'),
        //focusColor: Colors.white,
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: yearChoices,
        onChanged: onChangedYear);
  }

  makeMonthDropDown() {
    return DropdownButtonFormField(
        hint: const Text('Select Month'),
        //focusColor: Colors.white,
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: monthChoices,
        onChanged: onChangedMonth);
  }

  List<DropdownMenuItem<String>> get areaChoices {
    List<DropdownMenuItem<String>> menuItems = allAreas.map((item) {
      debugPrint('Item : $item.toString()');
      return DropdownMenuItem(
        value: '${item.id}',
        child: Text(getAreaNamefromInt(item.areaName)),
      );
    }).toList();
    return menuItems;
  }

  List<DropdownMenuItem<String>> get yearChoices {
    List<DropdownMenuItem<String>> years = [
      const DropdownMenuItem(value: '2019', child: Text('2019')),
      const DropdownMenuItem(value: '2020', child: Text('2020')),
      const DropdownMenuItem(value: '2021', child: Text('2021')),
      const DropdownMenuItem(value: '2022', child: Text('2022')),
      const DropdownMenuItem(value: '2023', child: Text('2023')),
    ];
    return years;
  }

  List<DropdownMenuItem<String>> get monthChoices {
    List<DropdownMenuItem<String>> months = [
      const DropdownMenuItem(value: '1', child: Text('January')),
      const DropdownMenuItem(value: '2', child: Text('February')),
      const DropdownMenuItem(value: '3', child: Text('March')),
      const DropdownMenuItem(value: '4', child: Text('April')),
      const DropdownMenuItem(value: '5', child: Text('May')),
      const DropdownMenuItem(value: '6', child: Text('June')),
      const DropdownMenuItem(value: '7', child: Text('July')),
      const DropdownMenuItem(value: '8', child: Text('August')),
      const DropdownMenuItem(value: '9', child: Text('September')),
      const DropdownMenuItem(value: '10', child: Text('October')),
      const DropdownMenuItem(value: '11', child: Text('November')),
      const DropdownMenuItem(value: '12', child: Text('December')),
    ];
    return months;
  }

  void onChangedArea(String? area) {
    debugPrint('Area selected : $area');
    if (area != null) {
      setState(() {
        areaID = int.parse(area);
      });
    }
  }

  void onChangedYear(String? year) {
    if (year != null) {
      setState(() {
        yearNum = int.parse(year);
      });
    }
  }

  void onChangedMonth(String? month) {
    if (month != null) {
      setState(() {
        monthNum = int.parse(month);
      });
    }
  }

  makeTextFormField(String? label, TextEditingController controller) {
    String? labelText = label;
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 20, color: Colors.blueAccent),
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

  validateForm() {
    isValid = _formKey.currentState!.validate();
    if ((areaID != 0) && (yearNum != 0) && (monthNum != 0)) {
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
      int dummyID = 1;
      BillingPerformance performance = BillingPerformance(
          id: dummyID,
          area: areaID,
          performanceYear: yearNum,
          performanceMonth: monthNum,
          totalConsumers: int.parse(totalConsumersController.text),
          liveConsumers: int.parse(liveConsumersController.text),
          pdConsumers: int.parse(pdConsumersController.text),
          tdConsumers: int.parse(tdConsumersController.text),
          billedOnActualReading:
              int.parse(billedOnActualReadingController.text),
          readingInaccuracies: int.parse(readingInaccuraciesController.text),
          noMeter: int.parse(noMeterController.text),
          stoppedMeter: int.parse(stoppedMeterController.text),
          inputEnergy: int.parse(inputEnergyController.text),
          billedEnergy: int.parse(billedEnergyController.text));
      //create a new area in the database:
      setState(() {
        _futureBillingPerformance =
            createBillingPerformanceInDatabase(performance);
        buildFutureBuilder();
      });
    } else {
      // throw exception
      throw ('Check all the details are filled or not');
    }
  }
}
