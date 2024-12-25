import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:news_app/provider/theme_provider.dart';
import 'package:news_app/screens/All_Posting_Screen.dart';
import 'package:news_app/screens/login.screen.dart';
import 'package:news_app/screens/posting_screen.dart';
import 'package:news_app/screens/questionList.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import 'package:url_launcher/url_launcher.dart';

import '../components/types_list.dart';
import '../models/types_model.dart';
import 'FacebookMockUpScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<String> items = [
  "Posts",
  "All",
  "With Ielts",
  "Without Ielts",
  "Bachelor's Scholarship",
  "Master's Scholarship",
  "PHD Scholarship",
];

class _HomeScreenState extends State<HomeScreen> {
  bool _showConnected = false;

  IconData themeIcon = Icons.dark_mode;
  bool isLightTheme = false;
  Color baseColor = Colors.grey[300]!;
  Color highlightColor = Colors.grey[100]!;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) {
      checkConnectivity();
    });
    getTheme();
  }

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
      baseColor = isLightTheme ? Colors.grey[300]! : Color(0xff2c2c2c);
      highlightColor = isLightTheme ? Colors.grey[100]! : Color(0xff373737);
      themeIcon = isLightTheme ? Icons.dark_mode : Icons.light_mode;
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

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getBool('user') ?? false;
    if (user) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedScreen()));
    }else{
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,resizeToAvoidBottomInset: true,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45,
            margin: EdgeInsets.only(bottom: 5.0),
            padding: EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(width: 0.5, color: const Color(0xFF0023FF))),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF3333),
                  const Color(0xFFAD1E1E),
                  const Color(0xFF1E31AD),
                ],
              ),
            ),
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
                    child: Icon(
                      themeIcon,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    launchUrl(Uri.parse("https://www.linkedin.com/in/rafiq-ullah-b59051319?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"));
                  },
                  child: FaIcon(
                    FontAwesomeIcons.linkedin,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    launchUrl(Uri.parse("https://www.facebook.com/profile.php?id=61567379290663"));
                  },
                  child: FaIcon(
                    FontAwesomeIcons.facebook,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    launchUrl(Uri.parse("https://www.youtube.com/@8ballpoolreward"));
                  },
                  child: FaIcon(
                    FontAwesomeIcons.youtube,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    launchUrl(Uri.parse("https://www.tiktok.com/@prof_rafiq"));
                  },
                  child: FaIcon(
                    FontAwesomeIcons.tiktok,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    launchUrl(Uri.parse("https://worldstudyscholarships.blogspot.com/"));
                  },
                  child: FaIcon(
                    FontAwesomeIcons.weebly,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                // SizedBox(width: 20),
                // InkWell(
                //   onTap: () async {
                //     launchUrl(Uri.parse("https://www.youtube.com/@8ballpoolreward/videos"));
                //   },
                //   child: FaIcon(
                //     FontAwesomeIcons.youtube,
                //     color: Theme.of(context).scaffoldBackgroundColor,
                //   ),
                // ),
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
                    if(index == 0){
                      sharedPref();
                    }else
                    if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '',
                            typess: '',
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '',
                            typess: (index - 2).toString(),
                          ),
                        ),
                      );
                    }
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Categories',
              style: TextStyle(
                  color: Theme.of(context).textTheme.titleSmall?.color, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Expanded(
            child: TypesList(
              types: typesList,
            ),
          ),
        ],
      ),
    );
  }
}
