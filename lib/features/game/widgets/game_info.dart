import 'package:flutter/material.dart';

class GameInfo extends StatelessWidget {
  final int time;
  final int flips;

  const GameInfo({
    Key? key,
    required this.time,
    required this.flips,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 20.0),
            child: Text(
              'Time: ${time}s',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
            child: Text(
              'Flips: $flips',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
