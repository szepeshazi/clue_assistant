import 'package:clue/tile_widget.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class CharacterWidget extends StatefulWidget {
  const CharacterWidget({
    super.key,
    required this.image,
    required this.characterName,
  });

  final ui.Image image;
  final String characterName;

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();

  static const topLeft = Offset(39, 27);
  static const cardSize = Size(176, 286);
  static const gap = Size(16, 22);
}

class _CharacterWidgetState extends State<CharacterWidget>
    with SingleTickerProviderStateMixin {
  bool tapped = false;
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    controller.addListener(() {
      if (controller.isCompleted) {
        controller.reverse();
        setState(() {
          tapped = !tapped;
        });
      }
    });
  }

  final cardIndex = Offset(
    math.Random().nextInt(3).toDouble(),
    math.Random().nextInt(2).toDouble(),
  );

  @override
  Widget build(BuildContext context) {
    final left = CharacterWidget.topLeft.dx +
        cardIndex.dx *
            (CharacterWidget.cardSize.width + CharacterWidget.gap.width);
    final top = CharacterWidget.topLeft.dy +
        cardIndex.dy *
            (CharacterWidget.cardSize.height + CharacterWidget.gap.height);

    final rect = Rect.fromLTWH(-left, -top, CharacterWidget.cardSize.width,
        CharacterWidget.cardSize.height);
    return SizedBox(
      width: CharacterWidget.cardSize.width,
      height: CharacterWidget.cardSize.width,
      child: GestureDetector(
        onTap: () {
          if (controller.isDismissed) {
            controller.forward();
          }
        },
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: 0.97).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.bounceInOut,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CardWidget(
                image: widget.image,
                rect: rect,
              ),
              if (tapped)
                const Positioned(
                  top: -16,
                  right: -16,
                  child: Icon(
                    Icons.star,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
