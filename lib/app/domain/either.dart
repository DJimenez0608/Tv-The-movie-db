class Either<Left, Right> {
  Either._(this._left, this._right, this.isleft);

  factory Either.left(Left failure) {
    return Either._(failure, null, true);
  }
  factory Either.right(Right value) {
    return Either._(null, value, false);
  }
  final Left? _left;
  final Right? _right;
  final bool isleft;

  T when<T>(
    T Function(Left) left,
    T Function(Right) right,
  ) {
    if (isleft) {
      return left(_left as Left);
    } else {
      return right(_right as Right);
    }
  }
}
