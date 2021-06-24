import 'package:flutter/material.dart';

class PostActionButton extends StatelessWidget {
  final Function()? onPressed;
  const PostActionButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.edit),
      onPressed: onPressed,
    );
  }
}
