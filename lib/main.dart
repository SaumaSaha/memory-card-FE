import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/game_cubit.dart';
import 'widgets/game_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameCubit>(
          create: (context) => GameCubit()..initGame(),
        ),
      ],
      child: const MaterialApp(
        title: 'Memory Game',
        home: GameBoard(),
      ),
    );
  }
}