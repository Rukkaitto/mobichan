import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';

class ThreadFormWidget extends StatefulWidget {
  final String board;
  final double height;
  static double minHeight = 175;
  static double maxHeight = 315;

  ThreadFormWidget({Key? key, required this.board, required this.height})
      : super(key: key);

  @override
  _ThreadFormWidgetState createState() => _ThreadFormWidgetState();
}

class _ThreadFormWidgetState extends State<ThreadFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String? captchaResponse;
  final nameFieldController = TextEditingController();
  final subjectFieldController = TextEditingController();
  final commentFieldController = TextEditingController();
  bool expanded = false;

  void _onExpandIconPress() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: expanded ? ThreadFormWidget.maxHeight : widget.height,
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
        child: FocusTraversalGroup(
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
                      expanded
                          ? TextFormField(
                              decoration: InputDecoration(labelText: 'Name'),
                              controller: nameFieldController,
                            )
                          : Container(),
                      expanded
                          ? TextFormField(
                              decoration: InputDecoration(labelText: 'Subject'),
                              controller: subjectFieldController,
                            )
                          : Container(),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Comment'),
                        controller: commentFieldController,
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
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.image),
                    ),
                    IconButton(
                      onPressed: _onExpandIconPress,
                      icon: Icon(expanded
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
