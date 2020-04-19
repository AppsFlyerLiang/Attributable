import 'package:flutter/material.dart';
import 'package:fluttersample/app_config.dart';

class Conversion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> keys = AppConfig.appData.conversionData.keys.cast<String>();
    keys.sort();

    return Card(
      child: Column(
        children: [
          Text("Conversion"),
          ListView.builder(
            itemCount: keys.length ?? 0,
              itemBuilder: (context, index) {
                MapEntry entry = AppConfig.appData.conversionData[keys[index]];
            return RichText(text: TextSpan(text: "$index)  ",
              children: [
                TextSpan(text: entry.key + " : "),
                TextSpan(text: entry.value, style: TextStyle(color: Colors.indigoAccent)),
              ],
            ),);
          }),
        ],
      ),
    );
  }
}
