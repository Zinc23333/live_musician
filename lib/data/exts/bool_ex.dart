extension BoolEx on bool {
  T? ifTrue<T>(T v) => this ? v : null;
}
