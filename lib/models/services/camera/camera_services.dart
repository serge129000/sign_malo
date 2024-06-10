import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class CameraServices {
  Future<List<CameraDescription>> getAllCameras();
  Future<bool> setCameraPermissions();
  InputImage? getImageFromCameraImage({required CameraImage cameraImage, required CameraDescription cam, required DeviceOrientation currentOrientation});
}
