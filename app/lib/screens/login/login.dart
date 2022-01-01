import 'package:covmon/constants/api.dart';
import 'package:covmon/constants/routes.dart';
import 'package:covmon/constants/strings.dart';
import 'package:covmon/constants/utils.dart';
import 'package:covmon/mqtt/mqttView.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true, isDoctor = false;
  String email = Strings.empty, password = Strings.empty;

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(Strings.loginAs),
                      SizedBox(width: 0.05.sw),
                      const Text(Strings.patient),
                      Switch(
                        value: isDoctor,
                        onChanged: (value) {
                          setState(() {
                            isDoctor = value;
                          });
                        },
                      ),
                      const Text(Strings.doctor),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.enterEmail;
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
                        if (isDoctor) {
                          await Api.doctorLogin(
                            email,
                            password,
                          );
                        } else {
                          await Api.patientLogin(
                            email,
                            password,
                          );
                        }
                        // Temporary for mqtt testing
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MQTTView()));
                        /* Navigator.pushReplacementNamed(context, Routes.home); */
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
                              context, Routes.signup);
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
