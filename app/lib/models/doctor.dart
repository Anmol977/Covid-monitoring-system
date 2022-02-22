import 'dart:convert';

import 'package:covmon/constants/parameters.dart';
import 'package:covmon/constants/strings.dart';

class Doctor {
  static String currentDoctorId = Strings.empty;
  String id;
  String fullName;
  String email;
  String phoneNumber;
  List<String> patientsAssigned;

  Doctor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.patientsAssigned,
  });

  factory Doctor.empty() => Doctor(
        id: Strings.empty,
        fullName: Strings.empty,
        email: Strings.empty,
        phoneNumber: Strings.empty,
        patientsAssigned: List.empty(),
      );

  factory Doctor.fromMap(Map data) => Doctor(
        id: data[Parameters.id] ?? Strings.empty,
        fullName: data[Parameters.fullName] ?? Strings.empty,
        email: data[Parameters.email] ?? Strings.empty,
        phoneNumber: data[Parameters.phoneNumber] ?? Strings.empty,
        patientsAssigned:
            json.decode(data[Parameters.patientsAssigned]).cast<String>() ??
                List.empty(),
      );

  Map<String, dynamic> toMap() => {
        Parameters.id: id,
        Parameters.fullName: fullName,
        Parameters.email: email,
        Parameters.phoneNumber: phoneNumber,
        Parameters.patientsAssigned: patientsAssigned.toString(),
      };
}
