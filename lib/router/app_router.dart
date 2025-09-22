import 'package:go_router/go_router.dart';
import 'package:remedi/features/home/presentation/ui/home_screen.dart';
import 'package:remedi/router/screen_name.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: ScreenName.home,
      builder: (context, state) => HomeScreen(),
    ),
  ],
);
