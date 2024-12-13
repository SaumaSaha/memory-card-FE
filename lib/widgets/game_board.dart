import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_card_front_end/utils/device.dart';
import '../cubit/game_cubit.dart';
import 'game_card.dart';
import 'game_info.dart';

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
              ? Device.width(context) * 0.8
              : Device.width(context) * 0.5;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey.shade900, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
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
                          return GameCard(
                            card: state.cards[index],
                            onTap: () =>
                                context.read<GameCubit>().flipCard(index),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                GameInfo(time: state.time, flips: state.flips),
              ],
            ),
          );
        },
      ),
    );
  }
}
