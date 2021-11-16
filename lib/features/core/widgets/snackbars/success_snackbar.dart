import 'package:flutter/material.dart';

var successSnackbar = (BuildContext context, String text) => SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      content: Text(
        text,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
