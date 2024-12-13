class CardModel {
  final String svgPath;
  bool isFlipped;
  bool isMatched;

  CardModel({
    required this.svgPath,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardModel copyWith({
    String? svgPath,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardModel(
      svgPath: svgPath ?? this.svgPath,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
