import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/widgets/captcha_widget.dart';

class FormWidget extends StatefulWidget {
  final String board;
  final bool isOpened;
  final PostType postType;
  final int? thread;
  final Function() onClose;
  final Function(Response<String>) onPost;

  FormWidget(
      {Key? key,
      this.thread,
      required this.board,
      required this.isOpened,
      required this.postType,
      required this.onClose,
      required this.onPost})
      : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();
  final _subjectFieldController = TextEditingController();
  final _commentFieldController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _captchaResponse;
  PickedFile? _pickedFile;
  bool _expanded = false;
  bool _showCaptcha = false;

  void _onPictureIconPress() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
  }

  void _onExpandIconPress() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _onSendIconPress() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showCaptcha = true;
      });
      // Take away focus to close keyboard
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  Future<bool> _onWillPop() async {
    if (_showCaptcha) {
      setState(() {
        _showCaptcha = false;
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
    widget.onPost(response);
    setState(() {
      _showCaptcha = false;
    });
  }

  void _onValidateCaptcha(String response) {
    setState(() {
      _captchaResponse = response;
    });
    switch (widget.postType) {
      case PostType.reply:
        Api.sendReply(
          captchaResponse: _captchaResponse!,
          board: widget.board,
          name: _nameFieldController.text,
          com: _commentFieldController.text,
          resto: widget.thread!,
          pickedFile: _pickedFile,
          onPost: _onPost,
        );
        break;
      case PostType.thread:
        Api.sendThread(
          captchaResponse: _captchaResponse!,
          board: widget.board,
          subject: _subjectFieldController.text,
          name: _nameFieldController.text,
          com: _commentFieldController.text,
          pickedFile: _pickedFile!,
          onPost: _onPost,
        );
        break;
    }
  }

  double computeHeight(
      bool expanded, bool showCaptcha, PostType postType, double fullHeight) {
    double height;
    if (showCaptcha) {
      height = fullHeight;
    } else {
      height = expanded
          ? (postType == PostType.thread
              ? THREAD_FORM_MAX_HEIGHT
              : REPLY_FORM_MAX_HEIGHT)
          : FORM_MIN_HEIGHT;
    }
    return height;
  }

  @override
  Widget build(BuildContext context) {
    double height = computeHeight(_expanded, _showCaptcha, widget.postType,
        MediaQuery.of(context).size.height);

    return WillPopScope(
      onWillPop: _onWillPop,
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
        padding: EdgeInsets.all(15.0),
        child: _showCaptcha
            ? CaptchaWidget(
                onValidate: _onValidateCaptcha,
              )
            : buildForm(context),
      ),
    );
  }

  FocusTraversalGroup buildForm(BuildContext context) {
    return FocusTraversalGroup(
      descendantsAreFocusable: true,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        onChanged: () => Form.of(primaryFocus!.context!)!.save(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormFields(
                expanded: _expanded,
                nameFieldController: _nameFieldController,
                widget: widget,
                subjectFieldController: _subjectFieldController,
                commentFieldController: _commentFieldController),
            buildIconButtons(context),
          ],
        ),
      ),
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

class FormFields extends StatelessWidget {
  const FormFields({
    Key? key,
    required bool expanded,
    required TextEditingController nameFieldController,
    required this.widget,
    required TextEditingController subjectFieldController,
    required TextEditingController commentFieldController,
  })  : _expanded = expanded,
        _nameFieldController = nameFieldController,
        _subjectFieldController = subjectFieldController,
        _commentFieldController = commentFieldController,
        super(key: key);

  final bool _expanded;
  final TextEditingController _nameFieldController;
  final FormWidget widget;
  final TextEditingController _subjectFieldController;
  final TextEditingController _commentFieldController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _expanded
              ? TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: _nameFieldController,
                )
              : Container(),
          _expanded && widget.postType == PostType.thread
              ? TextFormField(
                  decoration: InputDecoration(labelText: 'Subject'),
                  controller: _subjectFieldController,
                )
              : Container(),
          TextFormField(
            decoration: InputDecoration(labelText: 'Comment'),
            controller: _commentFieldController,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
