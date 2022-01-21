import 'package:covmon/constants/parameters.dart';
import 'package:covmon/constants/strings.dart';

class Patient {
  String id;
  String fullName;
  String roomNo;

  Patient({
    required this.id,
    required this.fullName,
    required this.roomNo,
  });

  factory Patient.empty() => Patient(
        id: Strings.empty,
        fullName: Strings.empty,
        roomNo: Strings.empty,
      );

  factory Patient.fromMap(Map data) => Patient(
        id: data[Parameters.id] ?? Strings.empty,
        fullName: data[Parameters.fullName] ?? Strings.empty,
        roomNo: data[Parameters.roomNo] ?? Strings.empty,
      );
}
