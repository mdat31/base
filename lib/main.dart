import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mod/di/injection.dart';

import 'app.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  await _beforeRun();

  runApp(const App());
}

Future<void> _beforeRun() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
}
