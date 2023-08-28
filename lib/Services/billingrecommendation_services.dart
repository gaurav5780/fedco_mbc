import 'dart:convert';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/billing_recommendation.dart';
import 'package:flutter/material.dart';

// Get all the Billing Recommendations in the database:

Future<List<BillingRecommendation>> getAllBillingRecommendations() async {
  Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      contentType: 'application/json',
      responseType: ResponseType.plain));
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingRecommendationURL;
  } else {
    uRL = androidUriConstants.billingRecommendationURL;
  }
  try {
    final response = await dio.get(uRL);
    debugPrint('Response is - ${response.data}');
    final parsed = jsonDecode(response.data).cast<Map<String, dynamic>>();
    return parsed
        .map<BillingRecommendation>(
            (json) => BillingRecommendation.fromJson(json))
        .toList();
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to get Billing Recommendations");
  }
}

// Create new Billing Recommendation in the database:

Future<BillingRecommendation> createBillingRecommendationInDatabase(
    BillingRecommendation newRecommendation) async {
  final Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingRecommendationURL;
  } else {
    uRL = androidUriConstants.billingRecommendationURL;
  }
  try {
    final response = await dio.post(
      uRL,
      data: jsonEncode(newRecommendation.toJson()),
    );
    debugPrint(response.toString());
    debugPrint(response.statusMessage);
    debugPrint(response.statusCode.toString());
    return BillingRecommendation.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to create Recommendation");
  }
}

// Get Billing Recommendation by ID from the database:

Future<BillingRecommendation> getBillingRecommendationByID(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingRecommendationURL;
  } else {
    uRL = androidUriConstants.billingRecommendationURL;
  }
  try {
    final response = await dio.get("$uRL/$id/");
    debugPrint(response.toString());
    return BillingRecommendation.fromJson(response.data);
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to load Billing Recommendation: $id");
  }
}

// Delete a Billing Recommendation from database by Recommendation ID:

void deleteBillingRecommendation(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingRecommendationURL;
  } else {
    uRL = androidUriConstants.billingRecommendationURL;
  }
  try {
    await dio.delete("$uRL/$id/");
    debugPrint('Deleted successfully');
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to delete Recommendation: $id");
  }
}

// Put request to update BillingRecommendation in the database by ID:

Future putBillingRecommendationByID(
    BillingRecommendation recommendation, int id) async {
  Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      contentType: 'application/json',
      responseType: ResponseType.plain));
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.billingRecommendationURL;
  } else {
    uRL = androidUriConstants.billingRecommendationURL;
  }
  try {
    final response =
        await dio.put("$uRL/$id/", data: jsonEncode(recommendation.toJson()));
    debugPrint('BillingRecommendation updated: ${response.data}');
    return response.data;
    //return BillingRecommendation.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("BillingRecommendation Status code: ${e.response?.statusCode}");
    throw Exception("Failed to update BillingRecommendation: $id");
  }
}
