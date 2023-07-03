import 'package:base/presentation/common_widgets/base_scaffold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(
      body: Center(
        child: Text('App'),
      ),
    );
  }
}

class HomeParams {}
