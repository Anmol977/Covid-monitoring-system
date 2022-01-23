import 'package:covmon/constants/strings.dart';
import 'package:covmon/constants/utils.dart';
import 'package:covmon/models/patient.dart';
import 'package:flutter/material.dart';

class PatientVitals extends StatelessWidget {
  final Patient patient;
  const PatientVitals(this.patient, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: statusColor(patient.status),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(patient.fullName),
                Text(Strings.roomNo + patient.roomNo),
              ],
            ),
            Text(Strings.temperature + Strings.colon + patient.temperature),
            Text(Strings.spo2level + Strings.colon + patient.spO2),
            Text(Strings.pulseRate + Strings.colon + patient.pulseRate),
            Text(Strings.heartRate + Strings.colon + patient.heartRate),
            Text(patient.lastUpdated),
          ],
        ),
      ),
    );
  }
}
