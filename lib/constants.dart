import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String APP_TITLE = "Mobichan";
const String CAPTCHA_SITE_KEY = "6Ldp2bsSAAAAAAJ5uyx_lx34lJeEpTLVkP5k04qc";

// Api endpoints
const String API_URL = "https://a.4cdn.org";
const String API_IMAGES_URL = "https://i.4cdn.org";
const String API_BOARDS_URL = "https://a.4cdn.org/boards.json";

// Routes
const String BOARDS_LIST_ROUTE = "/boards";

// Misc
const String LAST_VISITED_BOARD = 'last_visited_board';
const String LAST_VISITED_BOARD_TITLE = 'last_visited_board_title';

const double FORM_MIN_HEIGHT = 175;
const double THREAD_FORM_MAX_HEIGHT = 315;
const double REPLY_FORM_MAX_HEIGHT = 250;
const double IMAGE_PREVIEW_HEIGHT = 120;

// Text styles
const threadTitleTextStyle = TextStyle(
  fontSize: 26,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

const threadNumbersTextStyle = TextStyle(
  fontSize: 24,
  color: Colors.white,
  fontWeight: FontWeight.w400,
);

TextStyle postNameTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).accentColor,
    fontWeight: FontWeight.w600,
  );
}

TextStyle postNoTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).hintColor,
  );
}

TextStyle errorSnackbarTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).textTheme.bodyText1!.color,
  );
}
