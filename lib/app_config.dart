

import 'dart:async';

import 'package:advertising_id/advertising_id.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum InitResult {
  home,
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

  static const platform = const MethodChannel('com.fascode.attributable/installReferrer');
  static Future<Map<String, dynamic>> readInstallReferrer() async {
    try {
      Map installReferrer =  await platform.invokeMethod('getInstallReferrer');
      print("installReferrer: $installReferrer");
      appData.installReferrer = installReferrer;
    } on PlatformException catch(exception) {
      print(exception.message);
      return null;
    }
  }

  static Future<bool> checkAgreement() async {
    print("[initBeforeAgreement  >>>>>>>>>>>> ]");

    if (appData.privacyPolicyAgreed) {
      print("[initBeforeAgreement  Agreed <<<<<<<<<<<< ]");
      return null;
    } else {
      appData.privacyPolicyAgreed = await isPrivacyPolicyAgreed;
      print("[initBeforeAgreement  ${appData.privacyPolicyAgreed} <<<<<<<<<<<< ]");
      return appData.privacyPolicyAgreed;
    }
  }

  static Future<bool> initAfterAgreement() async {
    print("[initAfterAgreement  >>>>>>>>>>>> ]");
    retrieveDeviceId();
    _initFirebase();
    await readInstallReferrer();
    bool result = await initAppsFlyerSdk();
    print("[initAfterAgreement $result <<<<<<<<<<<< ]");
    return result;
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
  static Future<bool> initAppsFlyerSdk() async {
    print("[_initAppsFlyerSdk  >>>>>>>>>>>> ]");
    bool result = false;
    appsflyerSdk = AppsflyerSdk({
      "afDevKey": "SC6zv6Zb6N52vePBePs5Xo",
      "afAppId": "3333999931",
      "isDebug": true,
    });
    try {
      Map<dynamic, dynamic> response = await appsflyerSdk.initSdk(
          registerConversionDataCallback: true,
          registerOnAppOpenAttributionCallback: true);
      appData.initAppsFlyerSdkDone = true;
      appsflyerSdk.appOpenAttributionStream.asBroadcastStream().listen((data) {
        print("[appsflyerSdk.appOpenAttributionStream] listen callback: $data");
        appData.hasNewDeepLinking = true;
        appData.appOpenAttributionData = ConversionResponse.fromJson(data);
      });

      appsflyerSdk.conversionDataStream.asBroadcastStream().listen((data) {
        print("[appsflyerSdk.conversionDataStream] listen callback: $data");
        var cv = ConversionResponse.fromJson(data);
        if(_checkDeferredDeepLinking(AppConfig.appData.conversionResponse)) {
          appData.hasNewDeferredDeepLinking = true;
        }
        appData.conversionResponse = cv;
      });
      if ("OK" == response["status"]) {
        print("[appsflyerSdk.initSdk] $response");
        result = true;
      } else {
        print("[appsflyerSdk.initSdk] failed");
        response?.forEach((key, value) {
          print("[appsflyerSdk.initSdk] response[$key]=$value");
        });
      }
    } catch (exception) {
      print("exception : $exception");
    }
    print("[_initAppsFlyerSdk $result <<<<<<<<<<<< ]");
    return result;
  }

  static bool _checkDeferredDeepLinking(ConversionResponse cv) {
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

class ConversionResponse {
  final String status;
  final String type;
  final Map<String, dynamic> data;

  ConversionResponse(this.status, this.type, this.data);

  ConversionResponse.fromJson(Map<dynamic, dynamic> json)
      : this.status = json["status"],
        this.type = json["type"],
        this.data = json["data"];
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
  bool hasNewDeepLinking = false;
  bool hasNewDeferredDeepLinking = false;
  ConversionResponse _conversionResponse;
  ConversionResponse get conversionResponse => _conversionResponse;
  set conversionResponse(ConversionResponse value) {
    _conversionResponse = value;
    notifyListeners();
  }

  ConversionResponse _appOpenAttributionData;
  ConversionResponse get appOpenAttributionData => _appOpenAttributionData;
  set appOpenAttributionData(ConversionResponse value) {
    _appOpenAttributionData = value;
    notifyListeners();
  }

  Map _installReferrer;
  get installReferrer => _installReferrer;
  set installReferrer(Map referrer) {
    _installReferrer = referrer;
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