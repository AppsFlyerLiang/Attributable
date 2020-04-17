

import 'package:advertising_id/advertising_id.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

enum InitResult {
  normal,
  askPrivacyPolicy,
  targetAppInstalled,
}

class MyApp {
  static FirebaseAnalytics analytics;
  static RemoteConfig remoteConfig;
  static String flavor = "GooglePlay";
  static AppsflyerSdk appsflyerSdk;

//  static FirebaseMessaging firebaseMessage = FirebaseMessaging();
  static Future<InitResult> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    analytics = FirebaseAnalytics();
    analytics.logAppOpen();
    appsflyerSdk = AppsflyerSdk({
      "afDevKey": "SC6zv6Zb6N52vePBePs5Xo",
      "afAppId": "3333999931",
      "isDebug": true
    });
    appsflyerSdk.initSdk(registerConversionDataCallback: true, registerOnAppOpenAttributionCallback: true);
    advertisingId = await retrieveDeviceId();
    return InitResult.normal;
  }

  static String advertisingId;
  static Future<String> retrieveDeviceId() async {
    if(advertisingId!=null) return advertisingId;
    else {
      try {
        advertisingId = await AdvertisingId.id;
        print("[DeviceIdHelper] retrieved advertiserId: $advertisingId");
      } on Exception catch(error) {
        print("[DeviceIdHelper] failed to get advertiserId: $error");
      }
    }
    return advertisingId;
  }

}