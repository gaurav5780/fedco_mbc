import 'dart:convert';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/billing_assignment.dart';
import 'package:flutter/material.dart';

// Get all the BillingAssignment from the database:

Future<List<BillingAssignment>> getAllBillingAssignments() async {
  Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      contentType: 'application/json',
      responseType: ResponseType.plain));
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingAssignmentURL;
  } else {
    uRL = androidUriConstants.billingAssignmentURL;
  }
  try {
    final response = await dio.get(uRL);
    debugPrint('BillingAssignment Response is - ${response.data}');
    final parsed = jsonDecode(response.data).cast<Map<String, dynamic>>();
    return parsed
        .map<BillingAssignment>((json) => BillingAssignment.fromJson(json))
        .toList();
  } on DioError catch (e) {
    debugPrint("BillingAssignment Error code: ${e.response?.statusCode}");
    throw Exception("Failed to get assignment list");
  }
}

// Create new BillingAssignment in the database:

Future createBillingAssignmentInDatabase(BillingAssignment assignment) async {
  final Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      contentType: 'application/json',
      responseType: ResponseType.plain));
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingAssignmentURL;
  } else {
    uRL = androidUriConstants.billingAssignmentURL;
  }
  try {
    final response = await dio.post(
      uRL,
      data: jsonEncode(assignment.toJson()),
    );
    debugPrint('Assignment Status code: ${response.toString()}');
    debugPrint('Assignment Status msg: ${response.statusMessage}');
    debugPrint('Assignment response.data: ${response.data}');
    return response.data;
  } on DioError catch (e) {
    debugPrint("Assignment Status code: ${e.response?.statusCode}");
    throw Exception("Failed to create assignment");
  }
}

// Delete a BillingAssignment from database by ID:

void deleteBillingAssignment(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingAssignmentURL;
  } else {
    uRL = androidUriConstants.billingAssignmentURL;
  }
  try {
    await dio.delete("$uRL/$id/");
    debugPrint('Deleted successfully');
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to delete BillingAssignment: $id");
  }
}

Future<BillingAssignment> getBillingAssignmentByID(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingAssignmentURL;
  } else {
    uRL = androidUriConstants.billingAssignmentURL;
  }
  try {
    final response = await dio.get("$uRL/$id/");
    debugPrint(response.toString());
    return BillingAssignment.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to load BillingAssignment: $id");
  }
}

// Put request to update BillingAssignment in the database by ID:

Future<BillingAssignment> putBillingAssignmentByID(
    BillingAssignment assignment, int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingAssignmentURL;
  } else {
    uRL = androidUriConstants.billingAssignmentURL;
  }
  try {
    final response =
        await dio.put("$uRL/$id/", data: jsonEncode(assignment.toJson()));
    debugPrint('BillingAssignment updated: ${response.data}');
    return BillingAssignment.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to update BillingAssignment: $id");
  }
}
