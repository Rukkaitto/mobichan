import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';

import 'form_widget.dart';

extension FormWidgetBuilders on FormWidget {
  Widget buildImagePreview(XFile file) {
    return Flexible(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
          File(file.path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildCommentTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: comment.tr(),
        ),
        enableInteractiveSelection: true,
        maxLines: 5,
        autofocus: true,
        style: TextStyle(color: Colors.white),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget buildNameTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: name.tr(),
        ),
        enableInteractiveSelection: true,
        style: TextStyle(color: Colors.white),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget buildSubjectTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: subject.tr(),
        ),
        enableInteractiveSelection: true,
        style: TextStyle(color: Colors.white),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
