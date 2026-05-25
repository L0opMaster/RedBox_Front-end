import 'package:flutter/material.dart';

class AppTransition {
  int millisecond;
  AppTransition({required this.millisecond});
  Route slide(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: millisecond),

      pageBuilder: (context, animation, secondaryAnimation) => page,

      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          // child: FadeTransition(opacity: animation, child: child),
          child: child,
        );
      },
    );
  }
}
