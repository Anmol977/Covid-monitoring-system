import 'package:covmon/constants/colors.dart';
import 'package:covmon/constants/mqtt.dart';
import 'package:covmon/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.home),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: Strings.notifyDoctor,
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            print("Doctor evolved into The FLASH!!!");
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
            future: MQTTBroker.configureMQTT(),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPatientInfo(Strings.temperature, Strings.zero),
                  _buildPatientInfo(Strings.spo2level, Strings.zero),
                  _buildPatientInfo(Strings.pulseRate, Strings.zero),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfo(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(data),
      ],
    );
  }
}
