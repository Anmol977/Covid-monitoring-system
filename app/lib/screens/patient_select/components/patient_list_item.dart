import 'package:covmon/constants/colors.dart';
import 'package:covmon/constants/strings.dart';
import 'package:covmon/models/patient.dart';
import 'package:covmon/provider/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PatientListItem extends StatefulWidget {
  final Patient patient;
  const PatientListItem(this.patient, {Key? key}) : super(key: key);

  @override
  _PatientListItemState createState() => _PatientListItemState();
}

class _PatientListItemState extends State<PatientListItem> {
  bool added = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grayWeb,
          borderRadius: BorderRadius.all(
            Radius.circular(25.r),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Checkbox(
                value: added,
                onChanged: (value) {
                  setState(() {
                    added = value!;
                  });
                  if (added) {
                    Provider.of<Patients>(context, listen: false)
                        .addPatient(widget.patient);
                  } else {
                    Provider.of<Patients>(context, listen: false)
                        .removePatient(widget.patient);
                  }
                },
              ),
              Text(widget.patient.fullName),
              Text(Strings.roomNo + widget.patient.roomNo),
            ],
          ),
        ),
      ),
    );
  }
}
