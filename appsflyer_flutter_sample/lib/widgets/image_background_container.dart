import 'package:flutter/material.dart';

class ImageBackgroundContainer extends StatelessWidget {
  final Image image;
  final Widget child;
  ImageBackgroundContainer({
    Key key,
    this.image,
    this.child,
  })
      : assert(image != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          child: image,
        ),
        child,
      ],
    );
  }
}