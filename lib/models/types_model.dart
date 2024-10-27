import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TypesMode {
  final String name;
  final String asset;
  final List<NestedTypesMode> nestedTypes;

  TypesMode({
    required this.name,
    required this.asset,
    required this.nestedTypes,
  });
}

class NestedTypesMode {
  final String name;
  final String asset;

  NestedTypesMode({
    required this.name,
    required this.asset,
  });
}


List<TypesMode> typesList = [
  TypesMode(
    name: 'Fully Funded European Scholarship',
    asset: "assets/i1.jpeg",
    nestedTypes: [
      NestedTypesMode(
        name: 'Fully Funded Germany Scholarships',
        asset: "assets/i11.jpeg",
      ),
      NestedTypesMode(
        name: 'Fully Funded United Kingdom Scholarships',
        asset: "assets/i12.jpeg",
      ),
      NestedTypesMode(
        name: 'Fully Funded France Scholarships',
        asset: "assets/i13.jpeg",
      ),
      NestedTypesMode(
        name: 'Fully Funded Italy Scholarships',
        asset: "assets/i14.jpeg",
      ),
      NestedTypesMode(
        name: 'Fully Funded Finland Scholarships',
        asset: "assets/i15.jpeg",
      ),
      NestedTypesMode(
        name: "Other's European Countries Scholarships",
        asset: "assets/i16.jpeg",
      ),
    ],
  ),
  TypesMode(
    name: 'All Fully Funded Asian Countries Scholarship',
    asset: "assets/i2.jpeg",
    nestedTypes: [
      NestedTypesMode(
        name: 'Fully Funded Malaysian Scholarships',
        asset: "assets/i21.jpeg",  ),
      NestedTypesMode(
        name: 'Fully Funded Turkey Scholarships',
        asset: "assets/i22.jpeg",   ),
      NestedTypesMode(
        name: 'Fully Funded Japan Scholarships',
        asset: "assets/i23.jpeg",   ),
      NestedTypesMode(
        name: "All other's Asian Countries Scholarships",
        asset: "assets/i24.jpeg", ),
    ],
  ),
  TypesMode(
    name: 'All Fully Funded Gulf countries Scholarships',
    asset: "assets/i3.jpeg",
    nestedTypes: [
      NestedTypesMode(
        name: 'Fully Funded Saudi Arabia Scholarships',
        asset: "assets/i31.jpeg",
      ),
      NestedTypesMode(
        name: 'Fully Funded UAE Scholarships',
        asset: "assets/i32.jpeg",
      ),
      NestedTypesMode(
        name: 'Fully Funded Qatar Scholarships',
        asset: "assets/i33.jpeg",
      ),
      NestedTypesMode(
        name: "All other's Gulf Countries Scholarships",
        asset: "assets/i34.jpeg",
      ),
    ],
  ),
  TypesMode(
      name: 'Fully Funded China Scholarships',    asset: "assets/i4.jpeg",

      nestedTypes: []),
  TypesMode(
      name: 'Fully Funded USA Scholarships',    asset: "assets/i5.jpeg",
      nestedTypes: []),
  TypesMode(
      name: 'Fully Funded Australia Scholarships',    asset: "assets/i6.jpeg",
       nestedTypes: []),
  TypesMode(
      name: 'Avail Our Services',    asset: "assets/i7.jpeg",
      nestedTypes: []),
];