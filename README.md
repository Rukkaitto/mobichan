# Mobichan

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/Rukkaitto/mobichan/graphs/commit-activity)
[![GitHub release](https://img.shields.io/github/release/Rukkaitto/mobichan.svg)](https://github.com/Rukkaitto/mobichan/releases/latest)
[![Github All Releases](https://img.shields.io/github/downloads/Rukkaitto/mobichan/total.svg)]()

<a target="_blank" href="https://play.google.com/store/apps/details?id=com.lucasgoudin.mobichan">
  <img src="https://steverichey.github.io/google-play-badge-svg/img/en_get.svg" width="25%">
</a>
  
A 4chan app made with Flutter.

## Features

- Browsing boards and threads
- Creating and responding to threads (with an up to date captcha)
- Viewing images
- Playing webms at different speeds
- Sorting and searching threads
- Gallery mode
- Threading
- Localization

## Screenshots

<img src="./screenshots/board.png" width="50%">
<img src="./screenshots/drawer.png" width="50%">
<img src="./screenshots/thread.png" width="50%">
<img src="./screenshots/replies.png" width="50%">

## Contributing

### Localization

- You can add a missing language by creating a json file in `assets/translations`.
- The json file must be named `{languageCode}-{countryCode}.json`.
- Finally, add the line `Locale('{languageCode}', '{countryCode}'),` to the `supportedLocales` array in `main.dart`.
- For further documentation, read [this](https://pub.dev/packages/easy_localization).

## Roadmap

For a detailed roadmap, see [here](https://github.com/Rukkaitto/mobichan/projects/1).
