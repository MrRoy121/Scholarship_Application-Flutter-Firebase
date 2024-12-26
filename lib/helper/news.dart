import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class News {
  List<ArticleModel> allnews = [];

  Future<void> getNews() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference newsCollection = firestore.collection('news');

    Query query = newsCollection;

    try {
      QuerySnapshot querySnapshot = await query.get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['imageUrl'] != "" && data['content'] != "" && data['read_more_url'] != null) {
          List<String> types = List<String>.from(data['type']);
          List<String> country = List<String>.from(data['country']);
          ArticleModel articleModel = ArticleModel(
            lastApplyDate: data['lastApplyDate'].toDate(),
            publishedDate: data['publishedDate'].toDate(),
            country: country,
            type: types,applyURL: data['apply_url'],
            image: data['img_url'].toString(),
            content: data['content'].toString(),
            fullArticle: data['read_more_url'].toString(),
            title: data['title'].toString(),
          );
          allnews.add(articleModel);
        }
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  List<ArticleModel> filterNewsByCountryAndType(String countryFilter, String typeFilter) {
    List<ArticleModel> filteredByCountry = allnews;
    print("COuntry - $countryFilter, TypeFilter - $typeFilter");
    if (countryFilter.isNotEmpty) {
      filteredByCountry = filteredByCountry.where((article) => article.country.contains(countryFilter)).toList();
    }

    if (typeFilter.isNotEmpty) {
      filteredByCountry = filteredByCountry.where((article) => article.type.contains(typeFilter)).toList();
    }

    return filteredByCountry;
  }
}