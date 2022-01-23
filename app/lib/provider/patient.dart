import 'package:covmon/constants/api.dart';
import 'package:covmon/constants/parameters.dart';
import 'package:covmon/models/patient.dart';
import 'package:flutter/material.dart';

class Patients with ChangeNotifier {
  final List<Patient> _patients = [];

  List<Patient> get patients {
    return _patients;
  }

  void addPatient(Patient patient) {
    if (!_patients.contains(patient)) {
      _patients.add(patient);
      notifyListeners();
    }
  }

  void removePatient(Patient patient) {
    _patients.remove(patient);
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
