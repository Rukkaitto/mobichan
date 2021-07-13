import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/exceptions/captcha_challenge_exception.dart';
import 'package:mobichan/classes/models/captcha_challenge.dart';

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
    _captchaChallengeFuture =
        Api.fetchCaptchaChallenge(widget.board, widget.thread);
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

class CaptchaSlider extends StatefulWidget {
  final CaptchaChallenge captchaChallenge;
  final Image backgroundImage;
  final Image foregroundImage;
  final Function(String challenge, String attempt) onValidate;

  const CaptchaSlider({
    Key? key,
    required this.backgroundImage,
    required this.foregroundImage,
    required this.onValidate,
    required this.captchaChallenge,
  }) : super(key: key);

  @override
  _CaptchaSliderState createState() => _CaptchaSliderState();
}

class _CaptchaSliderState extends State<CaptchaSlider> {
  TextEditingController _controller = TextEditingController();
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Positioned.fill(
                child: Container(
              color: Color.fromARGB(255, 238, 238, 238),
            )),
            Positioned(
              left: _sliderValue * 150 - 50,
              child: Container(
                width: widget.captchaChallenge.backgroundImageWidth.toDouble(),
                child: widget.backgroundImage,
              ),
            ),
            Container(
              width: widget.captchaChallenge.foregroundImageWidth.toDouble(),
              height: widget.captchaChallenge.foregroundImageHeight.toDouble(),
              child: widget.foregroundImage,
            ),
          ],
        ),
        Slider(
          value: _sliderValue,
          onChanged: (newValue) {
            setState(() {
              _sliderValue = newValue;
            });
          },
        ),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Type captcha here',
            suffixIcon: IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () => widget.onValidate(
                widget.captchaChallenge.challenge,
                _controller.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
