import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class DebugTileProvider implements TileProvider {
  DebugTileProvider() {
    boxPaint.isAntiAlias = true;
    boxPaint.color = Colors.black38;
    boxPaint.strokeWidth = 1.0;
    boxPaint.style = PaintingStyle.stroke;
  }

  static const int BOX_EDGE = 128;
  static final Paint boxPaint = Paint();

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    canvas.drawRect(
        Rect.fromLTRB(0, 0, BOX_EDGE.toDouble(), BOX_EDGE.toDouble()), boxPaint);
    final ui.Picture picture = recorder.endRecording();
    final Uint8List byteData = await picture
        .toImage(BOX_EDGE, BOX_EDGE)
        .then((ui.Image image) =>
            image.toByteData(format: ui.ImageByteFormat.png))
        .then((ByteData? byteData) => byteData!.buffer.asUint8List());
    return Tile(BOX_EDGE, BOX_EDGE, byteData);
    
  }

}
