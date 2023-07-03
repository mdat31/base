import 'package:base/route/app_route.dart';
import 'package:base/theme/app_theme.dart';
import 'package:base/presentation/app/bloc/account_bloc.dart';
import 'package:base/presentation/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'flavors.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AccountBloc()),
          ],
          child: MaterialApp(
            routes: AppRoute.route,
            theme: lightTheme,
            darkTheme: darkTheme,
            initialRoute: HomeScreen.route,
            title: F.title,
          ),
        );
      },
    );
  }
}
