// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:ping_me/features/messaging/presentation/screens/search_screen.dart';
import 'package:ping_me/features/messaging/data/user_model.dart';

class Router {
  static const searchScreen = '/search-screen';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.searchScreen:
        if (hasInvalidArgs<SearchScreenArguments>(args)) {
          return misTypedArgsRoute<SearchScreenArguments>(args);
        }
        final typedArgs =
            args as SearchScreenArguments ?? SearchScreenArguments();
        return MaterialPageRoute(
          builder: (_) => SearchScreen(
              key: typedArgs.key, searchList: typedArgs.searchList),
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

//SearchScreen arguments holder class
class SearchScreenArguments {
  final Key key;
  final List<User> searchList;
  SearchScreenArguments({this.key, this.searchList});
}
