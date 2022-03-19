import 'package:covmon/constants/parameters.dart';
import 'package:covmon/models/doctor.dart';
import 'package:flutter/material.dart';

class Doctors with ChangeNotifier {
  Doctor _currentDoctor = Doctor.empty();

  Doctor get currentDoctor {
    return _currentDoctor;
  }

  set setCurrentDoctor(Map<String, dynamic> doctorDataMap) {
    _currentDoctor = Doctor.fromMap(doctorDataMap[Parameters.data]);
  }
}
