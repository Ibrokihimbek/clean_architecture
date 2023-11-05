part of 'package:clean_architecture/core/widgets/cupertino_back/cupertino_back_gesture.dart';

/// This is a copy of Flutter's material [CupertinoPageTransitionsBuilder]
/// with modified version of [CupertinoPageRoute]
class CupertinoPageTransitionsBuilderCustomBackGestureWidth
    extends PageTransitionsBuilder {
  const CupertinoPageTransitionsBuilderCustomBackGestureWidth();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      CupertinoRouteTransitionMixin.buildPageTransitions<T>(
        route,
        context,
        animation,
        secondaryAnimation,
        child,
      );
}
