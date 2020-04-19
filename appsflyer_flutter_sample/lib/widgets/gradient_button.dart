import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final BoxDecoration decoration;
  GradientButton({
    this.buttonText,
    this.onPressed,
    this.width,
    this.height = 50,
    this.margin,
    this.decoration,
  });

  Color buildAccentColorLight(Color accentColor) {
    int red = accentColor.red + 128;
    int green = accentColor.green + 128;
    int blue = accentColor.blue + 128;
    return accentColor.withRed(red > 255 ? 255 : red).withBlue(blue > 255 ? 255 : blue).withGreen(green > 255 ? 255 : green);
  }
  Color buildAccentColorDark(Color accentColor) {
    int red = accentColor.red - 64;
    int green = accentColor.green - 64;
    int blue = accentColor.blue - 64;
    return accentColor.withRed(red < 0 ? 0 : red).withBlue(blue < 0 ? 0 : blue).withGreen(green < 0 ? 0 : green);
  }
  @override
  Widget build(BuildContext context) {
    var accentColor = Theme.of(context).accentColor;
    var accentColorDark = buildAccentColorDark(accentColor);
    return Container(
      width: width,
      height: height ?? 50,
      margin: margin,
//      constraints: const BoxConstraints(minWidth: 50.0, minHeight: 50.0),
      child: RaisedButton(
        color: Colors.transparent,
        padding: EdgeInsets.all(0.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))
        ),

        child: Ink(
          decoration: decoration ?? BoxDecoration(
            gradient:  LinearGradient(colors: [accentColor, accentColorDark, accentColorDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          child: Container(
            constraints: const BoxConstraints(minWidth: 80.0, minHeight: 50.0),
            // min sizes for Material buttons
            alignment: Alignment.center,
            child: Text(buttonText, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white.withAlpha(212), fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black87, offset: Offset(1, 1), blurRadius: 2)]),),
          ),
        ),
        onPressed: () { onPressed(); }
      ),
    );
  }
}
