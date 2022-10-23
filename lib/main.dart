import 'package:flutter/material.dart';
import 'package:wheather/pages/home.dart';
import 'package:wheather/pages/loading.dart';
import 'package:wheather/pages/choose_location.dart';

void main() {
  runApp( MaterialApp(
    initialRoute: "/",
    routes: {
      "/" : (context) => Loading(),
      "/home" : (context) => Home(),
    },
  ));
}
