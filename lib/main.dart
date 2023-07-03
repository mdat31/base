import 'dart:async';

import 'package:base/di/injector.dart';
import 'package:flutter/material.dart';

import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}
