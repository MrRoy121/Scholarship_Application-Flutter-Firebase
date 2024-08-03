import 'package:flutter/material.dart';

class TypesMode {
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final bool showNested;
  final List<NestedTypesMode> nestedTypes;

  TypesMode({
    required this.name,
    required this.icon,
    required this.showNested,
    required this.backgroundColor,
    required this.nestedTypes,
  });
}

class NestedTypesMode {
  final String name;
  final IconData icon;
  final Color backgroundColor;

  NestedTypesMode({
    required this.name,
    required this.icon,
    required this.backgroundColor,
  });
}
