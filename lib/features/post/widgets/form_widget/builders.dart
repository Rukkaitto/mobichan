import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobichan/core/cubits/cubits.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'form_widget.dart';

extension FormWidgetBuilders on FormWidget {
  Widget buildImagePreview(File file) {
    return Flexible(
      child: SizedBox(
        height: PostFormState.imageHeight,
        child: Image.file(file),
      ),
    );
  }

  Widget buildCommentTextField(TextEditingController controller) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            context.read<PostFormCubit>().setComment(value);
          },
          controller: controller,
          decoration: InputDecoration(
            hintText: kComment.tr(),
          ),
          enableInteractiveSelection: true,
          maxLines: 5,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
      );
    });
  }

  Widget buildNameTextField(TextEditingController controller) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: kName.tr(),
          ),
          enableInteractiveSelection: true,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
      );
    });
  }

  Widget buildSubjectTextField(TextEditingController controller) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: kSubject.tr(),
          ),
          enableInteractiveSelection: true,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
      );
    });
  }
}
