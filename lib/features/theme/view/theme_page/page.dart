import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/theme/theme.dart';
import 'package:mobichan/theme.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ThemePage extends StatefulWidget {
  static String routeName = '/theme';

  const ThemePage({Key? key}) : super(key: key);

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  final themes = [theme, ThemeData.dark(), ThemeData.light()];

  ThemeData chosenTheme = theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check_rounded),
        onPressed: () => context.read<ThemeCubit>().changeTheme(chosenTheme),
      ),
      body: PhotoViewGallery.builder(
        onPageChanged: (index) => setState(() => chosenTheme = themes[index]),
        itemCount: themes.length,
        builder: (context, index) {
          final currentTheme = themes[index];
          return PhotoViewGalleryPageOptions.customChild(
            child: Theme(
              data: currentTheme,
              child: IgnorePointer(
                child: buildPreview(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPreview() {
    return Column(
      children: [
        ReplyWidget(
          board: const Board(
            board: 'g',
            title: 'Techonology',
            wsBoard: 1,
          ),
          post: Post(no: 478927, com: 'test'),
          threadReplies: const [],
        ),
      ],
    );
  }
}
