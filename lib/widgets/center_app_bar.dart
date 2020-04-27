import 'package:flutter/material.dart';

class CenterAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("assets/images/af_logo.png"),
              height: 36,
              fit: BoxFit.contain),
          SizedBox(height: 4,),
          Text(
            'Attribution Method\nTest App',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 1),
                ]),
          ),
        ],
      ),
    );
  }
}
