import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_config.dart';
import 'deep_link.dart';
import 'home.dart';
import 'privacy_policy.dart';
import 'splash.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  final InitResult initResult;
  MyApp(this.initResult);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  InitResult _currentResult;
  Widget _homeWidget;
  Timer _splashTimeout;
  @override
  void initState() {
    print("MyApp [initState] Started");
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    print("MyApp [initState] Done");
    _updateHomeWidget(widget.initResult ?? InitResult.splash);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _splashTimeout.cancel();
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("[didChangeAppLifecycleState] state");
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
            accentColor: Colors.blueGrey.shade300,
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
            '/DeepLink': (context) => DeepLink(),
          },
          home: _homeWidget ?? Container(),
      ),
    );
  }
  _updateHomeWidget(InitResult nextResult) {
    print("_updateHomeWidget from $_currentResult to $nextResult");
    if (_currentResult != nextResult) {
      _currentResult = nextResult;
      setState(() {
        switch (nextResult) {
          case InitResult.askPrivacyPolicy:
            _homeWidget = PrivacyPolicy(onAgree: (agreed) {
              AppConfig.isPrivacyPolicyAgreed = agreed;
              if (agreed) {
                AppConfig.initAfterAgreement().then((initResult) {
                  _updateHomeWidget(initResult);
                });
              } else {
                exit(0);
              }
            },);
            break;
          case InitResult.home:
            _homeWidget = Home();
            break;
          case InitResult.deepLink:
            _homeWidget = DeepLink();
            break;
          case InitResult.deferredDeepLink:
            _homeWidget = DeepLink();
            break;
          case InitResult.splash:
            _splashTimeout = Timer(Duration(seconds: 10), (){
              if(InitResult.splash == _currentResult) {
                print("MyApp Timeout go to Home");
                _updateHomeWidget(InitResult.home);
              }
            });
            _homeWidget = Splash(onFinish: () {
              _splashTimeout.cancel();
            });
            break;
        }
      });
    }
  }
}
