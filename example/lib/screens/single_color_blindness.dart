import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../util/color_blindness.dart';
import '../util/color_util.dart';
import '../util/selected.dart';
import '../vertical_picker/app_bar_actions.dart';
import '../widgets/update_color_dialog.dart';
import 'color_library.dart';

class SingleColorBlindness extends StatelessWidget {
  const SingleColorBlindness({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorsCubit, ColorsState>(
      builder: (_, state) {
        final color = state.rgbColors[state.selected]!;
        final values = retrieveColorBlind(color);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: color,
            elevation: 0,
            title: const Text("Color Blindness"),
            actions: <Widget>[
              ColorSearchButton(color: color),
              const SizedBox(width: 8),
            ],
          ),
          backgroundColor: color,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 818),
              child: Card(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.40),
                  ),
                ),
                elevation: 0,
                margin: const EdgeInsets.all(16),
                child: ListView(
                  key: const PageStorageKey("color_blind"),
                  children: <Widget>[
                    const SizedBox(height: 24),
                    for (var key in values.keys) ...[
                      Text(
                        key,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: LayoutBuilder(
                          builder: (context, builder) {
                            final numOfItems = (builder.maxWidth / 280).floor();
                            return Wrap(
                              children: <Widget>[
                                for (var value in values[key]!) ...[
                                  SizedBox(
                                    width: builder.maxWidth / numOfItems,
                                    height: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: _ColorBlindCard(value, color),
                                    ),
                                  )
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (key != "Monochromacy")
                        Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.40),
                        ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // sources:
  // https://www.color-blindness.com/
  // https://www.color-blindness.com/category/tools/
  // https://en.wikipedia.org/wiki/Color_blindness
  // https://en.wikipedia.org/wiki/Dichromacy
  Map<String, List<ColorWithBlind>> retrieveColorBlind(Color color) {
    const m = "of males";
    const f = "of females";
    const p = "of population";

    return {
      "Trichromacy": [
        ColorWithBlind(protanomaly(color), "Protanomaly", "1% $m, 0.01% $f"),
        ColorWithBlind(deuteranomaly(color), "Deuteranomaly", "6% $m, 0.4% $f"),
        ColorWithBlind(tritanomaly(color), "Tritanomaly", "0.01% $p"),
      ],
      "Dichromacy": [
        ColorWithBlind(protanopia(color), "Protanopia", "1% $m"),
        ColorWithBlind(deuteranopia(color), "Deuteranopia", "1% $m"),
        ColorWithBlind(tritanopia(color), "Tritanopia", "less than 1% $p"),
      ],
      "Monochromacy": [
        ColorWithBlind(achromatopsia(color), "Achromatopsia", "0.003% $p"),
        ColorWithBlind(achromatomaly(color), "Achromatomaly", "0.001% $p"),
      ],
    };
  }
}

class ColorWithBlind {
  ColorWithBlind(this.color, this.name, this.affects);

  final Color color;
  final String name;
  final String affects;
}

class _ColorBlindCard extends StatelessWidget {
  const _ColorBlindCard(this.blindColor, this.defaultColor);

  final Color defaultColor;
  final ColorWithBlind blindColor;

  @override
  Widget build(BuildContext context) {
    final contrastedColor = contrastingColor(blindColor.color);

    return MaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: blindColor.color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.20))),
      elevation: 0,
      onPressed: () {
        colorSelected(context, blindColor.color);
      },
      onLongPress: () {
        showSlidersDialog(context, blindColor.color);
      },
      child: Row(
        children: <Widget>[
          const SizedBox(width: 8),
          Text(
            blindColor.name[0],
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: defaultColor,
                  fontSize: 48,
                ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  blindColor.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 18,
                        color: contrastedColor,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "${blindColor.color.toHexStr()}  •  ${blindColor.affects}",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: contrastedColor.withOpacity(0.87)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
