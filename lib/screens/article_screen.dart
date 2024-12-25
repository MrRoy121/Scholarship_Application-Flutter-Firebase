import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:news_app/helper/menu_items.dart';
import 'package:news_app/models/article_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/custom.snackbar.dart';
import '../constants/colors.dart';

class ArticleScreen extends StatefulWidget {
  final ArticleModel article;
  ArticleScreen({required this.article});

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late WebViewController _controller;
  int position = 1;
  bool _showConnected = false;
  bool isLightTheme = true;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) {
      checkConnectivity();
    });

    if(widget.article.fullArticle != null && widget.article.fullArticle != ''){
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              setState(() {
                position = 1;
              });
            },
            onPageStarted: (String url) {
              setState(() {
                position = 1;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                position = 0;
              });
            },
          ),
        )..loadRequest(Uri.parse(widget.article.fullArticle));

    }
    getTheme();
  }

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    showConnectivitySnackBar(result.first);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasFullArticle =  widget.article.fullArticle.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: isLightTheme
            ? SystemUiOverlayStyle(statusBarColor: Colors.transparent)
            : SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            size: 30,
          ),
        ),
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
        actions: <Widget>[

          if(widget.article.fullArticle != null && widget.article.fullArticle != '') PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return MenuItems.choices.map((String choice) {
                return PopupMenuItem(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
            onSelected: choiceAction,
          )
        ],
      ),
      body:hasFullArticle ? _buildWebView() : _buildArticleDetails(),
    );
  }
  Widget _buildWebView() {
    return IndexedStack(
      index: position,
      children: [ WebViewWidget(controller: _controller,
      ),
        Container(
          child: Center(
            child: SpinKitCubeGrid(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleDetails() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Network Image
          CachedNetworkImage(
            imageUrl: widget.article.image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16.0),

          // Country Name
          Text(
            widget.article.country.map((index) {
              return Contries[int.parse(index)];
            }).join(', '),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),

          // Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Published: ${dateFormat.format(widget.article.publishedDate)}',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'Last Updated: ${dateFormat.format(widget.article.lastApplyDate)}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          // Article Description
          Text(
            widget.article.content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == MenuItems.Copy) {
      Clipboard.setData(ClipboardData(text: widget.article.fullArticle));

      SnackUtil.showSnackBar(
        context: context,
        text: "Link Copied",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.black54,
      );
    } else if (choice == MenuItems.Open_In_Browser) {
      launch(widget.article.fullArticle);
    } else if (choice == MenuItems.Share) {
      Share.share(widget.article.fullArticle);
    }
  }
}
