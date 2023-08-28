import 'package:fedco_mbc/Constants/area_constants.dart';
import 'package:fedco_mbc/Constants/billingrecommendation_constants.dart';
import 'package:fedco_mbc/Services/billingrecommendation_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_recommendation.dart';
import 'package:flutter/material.dart';
import '../models/area.dart';
import '../services/area_services.dart';

class CreateBillingRecommendation extends StatefulWidget {
  const CreateBillingRecommendation({Key? key}) : super(key: key);

  @override
  State<CreateBillingRecommendation> createState() =>
      _CreateBillingRecommendationState();
}

class _CreateBillingRecommendationState
    extends State<CreateBillingRecommendation> {
  // Defining global formkey:
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  Future<BillingRecommendation>? _futureRecommendation;
  Future<List<Area>>? areaList;
  List<Area> allAreas = List.empty(growable: true);

  // Defining controllers & Constants for the User model inputs:

  final recommendationPriorityController = TextEditingController();
  final numberOfCasesController = TextEditingController();
  final unitsLostController = TextEditingController();
  final amountLostController = TextEditingController();
  final meterCostController = TextEditingController();
  final meterBoxCostController = TextEditingController();
  final installationCostController = TextEditingController();
  final paybackPeriodMonthsController = TextEditingController();
  int areaID = 0;
  int currentStatus = 0;
  int recommendationType = 0;
  int recommendationCategory = 0;

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
    recommendationPriorityController.dispose();
    numberOfCasesController.dispose();
    unitsLostController.dispose();
    amountLostController.dispose();
    meterCostController.dispose();
    meterBoxCostController.dispose();
    installationCostController.dispose();
    paybackPeriodMonthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create recommendation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureRecommendation == null)
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

  FutureBuilder<BillingRecommendation> buildFutureBuilder() {
    return FutureBuilder<BillingRecommendation>(
      future: _futureRecommendation,
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
              makeTextFormField(
                  "Recommendation Priority", recommendationPriorityController),
              const SizedBox(height: 20),
              makeTextFormField("Number of cases", numberOfCasesController),
              const SizedBox(height: 20),
              makeRecoTypeDropDown(),
              const SizedBox(height: 20),
              makeRecoCategoryDropDown(),
              const SizedBox(height: 20),
              makeTextFormField("Units lost", unitsLostController),
              const SizedBox(height: 20),
              makeTextFormField("Amount lost", amountLostController),
              const SizedBox(height: 20),
              makeTextFormField("Meter cost", meterCostController),
              const SizedBox(height: 20),
              makeTextFormField("Meter box cost", meterBoxCostController),
              const SizedBox(height: 20),
              makeTextFormField(
                  "Installation cost", installationCostController),
              const SizedBox(height: 20),
              makeTextFormField(
                  "Payback period in months", paybackPeriodMonthsController),
              const SizedBox(height: 20),
              makeRecoStatusDropDown(),
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

  List<DropdownMenuItem<String>> get areaChoices {
    List<DropdownMenuItem<String>> menuItems = allAreas.map((item) {
      debugPrint('Item : $item.toString()');
      return DropdownMenuItem(
        value: '${item.areaName}',
        child: Text(getAreaNamefromInt(item.areaName)),
      );
    }).toList();
    return menuItems;
  }

  void onChangedArea(String? area) {
    debugPrint('Area selected : $area');
    if (area != null) {
      setState(() {
        areaID = int.parse(area);
      });
    }
  }

  makeTextFormField(String? label, TextEditingController controller) {
    String? labelText = label;
    return TextFormField(
      decoration: InputDecoration(
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

  makeRecoTypeDropDown() {
    return DropdownButtonFormField(
        hint: const Text('Select Recommendation type'),
        //focusColor: Colors.white,
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: typeChoices,
        onChanged: onChangedType);
  }

  List<DropdownMenuItem<String>> get typeChoices {
    List<DropdownMenuItem<String>> type = [
      const DropdownMenuItem(
          value: '${BillingRecommendationTypeID.unBilled}',
          child: Text(BillingRecommendationTypeNames.unBilled)),
      const DropdownMenuItem(
          value: '${BillingRecommendationTypeID.inaccurateReading}',
          child: Text(BillingRecommendationTypeNames.inaccurateReading)),
      const DropdownMenuItem(
          value: '${BillingRecommendationTypeID.missedReadingDate}',
          child: Text(BillingRecommendationTypeNames.missedReadingDate)),
      const DropdownMenuItem(
          value: '${BillingRecommendationTypeID.noMeter}',
          child: Text(BillingRecommendationTypeNames.noMeter)),
      const DropdownMenuItem(
          value: '${BillingRecommendationTypeID.slowMeter}',
          child: Text(BillingRecommendationTypeNames.slowMeter)),
      const DropdownMenuItem(
          value: '${BillingRecommendationTypeID.stoppedMeter}',
          child: Text(BillingRecommendationTypeNames.stoppedMeter)),
    ];
    return type;
  }

  void onChangedType(String? type) {
    if (type != null) {
      setState(() {
        recommendationType = int.parse(type);
      });
    }
  }

  makeRecoCategoryDropDown() {
    return DropdownButtonFormField(
        hint: const Text('Select Recommendation type'),
        //focusColor: Colors.white,
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: categoryChoices,
        onChanged: onChangedCategory);
  }

  List<DropdownMenuItem<String>> get categoryChoices {
    List<DropdownMenuItem<String>> category = [
      const DropdownMenuItem(
          value: '${BillingRecommendationCategoryID.domestic}',
          child: Text(BillingRecommendationCategoryNames.domestic)),
      const DropdownMenuItem(
          value: '${BillingRecommendationCategoryID.commercial}',
          child: Text(BillingRecommendationCategoryNames.commercial)),
      const DropdownMenuItem(
          value: '${BillingRecommendationCategoryID.industrial}',
          child: Text(BillingRecommendationCategoryNames.industrial)),
      const DropdownMenuItem(
          value: '${BillingRecommendationCategoryID.wslt}',
          child: Text(BillingRecommendationCategoryNames.wslt)),
      const DropdownMenuItem(
          value: '${BillingRecommendationCategoryID.generalPurpose}',
          child: Text(BillingRecommendationCategoryNames.generalPurpose)),
      const DropdownMenuItem(
          value: '${BillingRecommendationCategoryID.bplMetered}',
          child: Text(BillingRecommendationCategoryNames.bplMetered)),
      const DropdownMenuItem(
          value: '${BillingRecommendationCategoryID.bplUnmetered}',
          child: Text(BillingRecommendationCategoryNames.bplUnmetered)),
    ];
    return category;
  }

  void onChangedCategory(String? category) {
    if (category != null) {
      setState(() {
        recommendationCategory = int.parse(category);
      });
    }
  }

  makeRecoStatusDropDown() {
    return DropdownButtonFormField(
        hint: const Text('Select Recommendation type'),
        //focusColor: Colors.white,
        //dropdownColor: Colors.grey[200],
        style: const TextStyle(
            //color: Colors.blueAccent,
            fontSize: 20),
        items: statusChoices,
        onChanged: onChangedStatus);
  }

  List<DropdownMenuItem<String>> get statusChoices {
    List<DropdownMenuItem<String>> status = [
      const DropdownMenuItem(
          value: '${BillingRecommendationStatusID.newRec}',
          child: Text(BillingRecommendationStatusNames.newRec)),
      const DropdownMenuItem(
          value: '${BillingRecommendationStatusID.pendingRec}',
          child: Text(BillingRecommendationStatusNames.pendingRec)),
      const DropdownMenuItem(
          value: '${BillingRecommendationStatusID.progressRec}',
          child: Text(BillingRecommendationStatusNames.progressRec)),
      const DropdownMenuItem(
          value: '${BillingRecommendationStatusID.droppedRec}',
          child: Text(BillingRecommendationStatusNames.droppedRec)),
      const DropdownMenuItem(
          value: '${BillingRecommendationStatusID.delayedRec}',
          child: Text(BillingRecommendationStatusNames.delayedRec)),
      const DropdownMenuItem(
          value: '${BillingRecommendationStatusID.deferredRec}',
          child: Text(BillingRecommendationStatusNames.deferredRec)),
      const DropdownMenuItem(
          value: '${BillingRecommendationStatusID.completedRec}',
          child: Text(BillingRecommendationStatusNames.completedRec)),
    ];
    return status;
  }

  void onChangedStatus(String? status) {
    if (status != null) {
      setState(() {
        currentStatus = int.parse(status);
      });
    }
  }

  validateForm() {
    isValid = _formKey.currentState!.validate();
    if ((areaID != 0) &&
        (recommendationType != 0) &&
        (recommendationCategory != 0) &&
        (currentStatus != 0)) {
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
      BillingRecommendation recommendation = BillingRecommendation(
          id: dummyID,
          billingPerformance: areaID,
          recommendationDate: DateTime.now(),
          recommendationPriority:
              int.parse(recommendationPriorityController.text),
          numberOfCases: int.parse(numberOfCasesController.text),
          recommendationType: recommendationType,
          recommendationCategory: recommendationCategory,
          unitsLost: int.parse(unitsLostController.text),
          amountLost: double.parse(amountLostController.text),
          meterCost: double.parse(meterCostController.text),
          meterBoxCost: double.parse(meterBoxCostController.text),
          installationCost: double.parse(installationCostController.text),
          paybackPeriodMonths: int.parse(paybackPeriodMonthsController.text),
          currentStatus: currentStatus);
      //create a new area in the database:
      setState(() {
        _futureRecommendation =
            createBillingRecommendationInDatabase(recommendation);
        buildFutureBuilder();
      });
    } else {
      // throw exception
      throw ('Check all the details are filled or not');
    }
  }
}
