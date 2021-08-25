import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:mobichan/widgets/captcha_widget/captcha_widget.dart';

import 'components/form_fields.dart';

class FormWidget extends StatefulWidget {
  final String board;
  final bool isOpened;
  final PostType postType;
  final int? thread;
  final Function() onClose;
  final Function(Response<String>) onPost;
  final TextEditingController commentFieldController;

  FormWidget(
      {Key? key,
      this.thread,
      required this.board,
      required this.isOpened,
      required this.postType,
      required this.onClose,
      required this.onPost,
      required this.commentFieldController})
      : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _nameFieldController = TextEditingController();
  final _subjectFieldController = TextEditingController();
  final _captchaResponseFieldController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  PickedFile? _pickedFile;
  bool _expanded = false;
  bool _showCaptcha = false;

  void _onPictureIconPress() async {
    PickedFile? pickedFile =
        await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _pickedFile = pickedFile;
    });
  }

  void _onExpandIconPress() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _onSendIconPress() {
    setState(() {
      _showCaptcha = true;
    });
    // Take away focus to close keyboard
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<bool> _onWillPop() async {
    if (_showCaptcha) {
      setState(() {
        _showCaptcha = false;
        _captchaResponseFieldController.clear();
      });
      return false;
    }
    if (_expanded) {
      setState(() {
        _expanded = false;
      });
      return false;
    }
    if (widget.isOpened) {
      widget.onClose();
      return false;
    }
    return true;
  }

  void _onPost(Response<String> response) {
    if (response.data!.errorMsg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        Utils.buildSnackBar(
            context, response.data!.errorMsg!, Theme.of(context).errorColor),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        Utils.buildSnackBar(
            context, post_successful.tr(), Theme.of(context).cardColor),
      );
      widget.onPost(response);
    }
    setState(() {
      _showCaptcha = false;
      widget.commentFieldController.clear();
    });
  }

  void _onSend(String challenge, String attempt) {
    switch (widget.postType) {
      case PostType.reply:
        Api.sendReply(
          captchaChallenge: challenge,
          captchaResponse: attempt,
          board: widget.board,
          name: _nameFieldController.text,
          com: widget.commentFieldController.text,
          resto: widget.thread!,
          pickedFile: _pickedFile,
          onPost: _onPost,
        );
        break;
      case PostType.thread:
        Api.sendThread(
          captchaChallenge: challenge,
          captchaResponse: attempt,
          board: widget.board,
          subject: _subjectFieldController.text,
          name: _nameFieldController.text,
          com: widget.commentFieldController.text,
          pickedFile: _pickedFile,
          onPost: _onPost,
        );
        break;
    }
  }

  double computeHeight(bool expanded, bool showCaptcha, PostType postType,
      double fullHeight, PickedFile? pickedFile) {
    double height;
    if (showCaptcha) {
      height = fullHeight;
    } else {
      height = expanded
          ? (postType == PostType.thread
              ? THREAD_FORM_MAX_HEIGHT
              : REPLY_FORM_MAX_HEIGHT)
          : FORM_MIN_HEIGHT;
      if (pickedFile != null) {
        height += IMAGE_PREVIEW_HEIGHT + 10;
      }
    }
    return height;
  }

  @override
  Widget build(BuildContext context) {
    double height = computeHeight(_expanded, _showCaptcha, widget.postType,
        MediaQuery.of(context).size.height, _pickedFile);

    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return _onWillPop();
      },
      child: AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        top: widget.isOpened ? 0 : -height,
        width: MediaQuery.of(context).size.width,
        child: buildAnimatedContainer(height, context),
      ),
    );
  }

  AnimatedContainer buildAnimatedContainer(
      double height, BuildContext context) {
    return AnimatedContainer(
      height: height,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.3),
            ),
          ]),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: _showCaptcha
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 160,
                      child: CaptchaWidget(
                        board: widget.board,
                        thread: widget.thread,
                        onValidate: _onSend,
                      ),
                    ),
                  ),
                ],
              )
            : buildForm(context),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFields(
          expanded: _expanded,
          nameFieldController: _nameFieldController,
          postType: widget.postType,
          subjectFieldController: _subjectFieldController,
          commentFieldController: widget.commentFieldController,
          pickedFile: _pickedFile,
          clearPickedFile: () {
            setState(() {
              _pickedFile = null;
            });
          },
        ),
        buildIconButtons(context),
      ],
    );
  }

  Column buildIconButtons(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: _onSendIconPress,
          icon: Icon(
            Icons.send,
            color: Theme.of(context).accentColor,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _onPictureIconPress();
            });
          },
          icon: Icon(Icons.image),
        ),
        IconButton(
          onPressed: _onExpandIconPress,
          icon: Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
        ),
      ],
    );
  }
}
