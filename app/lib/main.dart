import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'constants/routes.dart';
import 'constants/strings.dart';
import 'constants/theme.dart';
import 'mqtt/MQTTAppState.dart';

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
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 808),
        builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Strings.appTitle,
          theme: theme(),
          routes: routes,
          initialRoute: Routes.select,
        ),
      ),
    );
  }
}
