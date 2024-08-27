import 'dart:async';
import 'dart:ui' as ui;

import 'package:clue/character.dart';
import 'package:clue/tile_widget.dart';
import 'package:flutter/material.dart';

class MainPageWidget extends StatefulWidget {
  const MainPageWidget({super.key});

  @override
  State<MainPageWidget> createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
  int phase = 0;
  ui.Image? characterSprite;

  @override
  void initState() {
    super.initState();
    final imageFuture = loadUiImage('assets/images/cluedo_chars.jpg')
        .then((value) => characterSprite = value);
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        phase++;
      });
    });
    Timer(const Duration(seconds: 1), () {
      setState(() {
        phase++;
      });
    });
    Future.wait([
      Future.delayed(const Duration(milliseconds: 2500)),
      imageFuture,
    ]).then((_) {
      setState(() {
        phase++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = phase == 0
        ? Image.asset('assets/images/clue_pre.png')
        : AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset('assets/images/clue_pre.png'),
            ),
            secondChild: Image.asset('assets/images/clue_main.jpg'),
            duration: const Duration(seconds: 1),
            crossFadeState: phase == 1
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          );
    return Column(
      children: [
        const SizedBox(height: 160),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: child,
        ),
        if (phase == 3) ...[
          const MenuWidget(),
          const SizedBox(height: 32),
          SizedBox(
            height: 320,
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                print(notification.metrics.pixels);
                return false;
              },
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0 || index == 7) {
                    return const SizedBox(width: 120);
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16,
                    ),
                    child: CharacterWidget(
                      image: characterSprite!,
                      characterName: 'Mrs. White',
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: opacity,
      child: Column(
        children: [
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Play',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class NoCurve extends Curve {
  @override
  double transformInternal(double t) {
    return 1.0; // cap to 1.0 when t is above 0.5
  }
}
