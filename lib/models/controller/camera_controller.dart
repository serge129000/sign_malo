import 'package:camera/camera.dart';
import 'package:signe_malo/models/services/camera_service_impl.dart';

class CamController {
  static Future<bool> setCameraPermission() =>
      CameraServiceImpl().setCameraPermissions();
  static Future<List<CameraDescription>> getCameraList() =>
      CameraServiceImpl().getAllCameras();
}
