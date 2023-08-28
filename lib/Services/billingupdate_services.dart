import 'dart:convert';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/billing_update.dart';
import 'package:flutter/material.dart';

// Get all the Updates in the database:

Future<List<BillingUpdate>> getAllBillingUpdates() async {
  Dio dio = Dio();
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingUpdateURL;
  } else {
    uRL = androidUriConstants.billingUpdateURL;
  }
  try {
    final response = await dio.get(uRL);
    debugPrint(response.toString());
    return BillingUpdate.listFromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to get Updates");
  }
}

// Create new Update in the database:

Future createBillingUpdateInDatabase(BillingUpdate newUpdate) async {
  final Dio dio = Dio();
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingUpdateURL;
  } else {
    uRL = androidUriConstants.billingUpdateURL;
  }
  try {
    final response = await dio.post(
      uRL,
      data: jsonEncode(newUpdate.toJson()),
    );
    debugPrint(response.toString());
    debugPrint(response.statusMessage);
    debugPrint(response.statusCode.toString());

    return response.data;
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to create Update");
  }
}

// Get Update by ID from the database:

Future<BillingUpdate> getBillingUpdateByID(int id) async {
  Dio dio = Dio();
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingUpdateURL;
  } else {
    uRL = androidUriConstants.billingUpdateURL;
  }
  try {
    final response = await dio.get("$uRL/$id/");
    debugPrint(response.toString());
    return BillingUpdate.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to load Update: $id");
  }
}

// Delete an Update from database by Update ID:

void deleteBillingUpdate(int id) async {
  Dio dio = Dio();
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingUpdateURL;
  } else {
    uRL = androidUriConstants.billingUpdateURL;
  }
  try {
    await dio.delete("$uRL/$id/");
    debugPrint('Deleted successfully');
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to delete Update: $id");
  }
}

// Put request to update BillingUpdate in the database by ID:

Future<BillingUpdate> putBillingUpdateByID(BillingUpdate update, int id) async {
  Dio dio = Dio();
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingUpdateURL;
  } else {
    uRL = androidUriConstants.billingUpdateURL;
  }
  try {
    final response =
        await dio.put("$uRL/$id/", data: jsonEncode(update.toJson()));
    debugPrint('BillingUpdate updated: ${response.data}');
    return BillingUpdate.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to update BillingUpdate: $id");
  }
}
