import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/models/types_model.dart';

class NestedcategoryScreen extends StatefulWidget {
  NestedcategoryScreen({required this.type});
  TypesMode type;

  @override
  State<NestedcategoryScreen> createState() => _NestedcategoryScreenState();
}

class _NestedcategoryScreenState extends State<NestedcategoryScreen> {

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
          widget.type.name,
          style: TextStyle(color: Color(0xffFCAF38), fontSize: 16),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.type.nestedTypes.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final nestedType = widget.type.nestedTypes[index];
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
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  tileColor: randomColor.withOpacity(0.1),
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
