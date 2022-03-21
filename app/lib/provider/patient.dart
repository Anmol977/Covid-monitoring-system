import 'package:covmon/constants/parameters.dart';
import 'package:covmon/models/patient.dart';
import 'package:flutter/material.dart';

class Patients with ChangeNotifier {
  final List<String> _patientIds = [];
  final Map<String, Patient> _patients = {};
  Patient _currentPatient = Patient.empty();

  Patient get currentPatient {
    return _currentPatient;
  }

  set setCurrentPatient(Map<String, dynamic> patientDataMap) {
    _currentPatient = Patient.fromMap(patientDataMap[Parameters.data]);
  }

  Map<String, Patient> get patients {
    return _patients;
  }

  List<String> get patientIds {
    return [..._patientIds];
  }

  void update(String topic, String value) {
    switch (topic) {
      case Parameters.temperature:
        _currentPatient.temperature = value;
        break;
      case Parameters.spO2:
        _currentPatient.spO2 = value;
        break;
      case Parameters.heartRate:
        _currentPatient.heartRate = value;
        break;
    }
    notifyListeners();
  }

  bool patientAdded(String patientId) {
    return _patientIds.contains(patientId);
  }

  void addPatientVitals(Patient patient) {
    _patients[patient.id] = patient;
    notifyListeners();
  }

  void removePatientVitals(Patient patient) {
    _patients.remove(patient);
    notifyListeners();
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
    return _patientsVitals;
  }
}
