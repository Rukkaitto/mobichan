import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/board.dart';

class BoardsPage extends StatefulWidget {
  const BoardsPage({Key? key}) : super(key: key);

  @override
  _BoardsPageState createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  late Future<List<Board>> futureBoards;

  @override
  void initState() {
    super.initState();
    futureBoards = fetchBoards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boards'),
      ),
      body: FutureBuilder<List<Board>>(
        future: futureBoards,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Board board = snapshot.data![index];
                return ListTile(
                  title: Text('/${board.board}/ - ${board.title}'),
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
