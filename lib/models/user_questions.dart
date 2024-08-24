
class UserQuestion {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String question;
  int likes;
  bool likedByUser;

  UserQuestion({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.question,
    this.likes = 0,
    this.likedByUser = false,
  });
}
