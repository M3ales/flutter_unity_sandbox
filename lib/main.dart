import 'package:flutter/material.dart';
import 'package:flutter_unity_sandbox/dashboard.dart';

import 'unity_wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/unity': (BuildContext context) => UnityWrapper(),
      },
      home: Dashboard()
    );
  }
}