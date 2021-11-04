import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/pages/boards_cubit/boards_view.dart';
import 'package:mobichan/pages/boards_cubit/cubit/boards_cubit.dart';

class BoardsPage2 extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
      child: Padding
      ( padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: 
           
           BlocProvider(
                create: (context) => BoardsCubit(
                  
                )..getBoards(),
                child: BoardsViewBloc(),
              ),
             
          
        ),
        ),
    );
  }
}