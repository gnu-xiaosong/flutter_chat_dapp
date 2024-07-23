import 'package:flutter/material.dart';
import '../../pages/adaptive/Home.dart';

class AdaptiveLayout extends StatefulWidget {
  @override
  State<AdaptiveLayout> createState() => AdaptiveLayoutState();
}

class AdaptiveLayoutState extends State<AdaptiveLayout> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: AdaptiveHome(),
    );
  }
}
