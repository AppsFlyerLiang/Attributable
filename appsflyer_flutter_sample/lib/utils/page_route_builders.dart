import 'package:flutter/material.dart';

const int _duration = 400;

/// 自定义页面切换动画 - 旋转+缩放切换
class RotationScalePageRouteBuilder<T> extends PageRouteBuilder<T> {
  // 跳转的页面
  final Widget widget;

  RotationScalePageRouteBuilder(this.widget) :super(
      transitionDuration: Duration(milliseconds: _duration),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0)
              .animate(
              CurvedAnimation(parent: animation, curve: Curves.fastLinearToSlowEaseIn)),
          child: ScaleTransition(scale: Tween(begin: 0.0, end: 1.0)
              .animate(
            CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),),
            child: child,),
        );
      }
  );
}

/// 自定义页面切换动画 - 平移切换
class SlidePageRouteBuilder<T> extends PageRouteBuilder<T> {
  // 跳转的页面
  final Widget widget;
  final Offset begin;
  final Offset end;

  SlidePageRouteBuilder(this.widget,
      {
        this.begin = const Offset(0.0, 1.0),
        this.end = const Offset(0.0,0.0),
      }) :super(
      transitionDuration: Duration(milliseconds: _duration),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
              begin: begin, end: end)
              .animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
          child: child,);
      }
  );
}

/// 自定义页面切换动画 - 缩放切换
class ScalePageRouteBuilder extends PageRouteBuilder{
  // 跳转的页面
  final Widget widget;
  ScalePageRouteBuilder(this.widget):super(
      transitionDuration:Duration(milliseconds: _duration),
      pageBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
        return widget;
      },
      transitionsBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
        return ScaleTransition(child:child,
            scale: Tween(begin: 0.0,end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn))
        );
      }
  );
}
class PlainRouteBuilder extends PageRouteBuilder{
  final Widget widget;
  PlainRouteBuilder(this.widget):super(
      pageBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
        return widget;
      },
  );

}
class FadePageRouteBuilder extends PageRouteBuilder{
  // 跳转的页面
  final Widget widget;
  FadePageRouteBuilder(this.widget):super(
      transitionDuration:Duration(milliseconds: _duration),
      pageBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
        return widget;
      },
      transitionsBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
        return FadeTransition(child:child,
            opacity: Tween(begin: 0.0,end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn))
        );
      }
  );
}
class FadeScalePageRouteBuilder extends PageRouteBuilder{
  // 跳转的页面
  final Widget widget;
  FadeScalePageRouteBuilder(this.widget):super(
      transitionDuration:Duration(milliseconds: _duration),
      pageBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
        return widget;
      },
      transitionsBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
        return  FadeTransition(
            opacity: Tween(begin: 0.0,end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
            child: ScaleTransition(child:child,
              scale: Tween(begin: 0.0,end: 1.0)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn))
          ),
        );
      }
  );
}
