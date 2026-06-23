class Experience {
  final String id;
  final String userName;
  final String userRole;
  final String content;
  final String timeAgo;
  final int likes;
  final int comments;
  final String? imageUrl;
  final bool isCritical;

  Experience({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.content,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    this.imageUrl,
    this.isCritical = false,
  });
}

class CommunitySummary {
  final double globalPrecision;

  CommunitySummary({required this.globalPrecision});
}
