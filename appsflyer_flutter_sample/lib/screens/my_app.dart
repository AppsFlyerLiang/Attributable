import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttersample/app_config.dart';
import 'package:fluttersample/screens/deep_link.dart';
import 'package:fluttersample/screens/privacy_policy.dart';
import 'package:fluttersample/screens/splash.dart';
import 'package:fluttersample/utils/page_route_builders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class MyApp extends StatefulWidget {
//  final InitResult initResult;
//  MyApp(this.initResult);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  InitResult initResult;
  @override
  void initState() {
    super.initState();
    AppConfig.initLocal().then((value){
      setState(() {
        initResult = value;
      });
      initRemote();
    });
  }
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppConfig.appData),
      ],
      child: MaterialApp(
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
          routes: {
            '/Home': (context) => Home(),
          },
          home: _homeWidget(),
      ),
    );
  }
  initRemote(){
    if(initResult!=InitResult.askPrivacyPolicy) {
      AppConfig.initRemote().then((value) {
        setState(() {
          initResult = value;
        });
      });
    }
  }
  Widget _homeWidget(){
    print("_homeWidget > $initResult");
    switch(initResult){
      case InitResult.askPrivacyPolicy:
        return PrivacyPolicy(onAgree: (){
          setState(() {
            initResult = null;
          });
          initRemote();
        },);
        break;
      case InitResult.home:
        return Home();
        break;
      case InitResult.splash:
        return Splash();
        break;
      case InitResult.deepLink:
        return DeepLink();
        break;
      default:
        return Splash();
        break;
    }
  }
}
