import 'package:covmon/constants/strings.dart';
import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.home),
          automaticallyImplyLeading: false,
        ),
        body: Text("Docs"),
      ),
    );
  }
}
