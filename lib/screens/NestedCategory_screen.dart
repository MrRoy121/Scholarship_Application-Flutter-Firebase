import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/models/types_model.dart';

import 'All_Posting_Screen.dart';
import 'home_screen.dart';

class NestedcategoryScreen extends StatelessWidget {
  NestedcategoryScreen({required this.type});
  TypesMode type;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
        leading: Container(margin: EdgeInsets.only(left: 10), child: Image.asset('assets/logo.png')),
        title: Text(
          type.name,
          style: TextStyle(color: Color(0xffFCAF38), fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: type.nestedTypes.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final nestedType = type.nestedTypes[index];
          var borderRadius = BorderRadius.circular(5);
          final Color randomColor = Color.fromARGB(
            255,
            Random().nextInt(256),
            Random().nextInt(256),
            Random().nextInt(256),
          );
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  leading: Icon(nestedType.icon, color: randomColor),
                  title: Text(
                    nestedType.name,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  tileColor: randomColor.withOpacity(0.1),
                  onTap: () {
                    if (nestedType == typesList[0].nestedTypes[0]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '0',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[0].nestedTypes[1]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '1',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[0].nestedTypes[2]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '2',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[0].nestedTypes[3]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '3',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[0].nestedTypes[4]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '4',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[0].nestedTypes[5]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '5',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[1].nestedTypes[0]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '6',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[1].nestedTypes[1]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '7',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[1].nestedTypes[2]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '8',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[1].nestedTypes[3]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '9',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[2].nestedTypes[0]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '10',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[2].nestedTypes[1]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '11',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[2].nestedTypes[2]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '12',
                            typess: '',
                          ),
                        ),
                      );
                    }else if (nestedType == typesList[2].nestedTypes[3]) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPostingScreen(
                            country: '13',
                            typess: '',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
