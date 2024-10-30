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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: GridView.builder(
          itemCount: types.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            childAspectRatio: 2 / 1,
            crossAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            final type = types[index];
            return Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: InkWell(
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(type.asset),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 3,
                      child: Container(
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
