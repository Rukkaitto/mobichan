import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';

class BoardExpansionTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget? child;
  final double? iconSize;
  final void Function()? onTap;

  const BoardExpansionTile({
    required this.title,
    required this.icon,
    this.child,
    this.iconSize = 30,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<BoardExpansionTile> createState() => _BoardExpansionTileState();
}

class _BoardExpansionTileState extends State<BoardExpansionTile> {
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
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(),
                      )
                    else
                      Icon(
                        widget.icon,
                        size: widget.iconSize,
                      ),
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: state is Searching && widget.onTap == null
                          ? TextField(
                              onChanged: (input) =>
                                  handleSearchFieldChanged(context, input),
                              decoration: InputDecoration(
                                hintText: search.tr(),
                                isDense: true,
                              ),
                              autofocus: true,
                            )
                          : Text(
                              widget.title,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                    ),
                    if (isExpanded)
                      IconButton(
                        onPressed: () => handleSearchIconPressed(context),
                        icon: const Icon(Icons.search),
                        padding: const EdgeInsets.only(right: 5),
                        constraints: const BoxConstraints(),
                      ),
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

  void handleSearchFieldChanged(BuildContext context, String input) {
    context.read<SearchCubit>().updateInput(input);
  }

  void handleSearchIconPressed(BuildContext context) {
    context.read<SearchCubit>().startSearching(context);
  }
}
