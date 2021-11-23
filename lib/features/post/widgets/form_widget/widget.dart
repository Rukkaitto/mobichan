import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'form_widget.dart';

class FormWidget extends StatelessWidget {
  final Duration animationDuration = const Duration(milliseconds: 300);
  final double contractedHeight = 190;
  final double expandedHeight = 320;

  final Board board;
  final Post? thread;

  const FormWidget({required this.board, this.thread, Key? key})
      : super(key: key);

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
                              icon: const Icon(Icons.image),
                              onPressed: () =>
                                  handlePictureIconPressed(context),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              onPressed: () => handleSendIconPressed(
                                context,
                                form,
                                board,
                                thread,
                              ),
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
                    onPressed: () => handleExpandPressed(context, form),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
