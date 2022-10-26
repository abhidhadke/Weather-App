import 'package:flutter/material.dart';
import 'package:wheather/pages/home.dart';
import 'package:wheather/pages/loading.dart';

void main() {
  runApp( MaterialApp(
    initialRoute: "/",
    routes: {
      "/" : (context) => Loading(),
      "/home" : (context) => Home(),
    },
  ));
}
