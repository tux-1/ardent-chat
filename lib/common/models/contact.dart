class Contact {
  final String name;
  final String profileImageUrl;
  final bool isOnline;

  Contact({
    required this.name,
    required this.profileImageUrl,
    this.isOnline = false,
  });
}
