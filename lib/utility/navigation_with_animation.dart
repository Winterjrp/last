import 'package:flutter/cupertino.dart';

class NavigationForward extends PageRouteBuilder {
  final Widget targetPage;

  NavigationForward({
    required this.targetPage,
  }) : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
}

class NavigationBackward extends PageRouteBuilder {
  final Widget targetPage;

  NavigationBackward({
    required this.targetPage,
  }) : super(
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
}

class NavigationUpward extends PageRouteBuilder {
  final Widget targetPage;
  final int durationInMilliSec;

  NavigationUpward({
    required this.targetPage,
    required this.durationInMilliSec,
  }) : super(
          transitionDuration: Duration(milliseconds: durationInMilliSec),
          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
}

class NavigationDownward extends PageRouteBuilder {
  final Widget targetPage;

  NavigationDownward({
    required this.targetPage,
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
}
