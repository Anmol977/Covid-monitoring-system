import 'package:http/http.dart' as http;

import 'parameters.dart';

class Api {
  static const _ipaddress = "192.168.29.24";
  static const String _host = "http://" + _ipaddress + ":5000/";

  static const String _patientLogin = "patient/login/email";
  static const String _patientSignup = "patient/signUp";

  static Future<void> patientSignup(String email, String name, String password,
      String dob, String roomNo) async {
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
    print(response.body);
  }

  static Future<void> patientLogin(
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
    print(response.body);
    // May cause errors
    print(response.headers[Parameters.cookie]!.split(";")[0].split("=")[1]);
  }
}
