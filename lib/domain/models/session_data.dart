/// Data class to hold session data.
class SessionData {
  final String uid;
  final String username;
  final String email;
  final DateTime expiresAt;

  SessionData({
    required this.uid,
    required this.username,
    required this.email,
    required this.expiresAt,
  });
}
