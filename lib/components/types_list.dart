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
      child: ListView.builder(
        itemCount: types.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final type = types[index];
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  leading: Icon(type.icon, color: type.backgroundColor),
                  title: Text(
                    type.name,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  tileColor: type.backgroundColor.withOpacity(0.1),
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
                    }else if (index == 6) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InstructionScreen(
                          ),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
