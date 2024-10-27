import 'package:flutter/material.dart';

import '../models/types_model.dart';
import '../screens/All_Posting_Screen.dart';
import '../screens/Message_WhatsappScreen.dart';
import '../screens/NestedCategory_screen.dart';

class TypesList extends StatelessWidget {
  List<TypesMode> types;
  TypesList({required this.types});

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(5);
    return SingleChildScrollView(
      child: GridView.builder(
        itemCount: types.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          final type = types[index];
          return InkWell(
            onTap: () {
              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllPostingScreen(
                      country: '14',
                      typess: '',
                    ),
                  ),
                );
              } else if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllPostingScreen(
                      country: '15',
                      typess: '',
                    ),
                  ),
                );
              } else if (index == 6) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstructionScreen(),
                  ),
                );
              } else if (index == 5) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllPostingScreen(
                      country: '16',
                      typess: '',
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NestedcategoryScreen(type: type),
                  ),
                );
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(type.asset, fit: BoxFit.cover),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                      child: Text(
                        type.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
