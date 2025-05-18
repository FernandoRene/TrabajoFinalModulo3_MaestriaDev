import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  final double width;
  final double height;
  final Color overlayColor;
  final Color scanAreaColor;

  const CameraOverlay({
    super.key,
    this.width = 300.0,
    this.height = 200.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.scanAreaColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            overlayColor,
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
                child: const SizedBox.expand(),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: scanAreaColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Agregar un borde al área de escaneo
        Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}