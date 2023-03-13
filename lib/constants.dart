import 'package:flutter/material.dart';

const String appTitle = "Mobichan";
const String captchaSiteKey = "6Ldp2bsSAAAAAAJ5uyx_lx34lJeEpTLVkP5k04qc";

// RegExps
RegExp filenameRegExp = RegExp(r"[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))");

// Api endpoints
const String apiUrl = "https://a.4cdn.org";
const String apiImagesUrl = "https://i.4cdn.org";
const String apiReleasesUrl =
    "https://api.github.com/repos/Rukkaitto/mobichan/releases";
const String apiCaptchaUrl = "https://sys.4channel.org/captcha";
const String apiFlagsUrl = "https://s.4cdn.org/image/country";
const String reverseImageSearchUrl = "https://images.google.com/searchbyimage";

// Routes
const String homeRoute = "/";
const String boardListRoute = "/boards";
const String settingsRoute = "/settings";
const String threadRoute = "/thread";

// Misc
const String lastVisitedBoard = 'last_visited_board';
const String lastVisitedBoardTitle = 'last_visited_board_title';
const String lastVisitedBoardWs = "last_visited_board_ws";
const String defaultBoard = 'g';
const String defaultBoardTitle = 'Technology';
const int defaultBoardWs = 1;
const String threadHistory = 'thread_history';
const String lastSortingOrder = 'last_sorting_order';
const String environment = 'env';
const String github = 'github';
const String playStore = 'play_store';
const String boardFavorites = 'board_favorites';

const double formMinHeight = 175;
const double threadFormMaxHeight = 315;
const double replyFormMaxHeight = 250;
const double imagePreviewHeight = 120;

const Color transparentColor = Color(0xaa000000);

// Text styles
const threadTitleTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

const threadNumbersTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.white,
  fontWeight: FontWeight.w400,
);

TextStyle postNameTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.secondary,
    fontWeight: FontWeight.w600,
  );
}

TextStyle postNoTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).hintColor,
  );
}

TextStyle snackbarTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).textTheme.bodyLarge!.color,
  );
}
