import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../components/news_tile.dart';
import '../components/shimmer_news_tile.dart';
import '../helper/news.dart';
import 'home_screen.dart';
import 'dart:ui' as ui;

class AllPostingScreen extends StatefulWidget {
  AllPostingScreen({required this.country, required this.typess});
  String country;
  String typess;
  @override
  State<AllPostingScreen> createState() => _AllPostingScreenState();
}

class _AllPostingScreenState extends State<AllPostingScreen> {
  bool _loading = true;
  Color baseColor = Colors.grey[300]!;
  Color highlightColor = Colors.grey[100]!;
  bool _articleExists = true;
  bool _showConnected = false;
  News newsClass = News();
  List articles = [];

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((event) {
      checkConnectivity();
    });
    _loading = true;
    getNews();
  }

  checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    showConnectivitySnackBar(result);
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    var isConnected = result != ConnectivityResult.none;
    if (!isConnected) {
      _showConnected = true;
      final snackBar = SnackBar(
          content: Text(
            "You are Offline",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (isConnected && _showConnected) {
      _showConnected = false;
      final snackBar = SnackBar(
          content: Text(
            "You are back Online",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      getNews();
    }
  }

  getNews() async {
    _loading = true;
    checkConnectivity();
    await newsClass.getNews();


    print("SSS SS Country - ${widget.country}, TypeFilter - ${widget.typess}");
    articles = newsClass.filterNewsByCountryAndType(widget.country, widget.typess);
    setState(() {
      if (articles.isEmpty) {
        _articleExists = false;
      } else {
        _articleExists = true;
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Container(margin: EdgeInsets.only(left: 10), child: Image.asset('assets/logo.png')),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'All Latest ',
              style: TextStyle(color: Color(0xff50A3A4)),
            ),
            Text(
              'Scholarships',
              style: TextStyle(color: Color(0xffFCAF38)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final text = items[index];
                final textPainter = TextPainter(
                  text: TextSpan(text: text, style: TextStyle(fontSize: 16)),
                  maxLines: 1,
                  textDirection: ui.TextDirection.ltr,
                )..layout(minWidth: 0, maxWidth: double.infinity);
                final textWidth = textPainter.size.width + 20;
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      articles = newsClass.filterNewsByCountryAndType(widget.country, '');
                    } else {
                      articles = newsClass.filterNewsByCountryAndType(widget.country, (index - 1).toString());
                    }
                    if (articles.isEmpty) {
                      _articleExists = false;
                    } else {
                      _articleExists = true;
                    }setState(() {

                    });
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                    child: Container(
                      width: textWidth,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Center(
                        child: Text(text),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _loading
              ? Expanded(
                  child: Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return ShimmerNewsTile();
                      },
                    ),
                  ),
                )
              : _articleExists
                  ? Expanded(
                      child: RefreshIndicator(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return NewsTile(
                              image: articles[index].image,
                              title: articles[index].title,
                              content: articles[index].content,
                              date: DateFormat.yMMMd().format(articles[index].publishedDate),
                              date1: DateFormat.yMMMd().format(articles[index].lastApplyDate),
                              fullArticle: articles[index].fullArticle,
                            );
                          },
                        ),
                        onRefresh: () => getNews(),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Scholarships available"),
                        ],
                      ),
                    )
        ],
      ),
    );
  }
}
