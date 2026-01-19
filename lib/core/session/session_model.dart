class SessionUser {
  final String uid;
  final String? displayName;
  final String? email;

  const SessionUser({
    required this.uid,
    this.displayName,
    this.email,
  });
}