import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../util/color_util.dart';
import '../util/constants.dart';
import '../widgets/update_color_dialog.dart';

class ColorSearchButton extends StatelessWidget {
  const ColorSearchButton({required this.color, Key? key}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    final Color onSurface =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
      child: SizedBox(
        height: 36,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultRadius),
            ),
            side: BorderSide(color: onSurface),
          ),
          icon: Icon(
            FeatherIcons.search,
            size: 16,
            color: onSurface,
          ),
          label: Text(
            color.toHexStr(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: onSurface),
          ),
          onPressed: () {
            showSlidersDialog(context, color);
          },
        ),
      ),
    );
  }
}

class OutlinedIconButton extends StatelessWidget {
  const OutlinedIconButton(
      {required this.child, this.borderColor, this.onPressed, Key? key})
      : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface, padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          side: BorderSide(
            color: borderColor ??
                Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
