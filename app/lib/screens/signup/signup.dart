import 'package:covmon/constants/api.dart';
import 'package:covmon/constants/routes.dart';
import 'package:covmon/constants/strings.dart';
import 'package:covmon/constants/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  final _formKey = GlobalKey<FormState>();

  bool obscureText = true, obscureConfirmText = true, isDoctor = false;
  String email = Strings.empty,
      name = Strings.empty,
      password = Strings.empty,
      confirmPassword = Strings.empty,
      phoneNumber = Strings.empty,
      roomNo = Strings.empty;
  DateTime dob = DateTime.now();

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
                  isDoctor
                      ? SizedBox(height: 0.07.sh)
                      : SizedBox(height: 0.02.sh),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(Strings.signupAs),
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
                        return Strings.enterName;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                    onFieldSubmitted: (_) {
                      focusNodes[0].requestFocus();
                    },
                    maxLength: 50,
                    decoration: const InputDecoration(
                      counterText: Strings.empty,
                      labelText: Strings.name,
                      hintText: Strings.fullName,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 30.h),
                  TextFormField(
                    focusNode: focusNodes[0],
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
                      focusNodes[1].requestFocus();
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
                    focusNode: focusNodes[1],
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
                    onFieldSubmitted: (_) {
                      focusNodes[2].requestFocus();
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
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 30.h),
                  TextFormField(
                    focusNode: focusNodes[2],
                    obscureText: obscureConfirmText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.confirmPassword;
                      }
                      if (password != confirmPassword) {
                        return Strings.passwordMismatch;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      confirmPassword = value!;
                    },
                    maxLength: 50,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          child: Icon(
                            obscureConfirmText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onTap: () {
                            setState(() {
                              obscureConfirmText = !obscureConfirmText;
                            });
                          }),
                      counterText: Strings.empty,
                      labelText: Strings.confirmPassword,
                      hintText: Strings.confirmPassword,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 30.h),
                  isDoctor
                      ? TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return Strings.enterPhone;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phoneNumber = value!;
                          },
                          maxLength: 50,
                          decoration: const InputDecoration(
                            counterText: Strings.empty,
                            labelText: Strings.phoneNumber,
                            hintText: Strings.phoneNumber,
                          ),
                          textInputAction: TextInputAction.done,
                        )
                      : TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return Strings.enterRoom;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            roomNo = value!;
                          },
                          maxLength: 50,
                          decoration: const InputDecoration(
                            counterText: Strings.empty,
                            labelText: Strings.roomNumber,
                            hintText: Strings.roomNumber,
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                  SizedBox(height: 30.h),
                  isDoctor
                      ? Container()
                      : TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return Strings.enterDob;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            roomNo = value!;
                          },
                          maxLength: 50,
                          decoration: const InputDecoration(
                            counterText: Strings.empty,
                            labelText: Strings.dob,
                            hintText: Strings.dob,
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                  SizedBox(height: 40.h),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (isDoctor) {
                          await Api.doctorSignup(
                            email,
                            name,
                            password,
                            "8800527903",
                          );
                        } else {
                          await Api.patientSignup(
                            email,
                            name,
                            password,
                            "10/02/2002",
                            "201",
                          );
                        }
                        /* Navigator.pushReplacementNamed(context, Routes.home); */
                      }
                    },
                    child: const Text(Strings.signup),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(Strings.alreadyAccount),
                      TextButton(
                        style: inLineTextButtonTheme(),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.login);
                        },
                        child: const Text(Strings.login),
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
