// Imports -- Flutter & Dart
import 'package:flutter/cupertino.dart';

// Imports -- Packages

// Imports -- Project

class NoGlowEffectScrollBehavior extends ScrollBehavior
{
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection)
  {
    return child;
  }
}
