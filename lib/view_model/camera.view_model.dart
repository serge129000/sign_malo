import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:signe_malo/models/controller/camera_controller.dart';

class CameraViewModel with ChangeNotifier {
  List<CameraDescription> _allCameras = [];
  List<CameraDescription> get allCamera => _allCameras;
  bool _isCamPermit = false;
  bool get isCamPermit => _isCamPermit;
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  Duration _currentDuration = Duration.zero;
  Duration get currentDuration => _currentDuration;
  Future<void> setPermission() async {
    _isCamPermit = await CamController.setCameraPermission();
    notifyListeners();
  }

  Future<void> setCameras() async {
    _allCameras = await CamController.getCameraList();
    notifyListeners();
  }

  void setRecordingStatus(bool status) {
    _isRecording = status;
    notifyListeners();
  }

  void setVideoDuration({required Duration duration}) {
    _currentDuration = duration;
    notifyListeners();
  }

  InputImage? getInputImageFromCamera(
          {required CameraImage cameraImage,
          required CameraDescription cam,
          required DeviceOrientation currentOrientation}) =>
      CamController.getImageFromCameraImage(
          cameraImage: cameraImage,
          cam: cam,
          currentOrientation: currentOrientation);
}
