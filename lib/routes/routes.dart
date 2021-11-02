import 'package:mobichan/home.dart';
import 'package:mobichan/pages/boards/boards_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: Home, initial: true),
    MaterialRoute(page: BoardsView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
  ],
)
class Routes {}
