import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/core/core.dart';

import 'board_expansion_tile.dart';

class BoardExpansionTileWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget? child;
  final double? iconSize;
  final void Function()? onTap;

  const BoardExpansionTileWidget({
    required this.title,
    required this.icon,
    this.child,
    this.iconSize = 30,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<BoardExpansionTileWidget> createState() =>
      _BoardExpansionTileWidgetState();
}

class _BoardExpansionTileWidgetState extends State<BoardExpansionTileWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ConfigurableExpansionTile(
      onExpansionChanged: (isExpanded) {
        setState(() {
          this.isExpanded = isExpanded;
        });
      },
      header: Expanded(
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return Row(
                  children: [
                    if (state is Searching && widget.onTap == null)
                      widget.buildBackButton(context)
                    else
                      widget.buildIcon(),
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: state is Searching && widget.onTap == null
                          ? widget.buildSearchField(context)
                          : widget.buildTitle(context),
                    ),
                    if (isExpanded) widget.buildSearchIcon(context),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      children: widget.child != null ? [widget.child!] : [],
    );
  }
}
