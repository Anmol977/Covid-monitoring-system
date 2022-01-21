import 'dart:convert';

import 'package:covmon/constants/api.dart';
import 'package:covmon/constants/strings.dart';
import 'package:covmon/models/patient.dart';
import 'package:covmon/screens/selector/components/patient_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientSelect extends StatefulWidget {
  const PatientSelect({Key? key}) : super(key: key);

  @override
  _PatientSelectState createState() => _PatientSelectState();
}

class _PatientSelectState extends State<PatientSelect> {
  List<Patient> patients = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.patientSelect),
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<List<Patient>>(
          future: Api.fetchPatientList(),
          builder: (context, AsyncSnapshot<List<Patient>> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            patients = snapshot.data ?? [];
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
                  child: patients.isEmpty
                      ? const Text(Strings.noPatient)
                      : ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (context, i) =>
                              PatientListItem(patients[i]),
                        ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    child: const Text(Strings.cont),
                    onPressed: () async {
                      List<String> newPats = [];
                      for (Patient patient in patients) {
                        newPats.add(patient.id);
                      }
                      await Api.assignPatients(json.encode(newPats));
                      await Api.getPatientsVitals();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
