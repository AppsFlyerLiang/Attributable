import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  InitResult _currentResult;
  Widget _homeWidget;
  @override
  void initState() {
    super.initState();
    AppConfig.initBeforeAgreement().then((initResult) {
      _updateHomeWidget(initResult);
      _initAfterAgreement();
    }).timeout(Duration(seconds: 5), onTimeout: () {
      _initTimeout();
    });
  }

  _initTimeout(){
    if(InitResult.splash == _currentResult) {
      _updateHomeWidget(InitResult.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppConfig.appData),
      ],
      child: MaterialApp(
          title: 'Attributable',
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.blueGrey.shade400,
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
            ),
            cardTheme: CardTheme(
                color: Colors.white24,
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                )
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.green,
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
            ),
            cardTheme: CardTheme(
              color: Colors.white38,
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              )
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routes: {
            '/Home': (context) => Home(),
          },
          home: _homeWidget ?? Container(),
      ),
    );
  }

  _initAfterAgreement() {
    _updateHomeWidget(InitResult.splash);
    AppConfig.initAfterAgreement()
        .then((nextNextResult) => _updateHomeWidget(nextNextResult))
        .timeout(Duration(seconds: 5), onTimeout: () {
      _initTimeout();
    });
  }

  Widget _buildPrivacyPolicy(){
    return PrivacyPolicy(onAgree: (agreed) {
      AppConfig.isPrivacyPolicyAgreed = agreed;
      if (agreed) {
        _initAfterAgreement();
      } else {
        exit(0);
      }
    },);
  }
  _updateHomeWidget(InitResult nextResult) {
    print("_updateHomeWidget > $nextResult");
    if (_currentResult != nextResult) {
      setState(() {
        switch (nextResult) {
          case InitResult.askPrivacyPolicy:
            _homeWidget = _buildPrivacyPolicy();
            break;
          case InitResult.home:
            _homeWidget = Home();
            break;
          case InitResult.splash:
            _homeWidget = Splash();
            break;
          case InitResult.deferredDeepLink:
            _homeWidget = DeepLink();
            break;
          default:
            _homeWidget = Splash();
            break;
        }
      });
    }
  }
}
