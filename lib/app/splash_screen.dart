import 'package:flutter/material.dart';
import 'package:mod/core/widgets/widgets.dart';

/// Shown while the session status is resolved.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: AppLoadingIndicator());
}
