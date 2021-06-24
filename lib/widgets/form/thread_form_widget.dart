import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/widgets/captcha_widget.dart';

class ThreadFormWidget extends StatefulWidget {
  final String board;

  ThreadFormWidget({Key? key, required this.board}) : super(key: key);

  @override
  _ThreadFormWidgetState createState() => _ThreadFormWidgetState();
}

class _ThreadFormWidgetState extends State<ThreadFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String? captchaResponse;
  final nameFieldController = TextEditingController();
  final subjectFieldController = TextEditingController();
  final commentFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 3,
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: FocusTraversalGroup(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          onChanged: () => Form.of(primaryFocus!.context!)!.save(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: nameFieldController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Subject'),
                  controller: subjectFieldController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Comment'),
                  controller: commentFieldController,
                  maxLines: 5,
                ),
                Flexible(
                  child: CaptchaWidget(
                    captchaCallback: (response) {
                      setState(() {
                        captchaResponse = response;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendThread(
                          captchaResponse: captchaResponse!,
                          board: widget.board,
                          subject: subjectFieldController.text,
                          name: nameFieldController.text,
                          com: commentFieldController.text,
                          onPost: (response) {
                            print(response);
                          });
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
