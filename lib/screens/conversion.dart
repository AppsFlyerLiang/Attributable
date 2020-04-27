import 'dart:io';

import 'package:flutter/material.dart';
import '../app_config.dart';
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
    AppConfig.appsflyerSdk.getAppsFlyerUID().then((value) {
      setState(() {
        _appsflyerId = value;
      });
    }).timeout(Duration(seconds: 5), onTimeout: () {
      setState(() {
        _appsflyerId = "Load failed";
      });
    });
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        _appVersion = value.version;
      });
    }).timeout(Duration(seconds: 5), onTimeout: () {
      setState(() {
        _appVersion = "Load failed";
      });
    });
    AppConfig.appsflyerSdk.getSDKVersion().then((value) {
      setState(() {
        _sdkVersion = value;
      });
    }).timeout(Duration(seconds: 5), onTimeout: () {
      setState(() {
        _sdkVersion = "Load failed";
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context);
    var referrer = appData.installReferrer;
    var cvResponse = appData.conversionResponse;
    var dpResponse = appData.appOpenAttributionData;
    var textStyleKey = Theme.of(context).primaryTextTheme.bodyText2;
    var textStyleValue = Theme.of(context).primaryTextTheme.bodyText1;
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
              text: TextSpan(style: textStyleKey,
                  children: [
                    TextSpan(text: Platform.isIOS ? "IDFA" : "Advertising id: "),
                    TextSpan(text: AppConfig.advertisingId, style: textStyleValue),
                    TextSpan(text: "\n"),
                    TextSpan(text: "AppsFlyer Id: "),
                    _appsflyerId!=null ? TextSpan(text: _appsflyerId, style: textStyleValue)
                    : TextSpan(text: "loading...",
                        style: TextStyle(color: Colors.yellowAccent, fontSize: 14)),
                    TextSpan(text: "\n"),
                    TextSpan(text: "SDK Version: "),
                    _sdkVersion!=null ? TextSpan(text: _sdkVersion,
                        style: textStyleValue)
                        : TextSpan(text: "loading...",
                        style: TextStyle(color: Colors.yellowAccent, fontSize: 14)),
                    TextSpan(text: "\n"),
                    TextSpan(text: "App Version: "),
                    _appVersion!=null ? TextSpan(text: _appVersion,
                        style: textStyleValue)
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
                children: referrer!=null
                      ? _buildParameters(referrer, textStyleKey, textStyleValue)
                      : [TextSpan(text: "No data found!", style: TextStyle(color: Colors.yellowAccent))],
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
                style: textStyleKey,
                children: <TextSpan>[
                  TextSpan(text: "Conversion status: "),
                  TextSpan(text: cvResponse?.status,
                      style: textStyleValue),
                  TextSpan(text: "\n"),
                  TextSpan(text: "Conversion type: "),
                  TextSpan(text: cvResponse?.type,
                      style: textStyleValue),
                  TextSpan(text: "\n"),
                  if((cvResponse?.data?.length ?? 0) > 0) ... _buildParameters(
                      cvResponse?.data, textStyleKey, textStyleValue)
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
                style: textStyleKey,
                children: <TextSpan>[
                  TextSpan(text: "Conversion status: "),
                  TextSpan(text: dpResponse?.status,
                      style: textStyleValue),
                  TextSpan(text: "\n"),
                  TextSpan(text: "Conversion type: "),
                  TextSpan(text: dpResponse?.type,
                      style: textStyleValue),
                  TextSpan(text: "\n"),
                  if((dpResponse?.data?.length ?? 0) > 0) ... _buildParameters(
                      dpResponse?.data, textStyleKey, textStyleValue)
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
  List<TextSpan> _buildParameters(Map map, TextStyle textStyleKey, TextStyle textStyleValue) {
    List<String> sortedKeys = map.keys.map((e) => e.toString()).toList();
    sortedKeys.sort();
    int i = 1;
    List<TextSpan> spanList = List<TextSpan>();
    sortedKeys.forEach((key) {
      spanList.add(TextSpan(text: "${i++})  $key : ", style: textStyleKey));
      spanList.add(TextSpan(text: "${map[key]?.toString()}\n",
          style: textStyleValue));
    });
    return spanList;
  }
}
