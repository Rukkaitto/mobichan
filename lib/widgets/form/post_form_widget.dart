import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/widgets/captcha_widget.dart';

class PostFormWidget extends StatefulWidget {
  final String board;
  final int thread;

  PostFormWidget({Key? key, required this.board, required this.thread})
      : super(key: key);

  @override
  _PostFormWidgetState createState() => _PostFormWidgetState();
}

class _PostFormWidgetState extends State<PostFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String? captchaResponse;
  final nameFieldController = TextEditingController();
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
                      sendPost(
                          captchaResponse: captchaResponse!,
                          board: widget.board,
                          name: nameFieldController.text,
                          com: commentFieldController.text,
                          resto: widget.thread,
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
