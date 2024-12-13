import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/card_model.dart';

class GameState {
  final List<CardModel> cards;
  final int flips;
  final int time;
  final bool isGameCompleted;

  GameState({
    required this.cards,
    this.flips = 0,
    this.time = 0,
    this.isGameCompleted = false,
  });

  GameState copyWith({
    List<CardModel>? cards,
    int? flips,
    int? time,
    bool? isGameCompleted,
  }) {
    return GameState(
      cards: cards ?? this.cards,
      flips: flips ?? this.flips,
      time: time ?? this.time,
      isGameCompleted: isGameCompleted ?? this.isGameCompleted,
    );
  }
}

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState(cards: []));

  void initGame() {
    List<String> svgPaths = [
      'assets/card_icons/diamond_purple.svg',
      'assets/card_icons/hexagon_blue.svg',
      'assets/card_icons/diamond_green.svg',
      'assets/card_icons/pentagon_red.svg',
      'assets/card_icons/triangle_sky.svg',
      'assets/card_icons/square_yellow.svg',
    ];

    List<CardModel> cards = [];
    for (var path in svgPaths) {
      cards.add(CardModel(svgPath: path));
      cards.add(CardModel(svgPath: path));
    }
    cards.shuffle();

    emit(GameState(cards: cards, flips: 0, time: 0, isGameCompleted: false));
  }

  void flipCard(int index) {
    if (state.cards[index].isMatched || state.cards[index].isFlipped) return;

    List<CardModel> updatedCards = List.from(state.cards);
    updatedCards[index] = CardModel(
      svgPath: updatedCards[index].svgPath,
      isFlipped: !updatedCards[index].isFlipped,
      isMatched: updatedCards[index].isMatched,
    );

    emit(GameState(
        cards: updatedCards, flips: state.flips + 1, time: state.time));

    checkForMatch();
    checkGameCompletion();
  }

  void checkForMatch() {
    List<int> flippedIndices = _getFlippedIndices();

    if (flippedIndices.length == 2) {
      if (_isMatch(flippedIndices)) {
        _updateMatchedCards(flippedIndices);
      } else {
        _flipCardsBack(flippedIndices);
      }
    }
  }

  List<int> _getFlippedIndices() {
    return state.cards
        .asMap()
        .entries
        .where((entry) => entry.value.isFlipped && !entry.value.isMatched)
        .map((entry) => entry.key)
        .toList();
  }

  bool _isMatch(List<int> indices) {
    return state.cards[indices[0]].svgPath == state.cards[indices[1]].svgPath;
  }

  void _updateMatchedCards(List<int> indices) {
    List<CardModel> updatedCards = List.from(state.cards);
    updatedCards[indices[0]] = updatedCards[indices[0]].copyWith(isMatched: true);
    updatedCards[indices[1]] = updatedCards[indices[1]].copyWith(isMatched: true);
    emit(state.copyWith(cards: updatedCards));
  }

  void _flipCardsBack(List<int> indices) {
    Future.delayed(const Duration(milliseconds: 500), () {
      List<CardModel> updatedCards = List.from(state.cards);
      updatedCards[indices[0]] = updatedCards[indices[0]].copyWith(isFlipped: false);
      updatedCards[indices[1]] = updatedCards[indices[1]].copyWith(isFlipped: false);
      emit(state.copyWith(cards: updatedCards));
    });
  }

  void checkGameCompletion() {
    bool allMatched = state.cards.every((card) => card.isMatched);
    if (allMatched) {
      emit(
        GameState(
          cards: state.cards,
          flips: state.flips,
          time: state.time,
          isGameCompleted: true,
        ),
      );
    }
  }

  void updateTime(int newTime) {
    emit(GameState(cards: state.cards, flips: state.flips, time: newTime));
  }

  void resetTime() {
    emit(GameState(
        cards: state.cards,
        flips: state.flips,
        time: 0,
        isGameCompleted: state.isGameCompleted));
  }

  void resetFlips() {
    emit(GameState(
        cards: state.cards,
        flips: 0,
        time: state.time,
        isGameCompleted: state.isGameCompleted));
  }
}
