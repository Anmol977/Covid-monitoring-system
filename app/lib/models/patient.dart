import 'package:covmon/constants/parameters.dart';
import 'package:covmon/constants/strings.dart';

class Patient {
  String id;
  String fullName;
  String roomNo;
  String spO2;
  String lastUpdated;
  String heartRate;
  String pulseRate;
  String temperature;
  String status;
  String doctorId;

  Patient({
    required this.id,
    required this.fullName,
    required this.roomNo,
    required this.spO2,
    required this.lastUpdated,
    required this.heartRate,
    required this.temperature,
    required this.status,
    required this.pulseRate,
    required this.doctorId,
  });

  factory Patient.empty() => Patient(
        id: Strings.empty,
        fullName: Strings.empty,
        roomNo: Strings.empty,
        heartRate: Strings.empty,
        lastUpdated: Strings.empty,
        spO2: Strings.empty,
        status: Strings.empty,
        temperature: Strings.empty,
        pulseRate: Strings.empty,
        doctorId: Strings.empty,
      );

  factory Patient.fromMap(Map data) => Patient(
        id: data[Parameters.id] ?? Strings.empty,
        fullName: data[Parameters.fullName] ?? Strings.empty,
        roomNo: data[Parameters.roomNo] ?? Strings.empty,
        heartRate: data[Parameters.heartRate] ?? Strings.empty,
        lastUpdated: data[Parameters.lastUpdated] ?? Strings.empty,
        spO2: data[Parameters.spO2] ?? Strings.empty,
        status: data[Parameters.status] ?? Strings.empty,
        temperature: data[Parameters.temperature] ?? Strings.empty,
        pulseRate: data[Parameters.pulseRate] ?? Strings.empty,
        doctorId: data[Parameters.doctorId] ?? Strings.empty,
      );

  Map<String, dynamic> toMap() => {
        Parameters.id: id,
        Parameters.fullName: fullName,
        Parameters.roomNo: roomNo,
        Parameters.spO2: spO2,
        Parameters.lastUpdated: lastUpdated,
        Parameters.heartRate: heartRate,
        Parameters.temperature: temperature,
        Parameters.status: status,
        Parameters.pulseRate: pulseRate,
        Parameters.doctorId: doctorId,
      };
}
