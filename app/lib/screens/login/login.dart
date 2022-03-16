import 'dart:io';

import 'package:covmon/constants/api.dart';
import 'package:covmon/constants/parameters.dart';
import 'package:covmon/constants/preferences.dart';
import 'package:covmon/constants/routes.dart';
import 'package:covmon/constants/strings.dart';
import 'package:covmon/constants/utils.dart';
import 'package:covmon/models/doctor.dart';
import 'package:covmon/provider/doctor.dart';
import 'package:covmon/provider/patient.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  String email = Strings.empty, password = Strings.empty;

  @override
  Widget build(BuildContext context) {
    final bool isDoctor = ModalRoute.of(context)!.settings.arguments as bool;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 0.3.sh),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.enterEmail;
                      } else if (!value.contains(Strings.atTheRate)) {
                        return Strings.invalidEmail;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                    onFieldSubmitted: (_) {
                      focusNode.requestFocus();
                    },
                    maxLength: 50,
                    decoration: const InputDecoration(
                      counterText: Strings.empty,
                      labelText: Strings.email,
                      hintText: Strings.emailAddress,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 30.h),
                  TextFormField(
                    focusNode: focusNode,
                    obscureText: obscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.enterPassword;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                    maxLength: 50,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          child: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          }),
                      counterText: Strings.empty,
                      labelText: Strings.password,
                      hintText: Strings.password,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 40.h),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Map<String, dynamic> response;
                        if (isDoctor) {
                          response = await Api.doctorLogin(
                            email,
                            password,
                          );
                        } else {
                          response = await Api.patientLogin(
                            email,
                            password,
                          );
                        }
                        Token.setScope(
                            response[Parameters.scope] ?? Strings.empty);
                        try {
                          if (!hasError(context, response)) {
                            if (isDoctor) {
                              Provider.of<Doctors>(context, listen: false)
                                  .setCurrentDoctor = response;
                              Doctor.currentDoctorId =
                                  response[Api.data][Parameters.id];
                              Navigator.pushReplacementNamed(
                                  context, Routes.doctorHome);
                            } else {
                              Provider.of<Patients>(context, listen: false)
                                  .setCurrentPatient = response;
                              Navigator.pushReplacementNamed(
                                  context, Routes.patientHome);
                            }
                          }
                        } on SocketException {
                          showErrorSnackBar(context, Strings.noNetwork);
                        }
                      }
                    },
                    child: const Text(Strings.login),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(Strings.noAccount),
                      TextButton(
                        style: inLineTextButtonTheme(),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.signup,
                            arguments: isDoctor,
                          );
                        },
                        child: const Text(Strings.signup),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
