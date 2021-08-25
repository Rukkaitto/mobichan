import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/pages/image_viewer_page.dart';
import 'package:mobichan/pages/webm_viewer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class PostImage extends StatefulWidget {
  const PostImage({
    Key? key,
    required this.board,
    required this.post,
  }) : super(key: key);

  final String board;
  final Post post;

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<String> _getImageUrl(
      Post post, String board, ConnectivityResult connectivityStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final highResolutionThumbnailsMobile =
        prefs.getString('HIGH_RESOLUTION_THUMBNAILS_MOBILE')?.parseBool() ??
            false;
    final highResolutionThumbnailsWifi =
        prefs.getString('HIGH_RESOLUTION_THUMBNAILS_WIFI')?.parseBool() ?? true;
    final isWebm = post.ext == '.webm';

    if (((connectivityStatus == ConnectivityResult.wifi &&
                highResolutionThumbnailsWifi) ||
            (connectivityStatus == ConnectivityResult.mobile &&
                highResolutionThumbnailsMobile)) &&
        !isWebm) {
      return '$API_IMAGES_URL/$board/${post.tim}${post.ext}';
    } else {
      return '$API_IMAGES_URL/$board/${post.tim}s.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (widget.post.ext == '.webm') {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, _, __) =>
                    WebmViewerPage(widget.board, widget.post),
              ),
            );
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, _, __) =>
                    ImageViewerPage(widget.board, widget.post),
              ),
            );
          }
        },
        child: FutureBuilder(
          future: _getImageUrl(widget.post, widget.board, _connectionStatus),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Hero(
                tag: widget.post.tim.toString(),
                child: Image.network(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
