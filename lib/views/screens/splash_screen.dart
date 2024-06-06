import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signe_malo/view_model/camera.view_model.dart';
import 'package:signe_malo/views/screens/camera_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late CameraViewModel cameraViewModel;
  @override
  void initState() {
    cameraViewModel = context.read<CameraViewModel>();
    Future.delayed(const Duration(seconds: 1), () {
      cameraViewModel.setPermission().then((v) {
        cameraViewModel.setCameras().then((v){
          Navigator.push(
          context, MaterialPageRoute(builder: (context) => CameraView()));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
