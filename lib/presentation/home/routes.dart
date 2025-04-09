import 'package:go_router/go_router.dart';
import 'package:mod/presentation/home/screens/home_screen.dart';

class HomeRoutes {
  GoRoute get home => GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      );
}
