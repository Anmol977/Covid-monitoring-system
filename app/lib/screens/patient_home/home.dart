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
            future: MQTTBroker.configureMQTT(),
            builder: (context, snapshot) {
              return SizedBox(
                height: 1.sh,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 0.5.sh,
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0.05.sw,
                          crossAxisSpacing: 0.05.sw,
                          children: [
                            _buildPatientInfo(
                                Strings.temperature, Strings.zero),
                            _buildPatientInfo(Strings.spo2level, Strings.zero),
                            _buildPatientInfo(Strings.pulseRate, Strings.zero),
                            _buildPatientInfo(Strings.pulseRate, Strings.zero),
                          ],
                        ),
                      ),
                      SizedBox(height: 0.05.sw),
                      const Text(Strings.status + "Beauty"),
                      SizedBox(height: 0.05.sw),
                      const Text(Strings.assignedDoctor + "Dr. Sweet Lark"),
                    ],
                  ),
                ),
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
