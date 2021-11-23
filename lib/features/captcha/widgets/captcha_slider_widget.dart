import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class CaptchaSliderWidget extends StatefulWidget {
  final CaptchaChallenge captchaChallenge;
  final Image backgroundImage;
  final Image foregroundImage;
  final Function(String attempt) onValidate;

  const CaptchaSliderWidget({
    Key? key,
    required this.backgroundImage,
    required this.foregroundImage,
    required this.onValidate,
    required this.captchaChallenge,
  }) : super(key: key);

  @override
  _CaptchaSliderWidgetState createState() => _CaptchaSliderWidgetState();
}

class _CaptchaSliderWidgetState extends State<CaptchaSliderWidget> {
  final TextEditingController _controller = TextEditingController();
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Positioned.fill(
                child: Container(
              color: const Color.fromARGB(255, 238, 238, 238),
            )),
            Positioned(
              left: _sliderValue * 200 - 50,
              child: SizedBox(
                width: widget.captchaChallenge.backgroundImageWidth.toDouble(),
                child: widget.backgroundImage,
              ),
            ),
            SizedBox(
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: typeCaptchaHere.tr(),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => widget.onValidate(
                  _controller.text,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
