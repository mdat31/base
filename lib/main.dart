import 'package:base/di/injector.dart';
import 'package:base/ui/app/app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  runApp(const MyApp());
}
