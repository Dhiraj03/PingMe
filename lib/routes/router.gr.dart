// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:ping_me/features/auth/presentation/screens/register_screen.dart';
import 'package:ping_me/features/auth/data/user_repository.dart';

class Router {
  static const registerPage = '/register-page';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.registerPage:
        if (hasInvalidArgs<RegisterScreenArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<RegisterScreenArguments>(args);
        }
        final typedArgs = args as RegisterScreenArguments;
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(
              key: typedArgs.key, userRepository: typedArgs.userRepository),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//RegisterScreen arguments holder class
class RegisterScreenArguments {
  final Key key;
  final UserRepository userRepository;
  RegisterScreenArguments({this.key, @required this.userRepository});
}
