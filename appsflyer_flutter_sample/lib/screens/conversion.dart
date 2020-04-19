import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttersample/app_config.dart';
import 'package:fluttersample/models/app_data.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class Conversion extends StatefulWidget {
  @override
  _ConversionState createState() => _ConversionState();
}

class _ConversionState extends State<Conversion> {
  String _appsflyerId;
  String _appVersion;
  String _sdkVersion;
  @override
  void initState() {
    super.initState();
    AppConfig.appsflyerSdk.getAppsFlyerUID().then((value){
      setState(() {
        _appsflyerId = value;
      });
    }).timeout(Duration(seconds: 5), onTimeout: (){
      setState(() {
        _appsflyerId = "Load failed";
      });
    });
    PackageInfo.fromPlatform().then((value){
      setState(() {
        _appVersion = value.version;
      });
    }).timeout(Duration(seconds: 5), onTimeout: (){
      setState(() {
        _appVersion = "Load failed";
      });
    });
    AppConfig.appsflyerSdk.getSDKVersion().then((value){
      setState(() {
        _sdkVersion = value;
      });
    }).timeout(Duration(seconds: 5), onTimeout: (){
      setState(() {
        _sdkVersion = "Load failed";
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var cvResponse = AppConfig.appData.conversionResponse;
    var valueTextColor = Theme.of(context).primaryColorLight;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text("Basic info", textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Theme
                .of(context)
                .primaryColor),),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: TextStyle(fontSize: 13),
                  children: [
                    TextSpan(text: Platform.isIOS ? "IDFA" : "Advertising id: "),
                    TextSpan(text: AppConfig.advertisingId,
                        style: TextStyle(color: valueTextColor, fontSize: 14)),
                    TextSpan(text: "\n"),
                    TextSpan(text: "AppsFlyer Id: "),
                    _appsflyerId!=null ? TextSpan(text: _appsflyerId,
                        style: TextStyle(color: valueTextColor, fontSize: 14))
                    : TextSpan(text: "loading...",
                        style: TextStyle(color: Colors.yellowAccent, fontSize: 14)),
                    TextSpan(text: "\n"),
                    TextSpan(text: "SDK Version: "),
                    _sdkVersion!=null ? TextSpan(text: _sdkVersion,
                        style: TextStyle(color: valueTextColor, fontSize: 14))
                        : TextSpan(text: "loading...",
                        style: TextStyle(color: Colors.yellowAccent, fontSize: 14)),
                    TextSpan(text: "\n"),
                    TextSpan(text: "App Version: "),
                    _appVersion!=null ? TextSpan(text: _appVersion,
                        style: TextStyle(color: valueTextColor, fontSize: 14))
                        : TextSpan(text: "loading...",
                        style: TextStyle(color: Colors.yellowAccent, fontSize: 14)),
                  ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text("Install Referrer", textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Theme
                .of(context)
                .primaryColor),),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16),
                children: <TextSpan>[
                  TextSpan(text: "Conversion status: "),
                  TextSpan(text: cvResponse.status,
                      style: TextStyle(color: valueTextColor)),
                  TextSpan(text: "\n"),
                  TextSpan(text: "Conversion type: "),
                  TextSpan(text: cvResponse.type,
                      style: TextStyle(color: valueTextColor)),
                  TextSpan(text: "\n"),
                  if((cvResponse?.data?.length ?? 0) > 0) ... _buildParameters(
                      cvResponse?.data, valueTextColor)
                  else
                    TextSpan(text: "No conversion data found!",
                        style: TextStyle(color: Colors.yellowAccent)),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text("Conversion Data", textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Theme
              .of(context)
              .primaryColor),),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16),
                children: <TextSpan>[
                  TextSpan(text: "Conversion status: "),
                  TextSpan(text: cvResponse.status,
                      style: TextStyle(color: valueTextColor)),
                  TextSpan(text: "\n"),
                  TextSpan(text: "Conversion type: "),
                  TextSpan(text: cvResponse.type,
                      style: TextStyle(color: valueTextColor)),
                  TextSpan(text: "\n"),
                  if((cvResponse?.data?.length ?? 0) > 0) ... _buildParameters(
                      cvResponse?.data, valueTextColor)
                  else
                    TextSpan(text: "No conversion data found!",
                        style: TextStyle(color: Colors.yellowAccent)),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text("Retargeting Conversion Data", textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Theme
                .of(context)
                .primaryColor),),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16),
                children: <TextSpan>[
                  TextSpan(text: "Conversion status: "),
                  TextSpan(text: cvResponse.status,
                      style: TextStyle(color: valueTextColor)),
                  TextSpan(text: "\n"),
                  TextSpan(text: "Conversion type: "),
                  TextSpan(text: cvResponse.type,
                      style: TextStyle(color: valueTextColor)),
                  TextSpan(text: "\n"),
                  if((cvResponse?.data?.length ?? 0) > 0) ... _buildParameters(
                      cvResponse?.data, valueTextColor)
                  else
                    TextSpan(text: "No conversion data found!",
                        style: TextStyle(color: Colors.yellowAccent)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<TextSpan> _buildParameters(Map<String, dynamic> map, Color valueTextColor) {
    List<String> sortedKeys = map.keys.toList();
    sortedKeys.sort();
    int i = 1;
    List<TextSpan> spanList = List<TextSpan>();
    sortedKeys.forEach((key) {
      spanList.add(TextSpan(text: "${i++})  $key : "));
      spanList.add(TextSpan(text: "${map[key]?.toString()}\n",
          style: TextStyle(color: valueTextColor)));
    });
    return spanList;
  }
}
