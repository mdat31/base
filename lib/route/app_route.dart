import 'package:base/presentation/home/screen/home_screen.dart';
import 'package:flutter/cupertino.dart';

class AppRoute {
  static Map<String, WidgetBuilder> route = {
    HomeScreen.route: (_) => const HomeScreen(),
  };
}
