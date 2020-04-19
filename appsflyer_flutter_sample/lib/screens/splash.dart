import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersample/models/app_data.dart';
import 'package:fluttersample/widgets/image_background_container.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    print("[Splash] build");
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
                      TextSpan(text: appData.getConversionDataDone
                          ? "done"
                          : "processing...",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: (appData.getConversionDataDone
                                  ? Colors.green
                                  : Colors.red))),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
