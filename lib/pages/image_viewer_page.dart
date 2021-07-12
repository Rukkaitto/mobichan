import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/utils/utils.dart';

class ImageViewerPage extends StatelessWidget {
  final Post post;
  final String board;

  const ImageViewerPage(this.board, this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SnackBar buildSnackBar(bool isSuccess) {
      return SnackBar(
        backgroundColor: isSuccess
            ? Theme.of(context).cardColor
            : Theme.of(context).errorColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        content: Text(
          isSuccess ? 'Image saved successfully.' : 'Error saving image.',
          style: snackbarTextStyle(context),
        ),
      );
    }

    void _saveImage() async {
      // if (await Permission.storage.request().isGranted) {
      //   // var response = await Dio().get(
      //   //     '$API_IMAGES_URL/$board/${post.tim}${post.ext}',
      //   //     options: Options(responseType: ResponseType.bytes));
      //   // final result = await ImageGallerySaver.saveImage(
      //   //     Uint8List.fromList(response.data),
      //   //     quality: 100,
      //   //     name: '${post.filename}${post.ext}');
      //   var appDocDir = await getExternalStorageDirectory();
      //   String saveDirPath = '${appDocDir!.path}/Mobichan';
      //   final saveDir = await Directory(saveDirPath).create();
      //   String savePath = '${saveDir.path}/${post.filename}${post.ext}';
      //   print(savePath);
      //   await Dio().download(
      //       "$API_IMAGES_URL/$board/${post.tim}${post.ext}", savePath);
      //   final result = await ImageGallerySaver.saveFile(savePath);

      //   ScaffoldMessenger.of(context).showSnackBar(
      //     buildSnackBar(result['isSuccess']),
      //   );
      // }
      bool? result = await Utils.saveImage(
        '$API_IMAGES_URL/$board/${post.tim}${post.ext}',
        albumName: 'Mobichan',
      );
      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(result!),);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${post.filename}${post.ext}'),
        actions: [
          IconButton(
            onPressed: _saveImage,
            icon: Icon(Icons.save_rounded),
          ),
        ],
      ),
      backgroundColor: TRANSPARENT_COLOR,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: post.tim.toString(),
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              child: Stack(
                children: [
                  Image.network(
                    '$API_IMAGES_URL/$board/${post.tim}s.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Image.network(
                    '$API_IMAGES_URL/$board/${post.tim}${post.ext}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
