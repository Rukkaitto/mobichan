import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';

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
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: widget.iconSize,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline1,
                ),
                const Spacer(),
                isExpanded
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                        padding: const EdgeInsets.only(right: 5),
                        constraints: const BoxConstraints(),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      children: widget.child != null ? [widget.child!] : [],
    );
  }
}
