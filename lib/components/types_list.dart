import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/types_model.dart';
import '../screens/NestedTypesListScreen.dart';

class TypesList extends StatelessWidget {
  final List<TypesMode> types;

  TypesList({required this.types});

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(5);
    return ListView.builder(
      itemCount: types.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final type = types[index];
        return Container(
          margin: EdgeInsets.all(10),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            leading: Icon(type.icon, color: type.backgroundColor),
            title: Text(type.name, style: TextStyle(fontWeight: FontWeight.w600),),
            tileColor: type.backgroundColor.withOpacity(0.1),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NestedTypesListScreen(type: type),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
