import 'package:base/route/app_route.dart';
import 'package:base/theme/app_theme.dart';
import 'package:base/ui/app/bloc/account_bloc.dart';
import 'package:base/ui/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AccountBloc()),
      ],
      child: MaterialApp(
        routes: AppRoute.route,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: HomeScreen.route,
      ),
    );
  }
}
