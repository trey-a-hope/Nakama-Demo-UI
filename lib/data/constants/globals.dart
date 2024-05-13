/// Global variables.
class Globals {
  Globals._();

  /// One hour from now duration; used for token expiration.
  static final inOneHour = DateTime.now().add(
    const Duration(
      hours: 1,
    ),
  );
}
