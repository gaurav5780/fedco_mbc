import 'dart:convert';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/billing_task.dart';
import 'package:flutter/material.dart';

// Get all the BillingTasks from the database:

Future<List<BillingTask>> getAllBillingTasks() async {
  Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      contentType: 'application/json',
      responseType: ResponseType.plain));
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingTaskURL;
  } else {
    uRL = androidUriConstants.billingTaskURL;
  }
  try {
    final response = await dio.get(uRL);
    debugPrint('Response is - ${response.data}');
    final parsed = jsonDecode(response.data).cast<Map<String, dynamic>>();
    return parsed
        .map<BillingTask>((json) => BillingTask.fromJson(json))
        .toList();
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to get task list");
  }
}

// Create new BillingTask in the database:

Future createBillingTaskInDatabase(BillingTask task) async {
  final Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      contentType: 'application/json',
      responseType: ResponseType.plain));
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingTaskURL;
  } else {
    uRL = androidUriConstants.billingTaskURL;
  }
  try {
    final response = await dio.post(
      uRL,
      data: jsonEncode(task.toJson()),
    );
    debugPrint('Task Status code: ${response.toString()}');
    debugPrint('Task Status msg: ${response.statusMessage}');
    debugPrint('Task response.data: ${response.data}');
    return response.data;
  } on DioError catch (e) {
    debugPrint("Task Status code: $e");
    throw Exception("Failed to create task");
  }
}

// Delete a BillingTask from database by ID:

void deleteBillingTask(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingTaskURL;
  } else {
    uRL = androidUriConstants.billingTaskURL;
  }
  try {
    await dio.delete("$uRL/$id/");
    debugPrint('Deleted successfully');
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to delete BillingTask: $id");
  }
}

Future<BillingTask> getBillingTaskByID(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingTaskURL;
  } else {
    uRL = androidUriConstants.billingTaskURL;
  }
  try {
    final response = await dio.get("$uRL/$id/");
    debugPrint(response.toString());
    return BillingTask.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to load BillingTask: $id");
  }
}

// Put request to update BillingTask in the database by ID:

Future<BillingTask> putBillingTaskByID(BillingTask task, int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingTaskURL;
  } else {
    uRL = androidUriConstants.billingTaskURL;
  }
  try {
    final response =
        await dio.put("$uRL/$id/", data: jsonEncode(task.toJson()));
    debugPrint('BillingTask updated: ${response.data}');
    return BillingTask.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to update BillingTask: $id");
  }
}
