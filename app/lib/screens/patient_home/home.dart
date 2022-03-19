import 'dart:convert';

import 'package:covmon/constants/api.dart';
import 'package:covmon/constants/colors.dart';
import 'package:covmon/constants/mqtt.dart';
import 'package:covmon/constants/parameters.dart';
import 'package:covmon/constants/preferences.dart';
import 'package:covmon/constants/routes.dart';
import 'package:covmon/constants/socket.dart';
import 'package:covmon/constants/strings.dart';
import 'package:covmon/models/patient.dart';
import 'package:covmon/provider/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  Patient patient = Patient.empty();
  @override
  void initState() {
    SocketIO.connectToServer();
    super.initState();
  }

  @override
  void dispose() async {
    SocketIO.socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.home),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: AppColors.grayWeb,
              onPressed: () async {
                Token.reset();
                // Urgent change Required
                await Api.savePatientVitals(patient);
                /* SocketIO.socket.dispose(); */
                Navigator.pushReplacementNamed(context, Routes.select);
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: Strings.notifyDoctor,
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            debugPrint("Doctor evolved into The FLASH!!!");
          },
          child: Icon(
            Icons.notifications_on_outlined,
            size: 40.r,
            color: AppColors.backgroundColor,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.05.sw,
            vertical: 0.1.sw,
          ),
          child: FutureBuilder(
            future: MQTTBroker.configureMQTT(
              context: context,
              topics: Strings.topics,
            ),
            builder: (context, snapshot) {
              patient = Provider.of<Patients>(context).currentPatient;
              if (SocketIO.socket.connected) {
                SocketIO.sendData('patientDoctorId', patient.doctorId);
                SocketIO.sendData(
                    'sendVitalsToDoctor',
                    json.encode(
                      <String, String>{
                        Parameters.patientId: patient.id,
                        Parameters.doctorId: patient.doctorId,
                        Parameters.temperature: patient.temperature,
                        Parameters.spO2: patient.spO2,
                        Parameters.heartRate: patient.heartRate,
                      },
                    ));
              }
              return GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 0.05.sw,
                crossAxisSpacing: 0.05.sw,
                children: [
                  _buildPatientInfo(Strings.temperature, patient.temperature),
                  _buildPatientInfo(Strings.spo2level, patient.spO2),
                  _buildPatientInfo(Strings.heartRate, patient.heartRate),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfo(String title, String data) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.r),
      ),
      color: AppColors.tertiaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            SizedBox(
              height: 0.05.sw,
            ),
            Text(
              data,
              style: TextStyle(
                fontSize: 50.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
