import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/classes/shared_preferences/board_shared_prefs.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:mobichan/widgets/drawer_widget.dart';
import 'package:mobichan/widgets/thread_widget.dart';

class BoardPage extends StatefulWidget {
  static const routeName = '/board';
  final BoardPageArguments args;
  const BoardPage({Key? key, required this.args}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  late Future<List<Post>> futureOPs;

  @override
  void initState() {
    futureOPs = fetchOPs(board: widget.args.board);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('/${widget.args.board}/ - ${widget.args.title}'),
      ),
      body: FutureBuilder<List<Post>>(
        future: futureOPs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Post op = snapshot.data![index];
                return ThreadWidget(
                  post: op,
                  board: widget.args.board,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
