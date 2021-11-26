import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'form_widget.dart';

class FormWidget extends StatelessWidget {
  final Duration animationDuration = const Duration(milliseconds: 300);

  final Board board;
  final Post? thread;

  const FormWidget({required this.board, this.thread, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostFormCubit, PostFormState>(
      builder: (context, form) {
        form.commentController.text = form.comment;
        form.commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: form.comment.length),
        );
        return WillPopScope(
          onWillPop: () async => handlePop(context, form),
          child: AnimatedPositioned(
            duration: animationDuration,
            curve: Curves.easeInOut,
            top: form.isVisible ? 0 : -form.heightWithImage,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) =>
                  handleVerticalDrag(context, details),
              child: AnimatedContainer(
                duration: animationDuration,
                curve: Curves.easeInOut,
                width: double.infinity,
                height: form.heightWithImage,
                color: Theme.of(context).cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                if (form.isExpanded)
                                  buildNameTextField(form.nameController),
                                if (form.isExpanded)
                                  buildSubjectTextField(form.subjectController),
                                buildCommentTextField(
                                    context, form.commentController),
                                if (form.file != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        buildImagePreview(form.file!),
                                        IconButton(
                                          onPressed: () =>
                                              handleClearIconPressed(context),
                                          icon: const Icon(Icons.clear),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.image),
                                onPressed: () =>
                                    handlePictureIconPressed(context),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () => handleSendIconPressed(
                                  context,
                                  form,
                                  board,
                                  thread,
                                ),
                              ),
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
                      onPressed: () => handleExpandPressed(context, form),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
