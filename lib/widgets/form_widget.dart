import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/widgets/captcha_widget.dart';

class FormWidget extends StatefulWidget {
  final String board;
  final double height;
  final PostType postType;
  final int? thread;

  FormWidget(
      {Key? key,
      this.thread,
      required this.board,
      required this.height,
      required this.postType})
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

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _expanded
          ? (widget.postType == PostType.thread
              ? THREAD_FORM_MAX_HEIGHT
              : REPLY_FORM_MAX_HEIGHT)
          : widget.height,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
          color: Colors.white,
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
            ? CaptchaWidget(onValidate: (response) {
                setState(() {
                  _captchaResponse = response;
                  switch (widget.postType) {
                    case PostType.reply:
                      Api.sendReply(
                          captchaResponse: _captchaResponse!,
                          board: widget.board,
                          name: _nameFieldController.text,
                          com: _commentFieldController.text,
                          resto: widget.thread!,
                          pickedFile: _pickedFile,
                          onPost: (response) {
                            print(response);
                          });
                      break;
                    case PostType.thread:
                      Api.sendThread(
                          captchaResponse: _captchaResponse!,
                          board: widget.board,
                          subject: _subjectFieldController.text,
                          name: _nameFieldController.text,
                          com: _commentFieldController.text,
                          pickedFile: _pickedFile!,
                          onPost: (response) {});
                      break;
                  }
                });
              })
            : FocusTraversalGroup(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: () => Form.of(primaryFocus!.context!)!.save(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _expanded
                                ? TextFormField(
                                    decoration:
                                        InputDecoration(labelText: 'Name'),
                                    controller: _nameFieldController,
                                  )
                                : Container(),
                            _expanded && widget.postType == PostType.thread
                                ? TextFormField(
                                    decoration:
                                        InputDecoration(labelText: 'Subject'),
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
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _showCaptcha = true;
                                });
                              }
                            },
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
                            icon: Icon(_expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}