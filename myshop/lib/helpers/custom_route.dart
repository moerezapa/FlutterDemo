import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    WidgetBuilder builder, 
    RouteSettings settings
  }) 
    : super(
      builder: builder, 
      settings: settings
    );
  
  /// buildTransitions is a method for control how the page transition
  /// is animated and by overriding
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    /// check if we have settings property,
    /// 
    if (settings.isInitialRoute) {
      /// return child which is the page we're navigating
      /// because we dant want to animate that first page thats
      /// loading in
      return child;
    }
    // if not in initial page
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  /// buildTransitions is a method for control how the page transition
  /// is animated and by overriding
  @override
  Widget buildTransitions<T>(PageRoute<T> route,BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    /// check if we have settings property,
    /// 
    if (route.settings.isInitialRoute) {
      /// return child which is the page we're navigating
      /// because we dant want to animate that first page thats
      /// loading in
      return child;
    }
    // if not in initial page
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}