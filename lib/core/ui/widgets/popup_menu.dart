import 'package:flutter/material.dart';

typedef PopupMenuBuilder<T> = List<PopupMenuEntry<T>> Function();
typedef PopupSelectionHandler<T> = Future<void> Function(T selected);

class TopRightPopupMenuIcon<T> extends StatelessWidget {
  final PopupMenuBuilder<T> menuBuilder;
  final PopupSelectionHandler<T> onSelected;
  final Color iconColor;
  final IconData icon;
  final double iconSize;

  const TopRightPopupMenuIcon({
    super.key,
    required this.menuBuilder,
    required this.onSelected,
    this.icon = Icons.more_vert,
    this.iconColor = Colors.black,
    this.iconSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTapDown: (TapDownDetails details) async {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final Offset tapPosition = details.globalPosition;
        const Size menuSize = Size(160, 48 * 4); // adjust max size accordingly

        final RelativeRect position = RelativeRect.fromLTRB(
          tapPosition.dx - menuSize.width,
          tapPosition.dy + 8,
          overlay.size.width - tapPosition.dx,
          overlay.size.height - tapPosition.dy,
        );

        final T? selected = await showMenu<T>(
          context: context,
          color: colorScheme.primary,
          position: position,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          items: menuBuilder(),
        );

        if (selected != null) {
          await onSelected(selected);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
