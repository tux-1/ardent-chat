class Contact {
  final String name;
  final String profileImageUrl;
  final String id;
  final bool isOnline;

  Contact({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    this.isOnline = false,
  });
}
