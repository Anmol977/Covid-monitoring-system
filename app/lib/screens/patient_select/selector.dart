import 'dart:convert';

import 'package:covmon/constants/api.dart';
import 'package:covmon/constants/routes.dart';
import 'package:covmon/constants/strings.dart';
import 'package:covmon/constants/utils.dart';
import 'package:covmon/models/patient.dart';
import 'package:covmon/provider/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'components/patient_list_item.dart';

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
            if (patients.isEmpty) {
              patients = snapshot.data ?? [];
            }
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: const Text(Strings.cont),
                      onPressed: () async {
                        Map<String, dynamic> response =
                            await Api.assignPatients(json.encode(
                                Provider.of<Patients>(context, listen: false)
                                    .patientIds));
                        if (!hasError(context, response)) {
                          Navigator.pushReplacementNamed(
                              context, Routes.doctorHome);
                        }
                      },
                    ),
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
