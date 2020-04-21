import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_config.dart';
import '../models/app_data.dart';
import '../widgets/image_background_container.dart';
import 'package:provider/provider.dart';


class Splash extends StatefulWidget {
  final Function onFinish;
  @override
  _SplashState createState() => _SplashState();

  Splash({this.onFinish});
}

class _SplashState extends State<Splash> {
  bool _redirected = false;

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context);
    print("[Splash] build \n$appData");
    print("[Splash] appData.hashCode: ${appData.hashCode}");
    print("[Splash] Global appData.hashCode: ${AppConfig.appData.hashCode}");
    print("[Splash] appOpenAttributionData.type. ${appData.appOpenAttributionData?.type}");
    print("[Splash] conversionResponse.type:  ${appData.conversionResponse?.type}");
    print("[Splash] Global appOpenAttributionData.type ${AppConfig.appData.appOpenAttributionData?.type}");
    print("[Splash] Global conversionResponse.type: ${AppConfig.appData.conversionResponse?.type}");
    print("[Splash] AppConfig.appOpenAttributionData.hashCode ${AppConfig.appOpenAttributionData.hashCode}");
    print("[Splash] AppConfig.appOpenAttributionData.type. ${AppConfig.appOpenAttributionData?.type}");
    _checkUpdate(context, appData);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ImageBackgroundContainer(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            "assets/images/af_logo.png", height: 28, fit: BoxFit.fitHeight,),
          leading: null,
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
//              padding: EdgeInsets.only(top: 100),
              child: Center(
                child: Image(image: AssetImage("assets/images/logo.png"),
                  width: 128,
                  height: 128,),
              ),
            ),
            Expanded(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    children: [
                      TextSpan(text: "Is Privacy Policy Agreed: "),
                      TextSpan(text: appData.privacyPolicyAgreed
                          ? "Yes"
                          : "Waiting for agreement...",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: (appData.privacyPolicyAgreed
                                  ? Colors.green
                                  : Colors.red))),
                      TextSpan(text: "\nRetrieve device id: "),
                      TextSpan(text: appData.retrieveDeviceIdDone
                          ? "done"
                          : "processing...",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: (appData.retrieveDeviceIdDone
                                  ? Colors.green
                                  : Colors.red))),
                      TextSpan(text: "\nInitialize AppsFlyer SDK: "),
                      TextSpan(text: appData.initAppsFlyerSdkDone
                          ? "done"
                          : "processing...",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: (appData.initAppsFlyerSdkDone
                                  ? Colors.green
                                  : Colors.red))),
                      TextSpan(text: "\nGet Conversion Data: "),
                      TextSpan(text: appData.conversionResponse!=null
                          ? "done"
                          : "processing...",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: (appData.conversionResponse!=null
                                  ? Colors.green
                                  : Colors.red))),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool _handleDeferredDeepLinking(ConversionResponse cv) {
    if (cv!=null && "OK" == cv.status && "onConversionLoadSuccess" == cv.type) {
      Map<String, dynamic> cvData = cv.data;
      if (cvData["is_first_launch"] ?? false) {
        if (cvData["af_adset"] == "defer") {
          return true;
        } else if (cvData["af_dp"]?.toString()?.startsWith("attributable://") ?? false) {
          return true;
        }
      }
    }
    return false;
  }

  void _gotoDeepLink(BuildContext context, bool isDeferred, Map<String, dynamic> data) {
    print("[Splash] Go to DeepLink");
    if(!_redirected) {
      _redirected = true;
      widget.onFinish?.call();
      Future.delayed(Duration(seconds: 0)).then((value) {
        Navigator.popAndPushNamed(
            context, "/DeepLink");
      });
    }
  }

  void _gotoHome(BuildContext context){
    print("[Splash] Go to Home");
    if(!_redirected) {
      _redirected = true;
      widget.onFinish?.call();
      Future.delayed(Duration(seconds: 0)).then((value) {
        Navigator.popAndPushNamed(context, "/Home");
      });
    }
  }


  void _checkUpdate(BuildContext context, AppData appData) {
    if(appData.appOpenAttributionData!=null) {
      print("Deep Link");
      _gotoDeepLink(context, false, appData.appOpenAttributionData.data);
    } else if(appData.conversionResponse!=null) {
      if (_handleDeferredDeepLinking(appData.conversionResponse)) {
        print("Conversion Data Loaded and found Deferred Deep Link");
        _gotoDeepLink(context, true, appData.conversionResponse.data);
      } else {
        print("Conversion Data Loaded");
        _gotoHome(context);
      }
    }
  }
}
