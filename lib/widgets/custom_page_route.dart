import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  CustomPageRoute({
    required this.child,
    this.direction = AxisDirection.right,
  }) : super(pageBuilder: (context, animation, secondaryAnimation) => child);

  CustomPageRoute.fromRight({required this.child})
      : direction = AxisDirection.right,
        super(pageBuilder: (context, animation, secondaryAnimation) => child);

  CustomPageRoute.fromLeft({required this.child})
      : direction = AxisDirection.left,
        super(pageBuilder: (context, animation, secondaryAnimation) => child);

  CustomPageRoute.fromUp({required this.child})
      : direction = AxisDirection.up,
        super(pageBuilder: (context, animation, secondaryAnimation) => child);

  CustomPageRoute.fromDown({required this.child})
      : direction = AxisDirection.down,
        super(pageBuilder: (context, animation, secondaryAnimation) => child);

  final Widget child;
  final AxisDirection direction;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: getDirectionOffset(),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  Offset getDirectionOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, -1);
      case AxisDirection.down:
        return const Offset(0, 1);
      case AxisDirection.left:
        return const Offset(-1, 0);
      case AxisDirection.right:
        return const Offset(1, 0);
    }
  }
}
