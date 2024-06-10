import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:signe_malo/models/services/camera/camera_service_impl.dart';

class CamController {
  static Future<bool> setCameraPermission() =>
      CameraServiceImpl().setCameraPermissions();
  static Future<List<CameraDescription>> getCameraList() =>
      CameraServiceImpl().getAllCameras();
  static InputImage? getImageFromCameraImage(
          {required CameraImage cameraImage,
          required CameraDescription cam,
          required DeviceOrientation currentOrientation}) =>
      CameraServiceImpl().getImageFromCameraImage(
          cameraImage: cameraImage,
          cam: cam,
          currentOrientation: currentOrientation);
}
