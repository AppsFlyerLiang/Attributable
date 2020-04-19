import 'package:flutter/foundation.dart';
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
  bool _retrieveDeviceIdDone = false;
  bool _initAppsFlyerSdkDone = false;
  bool _getConversionDataDone = false;
  bool _privacyPolicyAgreed = false;
  ConversionResponse _conversionResponse;

  ConversionResponse get conversionResponse => _conversionResponse;
  set conversionResponse(ConversionResponse value) {
    _conversionResponse = value;
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