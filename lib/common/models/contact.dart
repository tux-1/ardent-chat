class Contact {
  final String username;
  final String profileImageUrl;
  final String id;
  final bool isOnline;

  Contact({
    required this.id,
    required this.username,
    required this.profileImageUrl,
    this.isOnline = false,
  });
}
