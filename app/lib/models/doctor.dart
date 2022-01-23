import 'package:covmon/constants/parameters.dart';
import 'package:covmon/constants/strings.dart';

class Doctor {
  String id;
  String fullName;
  String email;
  String phoneNumber;

  Doctor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory Doctor.empty() => Doctor(
        id: Strings.empty,
        fullName: Strings.empty,
        email: Strings.empty,
        phoneNumber: Strings.empty,
      );

  factory Doctor.fromMap(Map data) => Doctor(
        id: data[Parameters.id] ?? Strings.empty,
        fullName: data[Parameters.fullName] ?? Strings.empty,
        email: data[Parameters.email] ?? Strings.empty,
        phoneNumber: data[Parameters.phoneNumber] ?? Strings.empty,
      );

  Map<String, dynamic> toMap() => {
        Parameters.id: id,
        Parameters.fullName: fullName,
        Parameters.email: email,
        Parameters.phoneNumber: phoneNumber,
      };
}
