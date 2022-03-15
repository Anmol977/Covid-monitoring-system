import 'package:covmon/constants/api.dart';
import 'package:covmon/constants/parameters.dart';
import 'package:covmon/models/patient.dart';
import 'package:flutter/material.dart';

class Patients with ChangeNotifier {
  final List<String> _patientIds = [];
  Patient _currentPatient = Patient.empty();

  Patient get currentPatient {
    return _currentPatient;
  }

  set setCurrentPatient(Map<String, dynamic> patientDataMap) {
    _currentPatient = Patient.fromMap(patientDataMap[Parameters.data]);
  }

  List<String> get patientIds {
    return _patientIds;
  }

  bool patientAdded(String patientId) {
    return _patientIds.contains(patientId);
  }

  void addPatient(String patientId) {
    if (!_patientIds.contains(patientId)) {
      _patientIds.add(patientId);
      notifyListeners();
    }
  }

  void removePatient(String patientId) {
    _patientIds.remove(patientId);
    notifyListeners();
  }

  Future<List<Patient>> getPatientsVitals() async {
    final List<Patient> _patientsVitals = [];
    Map<String, dynamic> response = await Api.getPatientsVitals();
    response[Parameters.data].forEach((patientData) {
      _patientsVitals.add(Patient.fromMap(patientData));
    });
    return _patientsVitals;
  }
}
