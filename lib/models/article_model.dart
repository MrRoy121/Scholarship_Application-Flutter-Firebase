class ArticleModel {
  String title;
  List<String> country;
  String image;
  String content;
  List<String> type;
  DateTime publishedDate;
  DateTime lastApplyDate;
  String fullArticle;
  String applyURL;

  ArticleModel(
      {required this.content,
      required this.fullArticle,
      required this.country,
      required this.image,
      required this.type,
      required this.lastApplyDate,required this.applyURL,
      required this.publishedDate,
      required this.title});
}

List<String> Contries = [
  "Germany", //0
  "United Kingdom", //1
  "France", //2
  "Italy", //3
  "Finland", //4
  "Europe Others", //5
  "Malaysia", //6
  "Turkey", //7
  "Japan", //8
  "Asia Others", //9
  "Saudi Arab", //10
  "UAE", //11
  "Qatar", //12
  "Gulf Others", //13
  "China", //14
  "USA", //15
  "Australia" //16
];


List<String> typess = [
  "With Ielts",
  "Without Ielts",
  "Bachelor's Scholarship",
  "Master's Scholarship",
  "PHD Scholarship",
];
