import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';

class BoardExpansionTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ConfigurableExpansionTile(
      header: Expanded(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: iconSize,
                ),
                SizedBox(
                  width: 18,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ),
        ),
      ),
      children: child != null ? [child!] : [],
    );
  }
}
