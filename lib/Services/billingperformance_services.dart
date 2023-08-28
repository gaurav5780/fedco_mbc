import 'dart:convert';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/billing_performance.dart';
import 'package:flutter/material.dart';

// Get all the BillingPerformances in the database:

Future<List<BillingPerformance>> getAllBillingPerformances() async {
  Dio dio = Dio();
  //dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingPerformanceURL;
  } else {
    uRL = androidUriConstants.billingPerformanceURL;
  }
  try {
    final response = await dio.get(uRL);
    debugPrint('BillingPerformance: ${response.data.toString()}');
    return BillingPerformance.listFromJson(response.data);
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to get Billing Performances");
  }
}

// Get all the BillingPerformances of a specific area from the database:

Future<List<BillingPerformance>> getSpecificBillingPerformances(
    int areaID) async {
  Dio dio = Dio();
  //dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.specificBillingURL;
  } else {
    uRL = androidUriConstants.specificBillingURL;
  }
  try {
    final response = await dio.get('$uRL/$areaID/');
    debugPrint(uRL);
    debugPrint('GK: $response');
    debugPrint(response.data.toString());
    return BillingPerformance.listFromJson(response.data);
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to get Billing Performances");
  }
}

// Create new Billing Performance in the database:

Future<BillingPerformance> createBillingPerformanceInDatabase(
    BillingPerformance performance) async {
  final Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingPerformanceURL;
  } else {
    uRL = androidUriConstants.billingPerformanceURL;
  }
  try {
    final response = await dio.post(
      uRL,
      data: jsonEncode(performance.toJson()),
    );
    return BillingPerformance.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to create Billing Performance");
  }
}

// Get Billing Performance by ID from the database:

Future<BillingPerformance> getBillingPerformanceByID(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingPerformanceURL;
  } else {
    uRL = androidUriConstants.billingPerformanceURL;
  }
  try {
    final response = await dio.get("$uRL/$id/");
    debugPrint(response.toString());
    return BillingPerformance.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to load : $id");
  }
}

// Delete Billing Performance from database by ID:

void deleteBillingPerformance(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingPerformanceURL;
  } else {
    uRL = androidUriConstants.billingPerformanceURL;
  }
  try {
    await dio.delete("$uRL/$id/");
    debugPrint('Deleted successfully');
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to delete Billing performance: $id");
  }
}

// Put request to update BillingPerformance in the database by ID:

Future<BillingPerformance> putBillingPerformanceByID(
    BillingPerformance performance, int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingPerformanceURL;
  } else {
    uRL = androidUriConstants.billingPerformanceURL;
  }
  try {
    final response =
        await dio.put("$uRL/$id/", data: jsonEncode(performance.toJson()));
    debugPrint('BillingPerformance updated: ${response.data}');
    return BillingPerformance.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to update BillingPerformance: $id");
  }
}
