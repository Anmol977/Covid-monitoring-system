import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'parameters.dart';
import 'utils.dart';

class Api {
  static const _ipaddress = "192.168.29.24";
  static const String _host = "http://" + _ipaddress + ":5000/";

  static const String _patientLogin = "patient/login/email";
  static const String _patientSignup = "patient/signUp";

  static const String _doctorLogin = "doctor/login/email";
  static const String _doctorSignup = "doctor/signUp";

  static const String error = 'error';
  static const String data = 'data';
  static const String message = 'message';

  static Future<Map<String, dynamic>> patientSignup(
    String email,
    String name,
    String password,
    String dob,
    String roomNo,
  ) async {
    http.Response response = await http.post(
      Uri.parse(_host + _patientSignup),
      body: {
        Parameters.email: email.trim(),
        Parameters.fullName: name.trim(),
        Parameters.password: password.trim(),
        Parameters.dob: dob.trim(),
        Parameters.roomNo: roomNo.trim(),
      },
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> patientLogin(
    String email,
    String password,
  ) async {
    http.Response response = await http.post(
      Uri.parse(_host + _patientLogin),
      body: {
        Parameters.email: email.trim(),
        Parameters.password: password.trim(),
      },
    );
    return json.decode(response.body);
    // May cause errors
    //print(response.headers[Parameters.cookie]!.split(";")[0].split("=")[1]);
  }

  static Future<Map<String, dynamic>> doctorSignup(
    String email,
    String name,
    String password,
    String phoneNumber,
  ) async {
    http.Response response = await http.post(
      Uri.parse(_host + _doctorSignup),
      body: {
        Parameters.email: email.trim(),
        Parameters.fullName: name.trim(),
        Parameters.password: password.trim(),
        Parameters.phoneNumber: phoneNumber.trim(),
      },
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> doctorLogin(
    String email,
    String password,
  ) async {
    http.Response response = await http.post(
      Uri.parse(_host + _doctorLogin),
      body: {
        Parameters.email: email.trim(),
        Parameters.password: password.trim(),
      },
    );
    return json.decode(response.body);
    // May cause errors
    //print(response.headers[Parameters.cookie]!.split(";")[0].split("=")[1]);
  }
}
