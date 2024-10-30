import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/models/types_model.dart';

import 'All_Posting_Screen.dart';
import 'home_screen.dart';

class NestedcategoryScreen extends StatelessWidget {
  NestedcategoryScreen({required this.type});
  TypesMode type;

  String? getCountryCode(List<TypesMode> typesList, NestedTypesMode nestedType) {
    for (int i = 0; i < typesList.length; i++) {
      for (int j = 0; j < typesList[i].nestedTypes.length; j++) {
        if (typesList[i].nestedTypes[j] == nestedType) {
          // Mapping based on the index as shown in your code
          return (i * 5 + j).toString(); // Calculate the country code as a string
        }
      }
    }
    return null; // Return null if no match is found
  }

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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          itemCount: type.nestedTypes.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            childAspectRatio: 2 / 1,
            crossAxisSpacing: 5,
          ),
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
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: InkWell(
                onTap: () {
                  String? country = getCountryCode(typesList, nestedType);
                  if (country != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllPostingScreen(
                          country: country,
                          typess: '',
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(nestedType.asset),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          nestedType.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
