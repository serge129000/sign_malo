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
kPushToPage(_, {required Widget page, bool? isFromBottom}) =>
    Navigator.push(_, _createRoute(nextPage: page, isFromBottom: isFromBottom));
kPopPage(_) => Navigator.pop(_);
//
Route _createRoute({required Widget nextPage, bool? isFromBottom}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = isFromBottom != null && isFromBottom? const Offset(0.0, 1.0): const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}