import 'dart:convert';

import 'package:covmon/constants/preferences.dart';
import 'package:covmon/constants/strings.dart';
import 'package:covmon/models/doctor.dart';
import 'package:covmon/models/patient.dart';
import 'package:http/http.dart' as http;

import 'parameters.dart';

class Api {
  static const _ipaddress = '192.168.0.104'; //0.104';
  static const String _host = 'http://' + _ipaddress + ':5000/';

  static const String _patientLogin = 'patient/login/email';
  static const String _patientSignup = 'patient/signUp';

  static const String _doctorLogin = 'doctor/login/email';
  static const String _doctorSignup = 'doctor/signUp';
  static const String _getPatientVitals = 'doctor/getPatientVitals';

  static const String _patientList = 'patients/list';
  static const String _assignPatients = 'assignPatients';
  static const String _savePatientVitals = 'savePatientVitals';

  static const String error = 'error';
  static const String data = 'data';
  static const String message = 'message';

  static String get ip {
    return _ipaddress;
  }

  static Future<Map<String, dynamic>> patientSignup(
    String email,
    String name,
    String password,
    String dob,
    String phoneNumber,
    String roomNo,
  ) async {
    http.Response response = await http.post(
      Uri.parse(_host + _patientSignup),
      body: {
        Parameters.email: email.trim(),
        Parameters.fullName: name.trim(),
        Parameters.password: password.trim(),
        Parameters.dob: dob.trim(),
        Parameters.phoneNumber: phoneNumber.trim(),
        Parameters.roomNo: roomNo.trim(),
      },
    );
    if (response.headers[Parameters.cookie] != null) {
      Token.setToken(
        response.headers[Parameters.cookie]!.split(";")[0].split("=")[1],
      );
    }
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> patientAutoLogin() async {
    http.Response response = await http.post(
      Uri.parse(_host + _patientLogin),
      headers: {
        Strings.authorization: Token.bearerToken,
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
    if (response.headers[Parameters.cookie] != null) {
      Token.setToken(
        response.headers[Parameters.cookie]!.split(";")[0].split("=")[1],
      );
    }
    return json.decode(response.body);
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
    // Beauty chain
    if (response.headers[Parameters.cookie] != null) {
      Token.setToken(
        response.headers[Parameters.cookie]!.split(";")[0].split("=")[1],
      );
    }
    return json.decode(response.body);
  }

  static Future<void> savePatientVitals(Patient patient) async {
    await http.post(
      Uri.parse(_host + _savePatientVitals),
      body: {
        Parameters.heartRate: patient.heartRate,
        Parameters.SpO2: patient.spO2,
        Parameters.temperature: patient.temperature,
        Parameters.status: patient.status,
      },
      headers: {
        Strings.authorization: Token.bearerToken,
      },
    );
  }

  static Future<Map<String, dynamic>> doctorAutoLogin() async {
    http.Response response = await http.post(
      Uri.parse(_host + _doctorLogin),
      headers: {
        Strings.authorization: Token.bearerToken,
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
    if (response.headers[Parameters.cookie] != null) {
      Token.setToken(
        response.headers[Parameters.cookie]!.split(";")[0].split("=")[1],
      );
    }
    return json.decode(response.body);
  }

  static Future<List<Patient>> fetchPatientList() async {
    http.Response response = await http.get(
      Uri.parse(_host + _patientList),
      headers: {
        Strings.authorization: Token.bearerToken,
      },
    );
    Map<String, dynamic> result = json.decode(response.body);
    List<Patient> patients = [];
    result[Parameters.data].forEach((patientData) {
      patients.add(Patient.fromMap(patientData));
    });
    return patients;
  }

  /* static Future<Map<String, dynamic>> getPatientsVitals() async { */
  /*   http.Response response = await http.get( */
  /*     Uri.parse(_host + _getPatientVitals), */
  /*     headers: { */
  /*       Strings.authorization: Token.bearerToken, */
  /*     }, */
  /*   ); */
  /*   return json.decode(response.body); */
  /* } */

  static Future<Map<String, dynamic>> assignPatients(String patients) async {
    http.Response response = await http.post(
      Uri.parse(_host + _assignPatients),
      headers: {
        Strings.authorization: Token.bearerToken,
      },
      body: {
        Parameters.id: Doctor.currentDoctorId,
        Parameters.patientsList: patients,
      },
    );
    return json.decode(response.body);
  }
}
