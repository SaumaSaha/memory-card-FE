import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_card_front_end/utils/device.dart';
import '../models/card_model.dart';

class GameCard extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const GameCard({
    Key? key,
    required this.card,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double paddingValue = constraints.maxWidth < 160 ? 20 : 50;
            return card.isFlipped
                ? Padding(
                    padding: EdgeInsets.all(paddingValue),
                    child: SvgPicture.asset(
                      card.svgPath,
                      fit: BoxFit.contain,
                    ),
                  )
                : Container(color: Colors.blue);
          },
        ),
      ),
    );
  }
}
