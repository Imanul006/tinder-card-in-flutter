import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_card/card_provider.dart';

class KiuqiCard extends StatefulWidget {
  final String urlImage;
  final bool isFront;
  const KiuqiCard({Key? key, required this.urlImage, required this.isFront}) : super(key: key);

  @override
  State<KiuqiCard> createState() => _KiuqiCardState();
}

class _KiuqiCardState extends State<KiuqiCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.isFront? buildFrontCard() : buildCard(),
    );
  }

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;

          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotatedMatrix
              ..translate(position.dx, position.dy),
            child: buildCard(),
          );
        }), 
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
        },
      );

  Widget buildCard() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.urlImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
