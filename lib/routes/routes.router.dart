// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../home.dart';
import '../pages/boards/boards_view.dart';

class Routes {
  static const String home = '/';
  static const String boardsView = '/boards-view';
  static const all = <String>{
    home,
    boardsView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.home, page: Home),
    RouteDef(Routes.boardsView, page: BoardsView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    Home: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => Home(),
        settings: data,
      );
    },
    BoardsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const BoardsView(),
        settings: data,
      );
    },
  };
}
