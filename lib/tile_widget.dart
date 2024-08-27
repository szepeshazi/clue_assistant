import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<ui.Image> loadUiImage(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final list = Uint8List.view(data.buffer);
  final completer = Completer<ui.Image>();
  ui.decodeImageFromList(list, completer.complete);
  return completer.future;
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.image,
    required this.rect,
  });

  final ui.Image image;
  final Rect rect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: ClipRect(
        child: CustomPaint(
          size: Size(rect.width, rect.height),
          painter: CardPainter(
            image: image,
            offset: Offset(rect.left, rect.top),
            size: Size(rect.width, rect.height),
          ),
        ),
      ),
    );
  }
}

class CardPainter extends CustomPainter {
  final ui.Image image;
  final Offset offset;
  final Size size;

  const CardPainter({
    super.repaint,
    required this.image,
    required this.offset,
    required this.size,
  });

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawImage(image, offset, Paint());
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldRepaint(CardPainter oldDelegate) {
    return image != oldDelegate.image ||
        offset.dx != oldDelegate.offset.dx ||
        offset.dy != oldDelegate.offset.dy;
  }
}
