import 'package:flutter/material.dart';

class OtherFeature extends StatefulWidget {
  OtherFeature({Key key}) : super(key: key);

  @override
  _OtherFeatureState createState() => _OtherFeatureState();
}

class _OtherFeatureState extends State<OtherFeature> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Other features"),
    );
  }
}