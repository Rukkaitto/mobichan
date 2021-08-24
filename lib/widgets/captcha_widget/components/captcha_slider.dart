import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/captcha_challenge.dart';

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
              left: _sliderValue * 200 - 50,
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