import 'package:fedco_mbc/Constants/update_constants.dart';
import 'package:fedco_mbc/Services/billingrecommendation_services.dart';
import 'package:fedco_mbc/Services/billingupdate_services.dart';
import 'package:fedco_mbc/Utilities/progress_loader.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:fedco_mbc/models/billing_recommendation.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:fedco_mbc/models/billing_update.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateUpdate extends StatefulWidget {
  final BillingAssignment? billingAssignment;
  final BillingTask billingTask;
  final User? user;
  const CreateUpdate(
      {Key? key, required this.billingTask, this.user, this.billingAssignment})
      : super(key: key);

  @override
  State<CreateUpdate> createState() => _CreateUpdateState();
}

class _CreateUpdateState extends State<CreateUpdate> {
  // Initialize values for each attribute:
  int dummyID = 0;
  int updateIncentive = 0;
  int maxCases = 0;
  int updateType = UpdateTypeInt.partial;
  final updateDescriptionController = TextEditingController();
  final updateCasesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<BillingRecommendation>? futureRec;
  BillingRecommendation? recommendation;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    futureRec =
        getBillingRecommendationByID(widget.billingTask.billingRecommendation);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    updateDescriptionController.dispose();
    updateCasesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Create Update',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: (isLoaded) ? makeForm() : makeFuture(),
    );
  }

  makeFuture() {
    return FutureBuilder(
      future: futureRec,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has data : ${snapshot.data}');
          recommendation = snapshot.data as BillingRecommendation;
          maxCases = recommendation!.numberOfCases;
          isLoaded = true;
          return makeForm();
        } else if (snapshot.hasError) {
          debugPrint('snapshot has error : ${snapshot.error}');
          return Text('Error : ${snapshot.error}');
        } else {
          debugPrint('snapshot is waiting for data');
          return LoaderTransparent();
        }
      },
    );
  }

  makeForm() {
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            makeDescriptionEntry(),
            const SizedBox(height: 40),
            makeCaseEntry(),
            const SizedBox(height: 40),
            makeSubmitButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ));
  }

  makeDescriptionEntry() {
    return TextFormField(
      maxLines: 4,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        labelText: 'Description',
        alignLabelWithHint: true,
        labelStyle: TextStyle(
          fontSize: 20,
          //color: Colors.blueAccent
        ),
        errorStyle: TextStyle(
          //color: Colors.red,
          fontSize: 14,
        ),
      ),
      controller: updateDescriptionController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a value';
        } else {
          return null;
        }
      },
    );
  }

  makeCaseEntry() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        labelText: 'Cases rectified',
        labelStyle: TextStyle(
          fontSize: 20,
          //color: Colors.blueAccent
        ),
        errorStyle: TextStyle(
          //color: Colors.red,
          fontSize: 14,
        ),
      ),
      controller: updateCasesController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a value';
        } else if (int.parse(value) > maxCases) {
          return 'Cannot be more than recommended cases';
        } else {
          return null;
        }
      },
    );
  }

  makeSubmitButton() {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
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

  onPressed() {
    if (_formKey.currentState!.validate()) {
      int rectifiedCases = int.parse(updateCasesController.text);
      int updateIncentive =
          ((rectifiedCases * widget.billingAssignment!.incentive) / maxCases)
              .round();
      BillingUpdate billingUpdate = BillingUpdate(
          id: dummyID,
          billingAssignment: widget.billingAssignment!.id,
          updateDescription: updateDescriptionController.text,
          updateDate: DateTime.now(),
          updateType: updateType,
          updateRectifiedCases: rectifiedCases,
          updateIncentive: updateIncentive);
      makeUpdateFuture(billingUpdate);
    } else {
      Fluttertoast.showToast(msg: 'Something was not correct');
    }
  }

  makeUpdateFuture(BillingUpdate billingUpdate) {
    return FutureBuilder(
        future: createBillingUpdateInDatabase(billingUpdate),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('snapshot has data : ${snapshot.data}');
            String response = snapshot.data as String;
            return Center(child: Text(response));
          } else if (snapshot.hasError) {
            debugPrint('snapshot has error : ${snapshot.error}');
            String response = snapshot.error as String;
            return Center(child: Text(response));
          } else {
            return LoaderTransparent();
          }
        }));
  }
}

//   id billingAssignment updateDescription updateDate
//   final int updateType;
//   final int updateRectifiedCases;
//   final int updateIncentive;
