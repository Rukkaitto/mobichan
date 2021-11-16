import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class FormWidget extends StatelessWidget {
  final Duration animationDuration = Duration(milliseconds: 300);
  final double contractedHeight = 190;
  final double expandedHeight = 320;

  final Board board;
  final Post? thread;

  FormWidget({required this.board, this.thread, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostFormCubit, PostFormState>(
      builder: (context, form) {
        return AnimatedPositioned(
          duration: animationDuration,
          curve: Curves.easeInOut,
          top: form.isVisible
              ? 0
              : (form.isExpanded ? -expandedHeight : -contractedHeight),
          left: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              int sensitivity = 8;
              if (details.delta.dy > sensitivity) {
                context.read<PostFormCubit>().setExpanded(true);
              } else if (details.delta.dy < -sensitivity) {
                context.read<PostFormCubit>().setExpanded(false);
              }
            },
            child: AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeInOut,
              width: double.infinity,
              height: form.isExpanded ? expandedHeight : contractedHeight,
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              if (form.isExpanded)
                                buildNameTextField(form.nameController),
                              if (form.isExpanded)
                                buildSubjectTextField(form.subjectController),
                              buildCommentTextField(form.commentController),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.image),
                              onPressed: () => _onPictureIconPress(context),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              onPressed: () => _onSendIconPress(context, form),
                            ),
                            if (form.file != null)
                              buildImagePreview(form.file!),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      form.isExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 30,
                    ),
                    onPressed: () {
                      context
                          .read<PostFormCubit>()
                          .setExpanded(!form.isExpanded);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

  void _onPictureIconPress(BuildContext context) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<PostFormCubit>().setFile(pickedFile);
    }
  }

  void _onSendIconPress(BuildContext context, PostFormState form) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CaptchaPage(
          context: context,
          board: board,
          thread: thread,
          post: Post(
            name: form.nameController.text,
            sub: form.subjectController.text,
            com: form.commentController.text,
          ),
          file: form.file,
        );
      },
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
