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
  final bool privacyPolicyAgreed;
  @override
  _MyAppState createState() => _MyAppState();

  MyApp(this.privacyPolicyAgreed);
}

class _MyAppState extends State<MyApp> {
  Widget _decidedHomeWidget;
  bool _isPrivacyPolicyAgreed;
  Timer _splashTimeout;

  @override
  void initState() {
    super.initState();
    _isPrivacyPolicyAgreed = widget.privacyPolicyAgreed;
  }
  @override
  void dispose() {
    _splashTimeout?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
          primarySwatch: Colors.green,
          accentColor: Colors.green,
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
          ),
          cardTheme: CardTheme(
              color: Colors.black54,
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

        home: _isPrivacyPolicyAgreed
            ? (_decidedHomeWidget ?? _init(context))
            : PrivacyPolicy(onAgree: (agreed) {
          AppConfig.isPrivacyPolicyAgreed = agreed;
          if (agreed) {
            setState(() {
              _isPrivacyPolicyAgreed = true;
            });
          } else {
            exit(0);
          }
        }),
      ),
    );
  }

  Widget _init(BuildContext context) {
    print("[_init]");
    AppConfig.initAfterAgreement().then((value){
      var resultWidget = _homeWidgetFromInitResult(_checkAppData());
      if (resultWidget != null) {
        setState(() {
          if(_decidedHomeWidget==null) {
            _decidedHomeWidget = resultWidget;
            _splashTimeout.cancel();
            print("[_init] : _decidedHomeWidget = $_decidedHomeWidget");
          }
        });
      } else {
        AppConfig.appData.addListener(() {
          var resultWidget = _homeWidgetFromInitResult(_checkAppData());
          if (resultWidget != null) {
            setState(() {
              if(_decidedHomeWidget==null) {
                _decidedHomeWidget = resultWidget;
                _splashTimeout.cancel();
                print("[_init] : _decidedHomeWidget = $_decidedHomeWidget");
              }
            });
          }
        });
      }
    });
    if(_splashTimeout==null) {
      _splashTimeout = Timer(Duration(seconds: 5), () {
        setState(() {
          print("[_splashTimeout]");
          if(_decidedHomeWidget==null) _decidedHomeWidget = Home();
        });
      });
    }
    return Splash();
  }

  InitResult _checkAppData(){
    if (AppConfig.appData.hasNewDeepLinking) {
      print("[_checkAppData] waiting.complete: InitResult.deepLink");
      return (InitResult.deepLink);
    } else if (AppConfig.appData.hasNewDeferredDeepLinking) {
      print("[_checkAppData] waiting.complete: InitResult.deferredDeepLink");
      return (InitResult.deferredDeepLink);
    } else if (AppConfig.appData.conversionResponse != null) {
      print("[_checkAppData] waiting.complete: InitResult.home");
      return (InitResult.home);
    } else {
      print("[_checkAppData] Keep Listening AppConfig.appData");
    }
    return null;
  }

  Widget _homeWidgetFromInitResult(InitResult initResult){
    switch (initResult) {
      case InitResult.home:
        return Home();
        break;
      case InitResult.deepLink:
        return DeepLink();
        break;
      case InitResult.deferredDeepLink:
        return DeepLink(isDeferred: true,);
        break;
    }
    return null;
  }
}
