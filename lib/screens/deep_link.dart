import 'package:flutter/material.dart';
import 'package:fluttersample/widgets/image_background_container.dart';
import 'package:provider/provider.dart';

import '../app_config.dart';

class DeepLink extends StatefulWidget {
  final bool isDeferred;

  DeepLink({this.isDeferred = false});

  @override
  _DeepLinkState createState() => _DeepLinkState();
}

class _DeepLinkState extends State<DeepLink> {
  @override
  void initState() {
    super.initState();
    AppConfig.appData.hasNewDeepLinking = false;
    AppConfig.appData.hasNewDeferredDeepLinking = false;
  }
  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context);
    var dpResponse = appData.appOpenAttributionData;
    var textStyleKey = Theme
        .of(context)
        .primaryTextTheme
        .bodyText2;
    var textStyleValue = Theme
        .of(context)
        .primaryTextTheme
        .bodyText1;
    return ImageBackgroundContainer(
      image: Image(
        image: AssetImage("assets/images/001.jpg"), fit: BoxFit.cover,),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            "assets/images/af_logo.png", height: 28, fit: BoxFit.fitHeight,),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            children: <Widget>[
              Center(
                child: Text("Deep Link Success", style: Theme
                    .of(context)
                    .primaryTextTheme
                    .headline4),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Retargeting Conversion Data", textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22, color: Theme
                      .of(context)
                      .primaryColor),),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: SelectableText.rich(
                    TextSpan(
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
                        if((dpResponse?.data?.length ?? 0) >
                            0) ... _buildParameters(
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
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildParameters(Map<String, dynamic> map, TextStyle textStyleKey, TextStyle textStyleValue) {
    List<String> sortedKeys = map.keys.toList();
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
