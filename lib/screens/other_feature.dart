import 'package:flutter/material.dart';
import 'package:fluttersample/widgets/gradient_button.dart';

class OtherFeature extends StatefulWidget {
  OtherFeature({Key key}) : super(key: key);

  @override
  _OtherFeatureState createState() => _OtherFeatureState();
}

class _OtherFeatureState extends State<OtherFeature> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GradientButton(
              buttonText: "Customer User Id",
              onPressed: () {
                _setCustomerUserId();
              },
            ),
            GradientButton(
              buttonText: "User Invite",
              onPressed: () {
              },
            )
          ],
        ),
      ),
    );
  }

  void _setCustomerUserId() {
  }
}