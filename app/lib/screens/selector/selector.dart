import 'package:covmon/constants/assets.dart';
import 'package:covmon/constants/routes.dart';
import 'package:covmon/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectorScreen extends StatefulWidget {
  const SelectorScreen({Key? key}) : super(key: key);

  @override
  _SelectorScreenState createState() => _SelectorScreenState();
}

class _SelectorScreenState extends State<SelectorScreen> {
  bool isDoctor = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.05.sh),
              SvgPicture.asset(
                Assets.undrawdocs,
                height: 0.5.sh,
              ),
              Text(
                Strings.continueAs,
                style: TextStyle(
                  fontSize: 26.sp,
                ),
              ),
              SizedBox(height: 20.h),
              DropdownButton<bool>(
                isExpanded: true,
                onChanged: (value) {
                  isDoctor = value!;
                  Navigator.pushNamed(
                    context,
                    Routes.login,
                    arguments: isDoctor,
                  );
                },
                value: false,
                itemHeight: 0.1.sh,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      Strings.patient,
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    value: false,
                  ),
                  DropdownMenuItem(
                    child: Text(
                      Strings.doctor,
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    value: true,
                  ),
                ],
              ),
              /* TextButton( */
              /*   onPressed: () { */
              /*     setState(() { */
              /*       isDoctor = false; */
              /*     }); */
              /*     Navigator.pushNamed( */
              /*       context, */
              /*       Routes.login, */
              /*       arguments: isDoctor, */
              /*     ); */
              /*   }, */
              /*   child: Row( */
              /*     mainAxisAlignment: MainAxisAlignment.spaceEvenly, */
              /*     children: const [ */
              /*       Text(Strings.patient), */
              /*       Icon(Icons.chevron_right), */
              /*     ], */
              /*   ), */
              /* ), */
              /* SizedBox(height: 10.h), */
              /* TextButton( */
              /*   onPressed: () { */
              /*     setState(() { */
              /*       isDoctor = true; */
              /*     }); */
              /*     Navigator.pushNamed( */
              /*       context, */
              /*       Routes.login, */
              /*       arguments: isDoctor, */
              /*     ); */
              /*   }, */
              /*   child: Row( */
              /*     mainAxisAlignment: MainAxisAlignment.spaceEvenly, */
              /*     children: const [ */
              /*       Text(Strings.doctor), */
              /*       Icon(Icons.chevron_right), */
              /*     ], */
              /*   ), */
              /* ), */
            ],
          ),
        ),
      ),
    );
  }
}
