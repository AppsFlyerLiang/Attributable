

import 'dart:async';

import 'package:advertising_id/advertising_id.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import './models/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum InitResult {
  askPrivacyPolicy,
  home,
  splash,
  deepLink,
  deferredDeepLink,
}



class AppConfig {
  static AppsflyerSdk appsflyerSdk;
  static FirebaseAnalytics analytics;
  static AppData appData = AppData();
  static FirebaseMessaging firebaseMessage = FirebaseMessaging();
  static RemoteConfig remoteConfig;
  static String flavor = "GooglePlay";
  static get isPrivacyPolicyAgreed async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isPrivacyPolicyAggreed") ?? false;
  }

  static set isPrivacyPolicyAgreed(bool agreed) {
    appData.privacyPolicyAgreed = agreed;
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setBool("isPrivacyPolicyAggreed", agreed));
  }

  static get installReferrer async {
    var prefs = await SharedPreferences.getInstance();
    var savedValue = prefs.getStringList("installReferrer");
    if(null == savedValue) return null;
    Map<String, String> result = Map();
    prefs.getStringList("installReferrer")?.forEach((element) {
      var kv = element.split(":");
      result.putIfAbsent(kv[0], () => kv[1]);
    });
    return result;
  }

  static set installReferrer(Map<String, String> value) {
    SharedPreferences.getInstance().then((prefs) => {
      prefs.setStringList("isPrivacyPolicyAggreed",
        value.entries.map((e) => "${e.key}:${e.value}").toList())
    });
  }

  static Future<InitResult> initBeforeAgreement() async {
    print("[initBeforeAgreement  >>>>>>>>>>>> ]");

    if (appData.privacyPolicyAgreed) {
      print("[initBeforeAgreement  Agreed <<<<<<<<<<<< ]");
      return null;
    } else {
      appData.privacyPolicyAgreed = await isPrivacyPolicyAgreed;
      print("[initBeforeAgreement  ${appData.privacyPolicyAgreed} <<<<<<<<<<<< ]");
      return appData.privacyPolicyAgreed ? null : InitResult.askPrivacyPolicy;
    }
  }
//  static FirebaseMessaging firebaseMessage = FirebaseMessaging();

  static Future<InitResult> initAfterAgreement() async {
    print("[initAfterAgreement  >>>>>>>>>>>> ]");
    InitResult result = await initAppsFlyerSdk();
    retrieveDeviceId();
    _initFirebase();
    print("[initBeforeAgreement  <<<<<<<<<<<< ]");
    return result ?? InitResult.splash;
  }
  static String advertisingId;

  static Future<String> retrieveDeviceId() async {
    print("[retrieveDeviceId  >>>>>>>>>>>> ]");
    if (advertisingId != null)
      return advertisingId;
    else {
      try {
        advertisingId = await AdvertisingId.id;
        appData.retrieveDeviceIdDone = true;
        print("[DeviceIdHelper] retrieved advertiserId: $advertisingId");
      } on Exception catch (error) {
        print("[DeviceIdHelper] failed to get advertiserId: $error");
      }
    }
    print("[retrieveDeviceId  <<<<<<<<<<<< ]");
    return advertisingId;
  }

  static Future _initFirebase() async {
    print("[_initFirebase] >>>>>>>>>>>>");
    try {
      analytics = FirebaseAnalytics();
      analytics.logAppOpen();
      firebaseMessage.configure(
        onMessage: onFirebaseMessage,
        onBackgroundMessage: onFirebaseBackgroundMessage,
        onLaunch: onFirebaseLaunch,
        onResume: onFirebaseResume,
      );
      firebaseMessage.onTokenRefresh.listen((deviceToken) {
        print("onTokenRefresh:$deviceToken");
        appsflyerSdk?.updateServerUninstallToken(deviceToken);
      });

      analytics = FirebaseAnalytics();
      analytics.logAppOpen();

      remoteConfig = await RemoteConfig.instance;
    } catch (exception) {
      print("exception : $exception");
    }
    print("[_initPlatformConfig  <<<<<<<<<<<< ]");
  }
  static ConversionResponse appOpenAttributionData;
  static Future<InitResult> initAppsFlyerSdk() async {
    print("[_initAppsFlyerSdk  >>>>>>>>>>>> ]");
    InitResult result;
    if (appsflyerSdk != null) {
      print("[_initAppsFlyerSdk] was already initialized!");
      print("[_initAppsFlyerSdk  <<<<<<<<<<<< ]");
      return null;
    }
    appsflyerSdk = AppsflyerSdk({
      "afDevKey": "SC6zv6Zb6N52vePBePs5Xo",
      "afAppId": "3333999931",
      "isDebug": false,
    });
    try {
      Map<dynamic, dynamic> response = await appsflyerSdk.initSdk(
          registerConversionDataCallback: true,
          registerOnAppOpenAttributionCallback: true);
      appData.initAppsFlyerSdkDone = true;
      appsflyerSdk.appOpenAttributionStream.asBroadcastStream().listen((data) {
        print("[appsflyerSdk.appOpenAttributionStream] listen callback: $data");
        appData.appOpenAttributionData = ConversionResponse.fromJson(data);
        appOpenAttributionData = ConversionResponse.fromJson(data);
        print("[appsflyerSdk.appOpenAttributionStream][appData.hashCode] ${appData.hashCode}");
        print("[appsflyerSdk.appOpenAttributionStream] appOpenAttributionData.type. ${appData.appOpenAttributionData?.type}");
        print("[appsflyerSdk.appOpenAttributionStream][AppConfig.appOpenAttributionData.hashCode] ${AppConfig.appOpenAttributionData.hashCode}");
        print("[appsflyerSdk.appOpenAttributionStream] AppConfig.appOpenAttributionData.type. ${AppConfig.appOpenAttributionData?.type}");
      });

      appsflyerSdk.conversionDataStream.asBroadcastStream().listen((data) {
        print("[appsflyerSdk.conversionDataStream] listen callback: $data");
        appData.conversionResponse = ConversionResponse.fromJson(data);
      });
      if ("OK" == response["status"]) {
        print("[appsflyerSdk.initSdk] $response");
      } else {
        print("[appsflyerSdk.initSdk] failed");
        response?.forEach((key, value) {
          print("[appsflyerSdk.initSdk] response[$key]=$value");
        });
      }
    } catch (exception) {
      print("exception : $exception");
    }
    print("[_initAppsFlyerSdk  <<<<<<<<<<<< ]");
    return result;
  }

  static void _handleDeepLink(Map<dynamic, dynamic> cvData) {
    print("[_handleDeepLink] Conversion Data $cvData");
  }

  static Future<dynamic> onFirebaseMessage(Map<String, dynamic> message) async {
    print("onFirebaseMessage");
    message.forEach((key, value) {
      print("key: $key, value: $value");

    });
  }

  static Future<dynamic> onFirebaseResume(Map<String, dynamic> message) async {
    print("onFirebaseResume");
    message.forEach((key, value) {
      print("key: $key, value: $value");

    });
  }

  static Future<dynamic> onFirebaseLaunch(Map<String, dynamic> message) async {
    print("onFirebaseLaunch");
    message.forEach((key, value) {
      print("key: $key, value: $value");

    });
  }
}

Future<dynamic> onFirebaseBackgroundMessage(Map<String, dynamic> message) async {
  print("onFirebaseBackgroundMessage");
  message.forEach((key, value) {
    print("key: $key, value: $value");
  });
}

class AppData with ChangeNotifier {
  static AppData _instance;
  factory AppData() => _instance ??= AppData._();
  AppData._(){
    print("[AppData] New $hashCode");
  }

  bool _retrieveDeviceIdDone = false;
  bool _initAppsFlyerSdkDone = false;
  bool _privacyPolicyAgreed = false;
  ConversionResponse _conversionResponse;
  ConversionResponse _appOpenAttributionData;

  ConversionResponse get conversionResponse => _conversionResponse;
  set conversionResponse(ConversionResponse value) {
    _conversionResponse = value;
    notifyListeners();
  }

  ConversionResponse get appOpenAttributionData => _appOpenAttributionData;
  set appOpenAttributionData(ConversionResponse value) {
    _appOpenAttributionData = value;
    notifyListeners();
  }


  get privacyPolicyAgreed => _privacyPolicyAgreed;
  set privacyPolicyAgreed(bool yes){
    _privacyPolicyAgreed = yes;
    notifyListeners();
  }
  get initAppsFlyerSdkDone => _initAppsFlyerSdkDone;
  set initAppsFlyerSdkDone(bool yes){
    _initAppsFlyerSdkDone = yes;
    notifyListeners();
  }
  get retrieveDeviceIdDone => _retrieveDeviceIdDone;
  set retrieveDeviceIdDone(bool yes){
    _retrieveDeviceIdDone = yes;
    notifyListeners();
  }
}