class UserRatingStarsModel {
  final bool starPressed;
  final int starPressedIndex;

  UserRatingStarsModel({this.starPressed = false, this.starPressedIndex = 0});

  UserRatingStarsModel copyWith({
    bool starPressed,
    int starPressedIndex,
  }) {
    return UserRatingStarsModel(
      starPressed: starPressed ?? this.starPressed,
      starPressedIndex: starPressedIndex ?? this.starPressedIndex,
    );
  }
}
