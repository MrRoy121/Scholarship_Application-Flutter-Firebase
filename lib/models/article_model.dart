class ArticleModel {
  String title;
  String country;
  String image;
  String content;
  List<String> type;
  DateTime publishedDate;
  DateTime lastApplyDate;
  String fullArticle;

  ArticleModel(
      {required this.content,
      required this.fullArticle,
      required this.country,
      required this.image,
      required this.type,
      required this.lastApplyDate,
      required this.publishedDate,
      required this.title});
}
