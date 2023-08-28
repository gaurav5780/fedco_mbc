import 'dart:convert';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:flutter/material.dart';
import '../models/area.dart';

// Get all the areas in the database:

Future<List<Area>> getAllAreas() async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.areaURL;
  } else {
    uRL = androidUriConstants.areaURL;
  }
  try {
    final response = await dio.get(uRL);
    debugPrint(response.data.toString());
    return Area.listFromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to get areas");
  }
}

// Create new area in the database:

Future<Area> createAreaInDatabase(Area newArea) async {
  final Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.areaURL;
  } else {
    uRL = androidUriConstants.areaURL;
  }
  try {
    final response = await dio.post(
      uRL,
      data: newArea.toJson(),
    );
    return Area.fromJson(json.decode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to create area");
  }
}

// Get area by ID from the database:

Future<Area> getAreaByID(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.areaURL;
  } else {
    uRL = androidUriConstants.areaURL;
  }
  try {
    final response = await dio.get("$uRL/$id/");
    debugPrint(response.toString());
    return Area.fromJson(response.data);
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to load area: $id");
  }
}

// Delete an area from database by area ID:

void deleteArea(int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.areaURL;
  } else {
    uRL = androidUriConstants.areaURL;
  }
  try {
    await dio.delete("$uRL/$id/");
    debugPrint('Deleted successfully');
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to delete area: $id");
  }
}

// Put request to update Area in the database by ID:

Future<Area> putAreaByID(Area area, int id) async {
  Dio dio = Dio();
  dio.options.headers['content-Type'] = 'application/json';
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.areaURL;
  } else {
    uRL = androidUriConstants.areaURL;
  }
  try {
    final response = await dio.put("$uRL/$id/", data: area.toJson());
    debugPrint('Area updated: ${response.data}');
    return Area.fromJson(response.data);
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode}");
    throw Exception("Failed to update user: $id");
  }
}
