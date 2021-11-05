import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobichan/widgets/captcha_widget/components/captcha_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class CaptchaWidget extends StatefulWidget {
  final String board;
  final int? thread;
  final Function(String challenge, String attempt) onValidate;
  const CaptchaWidget(
      {Key? key,
      required this.onValidate,
      required this.board,
      required this.thread})
      : super(key: key);

  @override
  _CaptchaWidgetState createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  late Future<CaptchaChallenge> _captchaChallengeFuture;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() {
    _captchaChallengeFuture = context
        .read<CaptchaRepository>()
        .getCaptchaChallenge(widget.board, widget.thread);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _captchaChallengeFuture,
        builder: (context, AsyncSnapshot<CaptchaChallenge> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error is CaptchaChallengeException) {
              CaptchaChallengeException exception =
                  snapshot.error as CaptchaChallengeException;
              return Text(
                  '${exception.error}, wait for ${exception.refreshTime}s.');
            } else {
              return Text('${snapshot.error}');
            }
          }
          if (snapshot.hasData) {
            return CaptchaSlider(
              onValidate: widget.onValidate,
              backgroundImage:
                  Image.memory(base64Decode(snapshot.data!.backgroundImage)),
              foregroundImage:
                  Image.memory(base64Decode(snapshot.data!.foregroundImage)),
              captchaChallenge: snapshot.data!,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
