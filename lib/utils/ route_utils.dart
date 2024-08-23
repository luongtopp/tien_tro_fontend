import 'package:flutter/cupertino.dart';

enum SlideDirection { leftToRight, rightToLeft, topToBottom, bottomToTop }

PageRouteBuilder<dynamic> createCustomPageRoute(
  Widget page, {
  SlideDirection direction = SlideDirection.leftToRight,
  Curve curve = Curves.linear,
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin;
      switch (direction) {
        case SlideDirection.leftToRight:
          begin = const Offset(-1, 0);
          break;
        case SlideDirection.rightToLeft:
          begin = const Offset(1, 0);
          break;
        case SlideDirection.topToBottom:
          begin = const Offset(0, -1);
          break;
        case SlideDirection.bottomToTop:
          begin = const Offset(0, 1);
          break;
      }

      const end = Offset.zero;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
