import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:news_app/components/shimmer_news_tile.dart';
import 'package:news_app/provider/theme_provider.dart';
import 'package:news_app/components/news_tile.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/screens/posting_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transition/transition.dart';
import 'dart:ui' as ui;

import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List articles = [];
  bool _loading = true;
  bool _showConnected = false;
  bool _articleExists = true;
  List<String> items = [
    "All",
    "Bachelor's Scholarship",
    "Master's Scholarship",
    "PHD Scholarship",
    "With Ielts",
    "Without Ielts",
    'Posting'
  ];
  Icon themeIcon = Icon(Icons.dark_mode);
  bool isLightTheme = false;
  News newsClass = News();
  bool showInfoButtons = false;
  Color baseColor = Colors.grey[300]!;
  Color highlightColor = Colors.grey[100]!;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) {
      checkConnectivity();
    });
    _loading = true;
    getNews();
    getTheme();
  }

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
      baseColor = isLightTheme ? Colors.grey[300]! : Color(0xff2c2c2c);
      highlightColor = isLightTheme ? Colors.grey[100]! : Color(0xff373737);
      themeIcon = isLightTheme ? Icon(Icons.dark_mode) : Icon(Icons.light_mode);
    });
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
    articles = newsClass.filterNewsByType('');
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
    final themeProvider = Provider.of<ThemeProvider>(context);
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
              'Scholarship',
              style: TextStyle(color: Color(0xff50A3A4)),
            ),
            Text(
              'News',
              style: TextStyle(color: Color(0xffFCAF38)),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                showInfoButtons = !showInfoButtons;
              });
            },
            child: Container(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.info_outline),
              margin: !showInfoButtons ? EdgeInsets.only(right: 10) : EdgeInsets.zero,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (showInfoButtons)
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      themeProvider.toggleThemeData();
                      setState(() {
                        themeIcon = themeProvider.themeIcon();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      child: themeIcon,
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      launchUrl(Uri.parse("https://www.linkedin.com/in/rafiq-ullah-b59051319/"));
                    },
                    child: FaIcon(FontAwesomeIcons.linkedin),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      launchUrl(Uri.parse("https://web.facebook.com/abroadscholarships2024/"));
                    },
                    child: FaIcon(FontAwesomeIcons.facebook),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      launchUrl(Uri.parse("https://www.instagram.com/abroadscholarships2024/"));
                    },
                    child: FaIcon(FontAwesomeIcons.instagram),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      launchUrl(Uri.parse("https://www.youtube.com/@8ballpoolreward"));
                    },
                    child: FaIcon(FontAwesomeIcons.youtube),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      launchUrl(Uri.parse("https://chat.whatsapp.com/E0yxvNtklDHGwNy98NZj0B"));
                    },
                    child: FaIcon(FontAwesomeIcons.whatsapp),
                  ),
                ],
              ),
            ),
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
                    if (index == items.length - 1) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDetailsForm()));
                    } else if (index == 0) {
                      articles = newsClass.filterNewsByType('');
                    } else {
                      articles = newsClass.filterNewsByType((index - 1).toString());
                    }
                    if (articles.isEmpty) {
                      _articleExists = false;
                    } else {
                      _articleExists = true;
                    }
                    setState(() {});
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
                    ),
        ],
      ),
    );
  }
}
