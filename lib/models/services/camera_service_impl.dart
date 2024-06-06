import 'package:camera/camera.dart';
import 'package:google_mlkit_commons/src/input_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signe_malo/models/services/camera_services.dart';

class CameraServiceImpl implements CameraServices {
  @override
  Future<List<CameraDescription>> getAllCameras() => availableCameras();

  @override
  Future<bool> setCameraPermissions() async {
    if (!await Permission.camera.isGranted) {
      await Permission.camera.request();
    }
    return await Permission.camera.isGranted;
  }

  @override
  InputImage getImageFromCameraImage({required CameraImage cameraImage}) {
    // TODO: implement getImageFromCameraImage
    throw UnimplementedError();
  }
}
