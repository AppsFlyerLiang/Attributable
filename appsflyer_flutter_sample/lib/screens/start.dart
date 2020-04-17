import 'package:flutter/material.dart';
import 'package:fluttersample/MyApp.dart';

import 'home.dart';

class Start extends StatelessWidget {
  final InitResult result;
  Start(this.result): assert(result!=null);

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch(result) {
      case InitResult.normal:
        screen = Home();
        break;
      default:
        screen = Home();
        break;
    }
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.green,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.black54,
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.green,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.green.withAlpha(20),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: screen,
    );
  }
}
