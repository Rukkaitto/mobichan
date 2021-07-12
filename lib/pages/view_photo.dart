import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPhotos extends StatefulWidget {
  final String heroTitle;
  final imageIndex;
  final List<dynamic>? imageList;
  ViewPhotos({this.imageIndex, this.imageList, this.heroTitle = "img"});

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  late PageController pageController;
  int? currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "${currentIndex! + 1} out of ${widget.imageList!.length}",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        centerTitle: true,
        leading: Container(),
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            pageController: pageController,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.imageList![index]),
                heroAttributes:
                    PhotoViewHeroAttributes(tag: "photo${widget.imageIndex}"),
              );
            },
            onPageChanged: onPageChanged,
            itemCount: widget.imageList!.length,
            loadingBuilder: (context, progress) => Center(
              child: Container(
                width: 60.0,
                height: 60.0,
                child: (progress == null ||
                        progress.cumulativeBytesLoaded == null ||
                        progress.expectedTotalBytes == null)
                    ? CircularProgressIndicator()
                    : CircularProgressIndicator(
                        value: progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!,
                      ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
