class Contact {
  final String username;
  final String email;
  final String profileImageUrl;
  final String id;
  final bool isOnline;

  Contact({
    required this.id,
    required this.email,
    required this.username,
    required this.profileImageUrl,
    this.isOnline = false,
  });
}
