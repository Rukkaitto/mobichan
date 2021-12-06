import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/core/core.dart';

class AsyncBlocBuilder<
    T,
    CubitType extends Cubit<State>,
    State extends BaseState,
    Loading extends BaseLoadingState,
    Loaded extends BaseLoadedState<T>,
    Error extends BaseErrorState> extends StatelessWidget {
  final Widget Function(T data) builder;
  final Widget Function()? loadingBuilder;

  const AsyncBlocBuilder({required this.builder, this.loadingBuilder, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitType, State>(
      listener: (context, state) {
        if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackbar(context, state.message),
          );
        }
      },
      builder: (context, state) {
        if (state is Loading) {
          return loadingBuilder?.call() ??
              const Center(
                child: CircularProgressIndicator(),
              );
        } else if (state is Loaded) {
          return builder(state.data);
        } else {
          return Container();
        }
      },
    );
  }
}
