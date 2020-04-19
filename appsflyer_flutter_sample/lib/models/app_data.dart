import 'package:flutter/foundation.dart';

class AppData with ChangeNotifier {
  bool _retrieveDeviceIdDone = false;
  bool _initAppsFlyerSdkDone = false;
  bool _getConversionDataDone = false;
  bool _privacyPolicyAgreed = false;
  Map _conversionData;

  Map get conversionData => _conversionData;
  set conversionData(Map value) {
    _conversionData = value;
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

  get getConversionDataDone => _getConversionDataDone;
  set getConversionDataDone(bool yes){
    _getConversionDataDone = yes;
    notifyListeners();
  }
  get retrieveDeviceIdDone => _retrieveDeviceIdDone;
  set retrieveDeviceIdDone(bool yes){
    _retrieveDeviceIdDone = yes;
    notifyListeners();
  }
}