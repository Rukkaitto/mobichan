import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/enums/enums.dart';

import '../../../constants.dart';

class FormFields extends StatelessWidget {
  const FormFields({
    Key? key,
    pickedFile,
    required bool expanded,
    required TextEditingController nameFieldController,
    required PostType postType,
    required TextEditingController subjectFieldController,
    required TextEditingController commentFieldController,
    required Function() clearPickedFile,
  })  : _expanded = expanded,
        _nameFieldController = nameFieldController,
        _postType = postType,
        _subjectFieldController = subjectFieldController,
        _commentFieldController = commentFieldController,
        _pickedfile = pickedFile,
        _clearPickedFile = clearPickedFile,
        super(key: key);

  final bool _expanded;
  final TextEditingController _nameFieldController;
  final PostType _postType;
  final TextEditingController _subjectFieldController;
  final TextEditingController _commentFieldController;
  final PickedFile? _pickedfile;
  final Function() _clearPickedFile;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (_expanded)
            TextFormField(
              decoration: InputDecoration(labelText: 'name'.tr()),
              controller: _nameFieldController,
            ),
          if (_expanded && _postType == PostType.thread)
            TextFormField(
              decoration: InputDecoration(labelText: 'subject'.tr()),
              controller: _subjectFieldController,
            ),
          TextFormField(
            decoration: InputDecoration(labelText: 'comment'.tr()),
            controller: _commentFieldController,
            maxLines: 5,
          ),
          if (_pickedfile != null)
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.file(
                    File(_pickedfile!.path),
                    height: IMAGE_PREVIEW_HEIGHT,
                  ),
                  IconButton(
                    onPressed: _clearPickedFile,
                    icon: Icon(Icons.cancel_rounded),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
