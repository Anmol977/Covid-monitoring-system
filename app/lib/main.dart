import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'constants/api.dart';
import 'constants/parameters.dart';
import 'constants/preferences.dart';
import 'constants/routes.dart';
import 'constants/strings.dart';
import 'constants/theme.dart';
import 'models/doctor.dart';
import 'mqtt/MQTTAppState.dart';
import 'provider/patient.dart';
import 'screens/doctor_home/home.dart';
import 'screens/patient_home/home.dart';
import 'screens/selector/selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => MQTTAppState(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Patients(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 808),
        builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Strings.appTitle,
          theme: theme(),
          routes: routes,
          home: AnimatedSplashScreen.withScreenFunction(
            splash: 'assets/launch_screen.png',
            screenFunction: () async {
              Map<String, dynamic> response;
              try {
                if (await Token.isTokenAlreadySet()) {
                  String scope = await Token.getScope();
                  if (scope == Strings.patientScope) {
                    response = await Api.patientAutoLogin();
                    if (response[Api.error].isEmpty) {
                      Provider.of<Patients>(context, listen: false)
                          .setCurrentPatient = response;
                      return const PatientHomeScreen();
                    }
                  }
                  if (scope == Strings.doctorScope) {
                    response = await Api.doctorAutoLogin();
                    if (response[Api.error].isEmpty) {
                      Doctor.currentDoctorId =
                          response[Api.data][Parameters.id];
                      return const DoctorHomeScreen();
                    }
                  }
                }
              } catch (e) {
                debugPrint(e.toString());
              }
              return const SelectorScreen();
            },
          ),
        ),
      ),
    );
  }
}
