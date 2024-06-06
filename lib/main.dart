import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:signe_malo/utils/utils.dart';
import 'package:signe_malo/view_model/camera.view_model.dart';

import 'views/screens/splash_screen.dart';

void main(List<String> args) {
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CameraViewModel())],
      child: MaterialApp(
        title: "Sign Malo",
        home: const SplashScreen(),
        theme: ThemeData(
          textTheme: TextTheme(
            bodyLarge: GoogleFonts.montserratAlternates(color: kWhiteColor, fontSize: 18)
          ),
          scaffoldBackgroundColor: kBlackColor
        ),
      ),
    );
  }
}
