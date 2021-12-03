import 'package:flutter/material.dart';

SnackBar successSnackbar(BuildContext context, String text) => SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
