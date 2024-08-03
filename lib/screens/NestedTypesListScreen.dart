import 'package:flutter/material.dart';

import '../models/types_model.dart';


class NestedTypesListScreen extends StatelessWidget {
  final TypesMode type;

  NestedTypesListScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.name),
      ),
      body: ListView.builder(
        itemCount: type.nestedTypes.length,
        itemBuilder: (context, index) {
          final nestedType = type.nestedTypes[index];
          return ListTile(
            leading: Icon(nestedType.icon, color: nestedType.backgroundColor),
            title: Text(nestedType.name),
            tileColor: nestedType.backgroundColor.withOpacity(0.1),
            onTap: () {

            },
          );
        },
      ),
    );
  }
}