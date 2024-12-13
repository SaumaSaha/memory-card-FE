import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_card_front_end/utils/device.dart';
import '../cubit/game_cubit.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late Timer _timer;
  int _timeElapsed = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });
      context.read<GameCubit>().updateTime(_timeElapsed);
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _timeElapsed = 0;
    });
    context.read<GameCubit>().resetTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory Game')),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          if (state.isGameCompleted) {
            _stopTimer();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Game Completed!'),
                  content: Text(
                      'You completed the game in ${state.flips} flips and ${state.time} seconds.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resetTimer();
                        context.read<GameCubit>().initGame();
                      },
                      child: const Text('Start New Game'),
                    ),
                  ],
                ),
              );
            });
          }

          double boardSize = Device.isMobile(context)
              ? MediaQuery.of(context).size.width * 0.8
              : MediaQuery.of(context).size.width * 0.5;
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: boardSize,
                    height: boardSize,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: state.cards.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () =>
                              context.read<GameCubit>().flipCard(index),
                          child: Card(
                            child: state.cards[index].isFlipped
                                ? Padding(
                                    padding: EdgeInsets.all(
                                        Device.isMobile(context)
                                            ? 10
                                            : 50),
                                    child: SvgPicture.asset(
                                      state.cards[index].svgPath,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Container(color: Colors.blue),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        bottom: 20.0,
                      ),
                      child: Text('Time: ${state.time}s'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                        bottom: 20.0,
                      ),
                      child: Text('Flips: ${state.flips}'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
