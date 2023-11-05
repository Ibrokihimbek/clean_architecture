import 'package:clean_architecture/core/widgets/keyboard/keyboard_dismiss.dart';
import 'package:clean_architecture/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'core/theme/themes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => KeyboardDismiss(
    child: MaterialApp(
      title: 'Currency App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: Routes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      navigatorKey: rootNavigatorKey,
    ),
  );
}
