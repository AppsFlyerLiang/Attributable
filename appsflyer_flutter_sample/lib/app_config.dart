

import 'dart:async';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/app_data.dart';

enum InitResult {
  askPrivacyPolicy,
  home,
  splash,
  deferredDeepLink,
}

class AppConfig {
  static AppData appData = AppData();
  static FirebaseAnalytics analytics;
  static RemoteConfig remoteConfig;
  static String flavor = "GooglePlay";
  static AppsflyerSdk appsflyerSdk;
  static get isPrivacyPolicyAgreed async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isPrivacyPolicyAggreed") ?? false;
  }

  static set isPrivacyPolicyAgreed(bool agreed) {
    appData.privacyPolicyAgreed = agreed;
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setBool("isPrivacyPolicyAggreed", agreed));
  }

  static Future<InitResult> initBeforeAgreement() async {
    appData.privacyPolicyAgreed = await isPrivacyPolicyAgreed;
    return appData.privacyPolicyAgreed? InitResult.splash : InitResult.askPrivacyPolicy;
  }
//  static FirebaseMessaging firebaseMessage = FirebaseMessaging();

  static Future<InitResult> initAfterAgreement() async {
    InitResult result;
    print("[initAfterAgree]");
    print("[retrieveDeviceId  >>>>>>>>>>>> ]");
    await retrieveDeviceId();
    print("[retrieveDeviceId  <<<<<<<<<<<< ]");
    print("[_initPlatformConfig  >>>>>>>>>>>> ]");
    await _initPlatformConfig();
    print("[_initPlatformConfig  <<<<<<<<<<<< ]");
//    await _initFirebase();
    print("[_initAppsFlyerSdk  >>>>>>>>>>>> ]");
    result = await _initAppsFlyerSdk();
    print("[_initAppsFlyerSdk  <<<<<<<<<<<< ]");
    return result ?? InitResult.home;
  }
  static String advertisingId;

  static Future<String> retrieveDeviceId() async {
    print("[retrieveDeviceId]");
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
    return advertisingId;
  }

  static Future _initFirebase(BuildContext context) async {
    print("[_initFirebase]");
    analytics = FirebaseAnalytics();
    analytics.logAppOpen();
    remoteConfig = await RemoteConfig.instance;
  }

  static Future _initPlatformConfig() async {
    print("[_initPlatformConfig]");
      print("Platform.packageConfig=${Platform.packageConfig}");
  }

  static Future<InitResult> _initAppsFlyerSdk() async {
    print("[_initAppsFlyerSdk]");
    appsflyerSdk = AppsflyerSdk({
      "afDevKey": "SC6zv6Zb6N52vePBePs5Xo",
      "afAppId": "3333999931",
      "isDebug": true
    });
    Map<dynamic, dynamic> response = await appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true);
    appData.initAppsFlyerSdkDone = true;
    if ("OK" == response["status"]) {
      print("[appsflyerSdk.initSdk] status ok");
      if (!appData.getConversionDataDone) {
        Map<dynamic, dynamic> cvResponse = await appsflyerSdk.conversionDataStream.asBroadcastStream().first;
        print("[cvData] get Conversion Data $cvResponse");
        appData.conversionResponse = ConversionResponse.fromJson(cvResponse);
        Map<String, dynamic> cvData = appData.conversionResponse.data;
        if (cvData["is_first_launch"] ?? false) {
          if (cvData["af_adset"] == "defer") {
            return InitResult.deferredDeepLink;
          } else if (cvData["af_dp"]?.toString()?.startsWith("attributable://") ?? false) {
            return InitResult.deferredDeepLink;
          }
        }
      } else {
        return null;
      }
    } else {
      print("[appsflyerSdk.initSdk] failed");
      response?.forEach((key, value) {
        print("[appsflyerSdk.initSdk] response[$key]=$value");
      });
    }
    return null;
  }

  static void _handleDeepLink(Map<dynamic, dynamic> cvData) {
    print("[_handleDeepLink] Conversion Data $cvData");
  }
}