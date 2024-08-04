import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TypesMode {
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final List<NestedTypesMode> nestedTypes;

  TypesMode({
    required this.name,
    required this.icon,
    required this.backgroundColor,
    required this.nestedTypes,
  });
}

class NestedTypesMode {
  final String name;
  final IconData icon;

  NestedTypesMode({
    required this.name,
    required this.icon,
  });
}


List<TypesMode> typesList = [
  TypesMode(
    name: 'Fully Funded European Scholarship',
    icon: FontAwesomeIcons.earthEurope,
    backgroundColor: Colors.blue,
    nestedTypes: [
      NestedTypesMode(
        name: 'Fully Funded Germany Scholarships',
        icon: FontAwesomeIcons.schoolFlag,
      ),
      NestedTypesMode(
        name: 'Fully Funded United Kingdom Scholarships',
        icon: FontAwesomeIcons.buildingFlag,
      ),
      NestedTypesMode(
        name: 'Fully Funded France Scholarships',
        icon: FontAwesomeIcons.landmarkFlag,
      ),
      NestedTypesMode(
        name: 'Fully Funded Italy Scholarships',
        icon: FontAwesomeIcons.flagCheckered,
      ),
      NestedTypesMode(
        name: 'Fully Funded Finland Scholarships',
        icon: FontAwesomeIcons.houseMedicalFlag,
      ),
      NestedTypesMode(
        name: "Other's European Countries Scholarships",
        icon: FontAwesomeIcons.flag,
      ),
    ],
  ),
  TypesMode(
    name: 'All Fully Funded Asian Countries Scholarship',
    icon: FontAwesomeIcons.earthAsia,
    backgroundColor: Colors.green,
    nestedTypes: [
      NestedTypesMode(
        name: 'Fully Funded Malaysian Scholarships',
        icon: FontAwesomeIcons.flagCheckered,
      ),
      NestedTypesMode(
        name: 'Fully Funded Turkey Scholarships',
        icon: FontAwesomeIcons.buildingFlag,
      ),
      NestedTypesMode(
        name: 'Fully Funded Japan Scholarships',
        icon: FontAwesomeIcons.landmarkFlag,
      ),
      NestedTypesMode(
        name: "All other's Asian Countries Scholarships",
        icon: FontAwesomeIcons.flag,
      ),
    ],
  ),
  TypesMode(
    name: 'All Fully Funded Gulf countries Scholarships',
    icon: FontAwesomeIcons.earthAfrica,
    backgroundColor: Colors.orange,
    nestedTypes: [
      NestedTypesMode(
        name: 'Fully Funded Saudi Arabia Scholarships',
        icon: FontAwesomeIcons.houseFlag,
      ),
      NestedTypesMode(
        name: 'Fully Funded UAE Scholarships',
        icon: FontAwesomeIcons.buildingFlag,
      ),
      NestedTypesMode(
        name: 'Fully Funded Qatar Scholarships',
        icon: FontAwesomeIcons.landmarkFlag,
      ),
      NestedTypesMode(
        name: "All other's Gulf Countries Scholarships",
        icon: FontAwesomeIcons.flag,
      ),
    ],
  ),
  TypesMode(
      name: 'Fully Funded China Scholarships',
      icon: FontAwesomeIcons.yenSign,
      backgroundColor: Colors.cyan,
      nestedTypes: []),
  TypesMode(
      name: 'Fully Funded USA Scholarships',
      icon: FontAwesomeIcons.earthAmericas,
      backgroundColor: Colors.brown,
      nestedTypes: []),
  TypesMode(
      name: 'Fully Funded Australia Scholarships',
      icon: FontAwesomeIcons.flagUsa,
      backgroundColor: Colors.red,
      nestedTypes: []),
  TypesMode(
      name: 'Avail Our Services',
      icon: FontAwesomeIcons.servicestack,
      backgroundColor: Colors.deepPurple,
      nestedTypes: []),
];