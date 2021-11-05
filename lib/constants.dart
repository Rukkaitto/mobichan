import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String APP_TITLE = "Mobichan";
const String CAPTCHA_SITE_KEY = "6Ldp2bsSAAAAAAJ5uyx_lx34lJeEpTLVkP5k04qc";

// RegExps
RegExp filenameRegExp = RegExp(r"[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))");

// Api endpoints
const String API_URL = "https://a.4cdn.org";
const String API_IMAGES_URL = "https://i.4cdn.org";
const String API_RELEASES_URL =
    "https://api.github.com/repos/Rukkaitto/mobichan/releases";
const String API_CAPTCHA_URL = "https://sys.4channel.org/captcha";
const String API_FLAGS_URL = "https://s.4cdn.org/image/country";

// Routes
const String HOME_ROUTE = "/";
const String BOARDS_LIST_ROUTE = "/boards";
const String SETTINGS_ROUTE = "/settings";
const String THREAD_ROUTE = "/thread";

// Misc
const String LAST_VISITED_BOARD = 'last_visited_board';
const String LAST_VISITED_BOARD_TITLE = 'last_visited_board_title';
const String LAST_VISITED_BOARD_WS = "last_visited_board_ws";
const String DEFAULT_BOARD = 'g';
const String DEFAULT_BOARD_TITLE = 'Technology';
const int DEFAULT_BOARD_WS = 1;
const String THREAD_HISTORY = 'thread_history';
const String LAST_SORTING_ORDER = 'last_sorting_order';
const String ENVIRONMENT = 'env';
const String GITHUB = 'github';
const String PLAY_STORE = 'play_store';
const String BOARD_FAVORITES = 'board_favorites';

const double FORM_MIN_HEIGHT = 175;
const double THREAD_FORM_MAX_HEIGHT = 315;
const double REPLY_FORM_MAX_HEIGHT = 250;
const double IMAGE_PREVIEW_HEIGHT = 120;

const Color TRANSPARENT_COLOR = Color(0xaa000000);

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
    color: Theme.of(context).colorScheme.primary,
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
    color: Theme.of(context).textTheme.bodyText1!.color,
  );
}
