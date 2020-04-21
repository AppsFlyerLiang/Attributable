import 'package:flutter/material.dart';
import 'package:fluttersample/models/app_data.dart';
import 'app_config.dart';

import 'screens/my_app.dart';

main() async{
  print("[main]");
  print("[main]AppConfig.appData.hashCode:  ${AppConfig.appData?.hashCode}");
  WidgetsFlutterBinding.ensureInitialized();
  InitResult result = await AppConfig.initBeforeAgreement();
  if (InitResult.askPrivacyPolicy == result) {
    result = InitResult.askPrivacyPolicy;
    runApp(MyApp(result));
  } else {
    print("Normal Start appOpenAttributionData.type. ${AppConfig.appData?.appOpenAttributionData?.type}");
    result = await AppConfig.initAfterAgreement().timeout(
        Duration(milliseconds: 1000), onTimeout: () => InitResult.splash
    ).catchError((err) =>
    {
      print("initAfterAgreement Error: $err")
    });
    runApp(MyApp(result));
  }
}
