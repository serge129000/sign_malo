import 'package:flutter/material.dart';

Color kBlackColor = const Color(0xff111111);
Color kWhiteColor = Colors.white;
Color kSecocondBlack = const Color(0xff454545);
Size kSize(_) => MediaQuery.of(_).size;
enum Status {
  initial,
  loading,
  loaded,
  error
}