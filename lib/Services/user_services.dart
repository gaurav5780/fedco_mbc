import 'dart:convert';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:fedco_mbc/Constants/constants.dart';
import 'package:fedco_mbc/models/user.dart';
import 'package:flutter/material.dart';

// Get all the users in the database:

Future<List<User>> getAllUsers() async {
  Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      contentType: 'application/json',
      responseType: ResponseType.plain));
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.userURL;
  } else {
    uRL = androidUriConstants.userURL;
  }
  try {
    final response = await dio.get(uRL);
    debugPrint('Response is - ${response.data}');
    final parsed = jsonDecode(response.data).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to get users");
  }
}

// Create new user in the database:

Future<User> createUserInDatabase(User newUser) async {
  final Dio dio = Dio();
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.userURL;
  } else {
    uRL = androidUriConstants.userURL;
  }
  try {
    final response = await dio.post(
      uRL,
      data: jsonEncode(newUser),
    );
    debugPrint(response.toString());
    debugPrint(response.statusMessage);
    debugPrint(jsonDecode(response.data).toString());
    return User.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to create user");
  }
}

// Get user by ID from the database:

Future<User> getUserByID(int userId) async {
  Dio dio = Dio();
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.userURL;
  } else {
    uRL = androidUriConstants.userURL;
  }
  try {
    final response = await dio.get("$uRL/$userId/");
    debugPrint(response.data.toString());
    return User.fromJson(response.data);
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to load user: $userId");
  }
}

// Delete a user from database by user ID:

void deleteUser(int userId) async {
  Dio dio = Dio();
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.userURL;
  } else {
    uRL = androidUriConstants.userURL;
  }
  try {
    await dio.delete("$uRL/$userId/");
    debugPrint('Deleted successfully');
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to delete user: $userId");
  }
}

// Put request to update user in the database by ID:

Future putUserByID(User user, int userId) async {
  Dio dio = Dio();
  String uRL = '';
  if (Platform.isIOS) {
    uRL = iOSUriConstants.userURL;
  } else {
    uRL = androidUriConstants.userURL;
  }
  try {
    final response = await dio.put("$uRL/$userId/", data: jsonEncode(user));
    debugPrint('User updated: ${response.data}');
    //return User.fromJson(jsonDecode(response.data));
  } on DioError catch (e) {
    debugPrint("Status code: ${e.response?.statusCode.toString()}");
    throw Exception("Failed to update user: $userId");
  }
}
