import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/src/input_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signe_malo/models/services/camera/camera_services.dart';

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

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
  @override
  InputImage? getImageFromCameraImage({
  required CameraImage cameraImage,
  required CameraDescription cam,
  required DeviceOrientation currentOrientation,
}) {
  final sensorOrientation = cam.sensorOrientation;
  InputImageRotation? rotation;

  if (Platform.isIOS) {
    rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
  } else if (Platform.isAndroid) {
    var rotationCompensation = _orientations[currentOrientation];
    if (rotationCompensation == null) return null;

    if (cam.lensDirection == CameraLensDirection.front) {
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      rotationCompensation =
          (sensorOrientation - rotationCompensation + 360) % 360;
    }

    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
  }

  debugPrint("cameraImage.planes.length: ${cameraImage.planes.length}");
  debugPrint("cameraImage.width: ${cameraImage.width}");
  debugPrint("cameraImage.height: ${cameraImage.height}");

  if (rotation == null) {
    debugPrint("Rotation is null");
    return null;
  }

  final format = InputImageFormatValue.fromRawValue(cameraImage.format.raw);
  if (format == null ||
      (Platform.isIOS && format != InputImageFormat.bgra8888)) {
    debugPrint("Invalid format: $format");
    return null;
  }

  // Accepter YUV_420_888 sur Android
  if (Platform.isAndroid && format != InputImageFormat.nv21 && format != InputImageFormat.yuv_420_888) {
    debugPrint("Invalid format: $format");
    return null;
  }

  // Conversion optionnelle de YUV_420_888 à NV21 si nécessaire
  Uint8List bytes;
  if (format == InputImageFormat.yuv_420_888) {
    bytes = _convertYUV420ToNV21(cameraImage);
  } else {
    bytes = cameraImage.planes[0].bytes;
  }

  final plane = cameraImage.planes[0];
  return InputImage.fromBytes(
    bytes: bytes,
    metadata: InputImageMetadata(
      size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: plane.bytesPerRow,
    ),
  );
}

// Fonction pour convertir YUV_420_888 à NV21
Uint8List _convertYUV420ToNV21(CameraImage cameraImage) {
  final width = cameraImage.width;
  final height = cameraImage.height;
  final yPlane = cameraImage.planes[0].bytes;
  final uPlane = cameraImage.planes[1].bytes;
  final vPlane = cameraImage.planes[2].bytes;

  final uvRowStride = cameraImage.planes[1].bytesPerRow;
  final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

  final nv21Bytes = Uint8List(width * height + 2 * (width / 2 * height / 2).toInt());

  int yIndex = 0;
  int uvIndex = width * height;

  // Copy the Y plane
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      nv21Bytes[yIndex++] = yPlane[y * width + x];
    }
  }

  // Interleave the U and V planes
  for (int y = 0; y < height / 2; y++) {
    for (int x = 0; x < width / 2; x++) {
      nv21Bytes[uvIndex++] = vPlane[y * uvRowStride + x * uvPixelStride];
      nv21Bytes[uvIndex++] = uPlane[y * uvRowStride + x * uvPixelStride];
    }
  }

  return nv21Bytes;
}



}
