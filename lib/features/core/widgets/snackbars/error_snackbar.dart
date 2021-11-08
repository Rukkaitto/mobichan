import 'package:flutter/material.dart';

var errorSnackbar = (BuildContext context, String text) => SnackBar(
      backgroundColor: Theme.of(context).errorColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      content: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
