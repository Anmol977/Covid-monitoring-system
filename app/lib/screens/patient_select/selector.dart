import 'package:covmon/constants/api.dart';
import 'package:covmon/constants/strings.dart';
import 'package:flutter/material.dart';

class PatientSelect extends StatefulWidget {
  const PatientSelect({Key? key}) : super(key: key);

  @override
  _PatientSelectState createState() => _PatientSelectState();
}

class _PatientSelectState extends State<PatientSelect> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.patientSelect),
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
          future: Api.fetchPatientList(),
          builder: (context, snapshot) {
            return Container();
          },
        ),
      ),
    );
  }
}
