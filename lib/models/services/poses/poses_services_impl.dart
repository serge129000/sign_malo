import 'package:google_mlkit_commons/src/input_image.dart';
import 'package:google_mlkit_pose_detection/src/pose_detector.dart';
import 'package:signe_malo/models/services/poses/poses_services.dart';

class PosesServicesImpl implements PosesServices {
  @override
  Future<List<Pose>> extractPoseFromImage({required InputImage image}) async {
    PoseDetector poseDetectorI = PoseDetector(options: PoseDetectorOptions());
    return await poseDetectorI.processImage(image);
  }

  @override
  List<Map<String, dynamic>> necessaryPosesToJson(
      {required List<List<Pose>> poses}) {
    try {
      List<Map<String, dynamic>> jsonToEncode = [];
      for (var pose in poses) {
        for (var element in pose) {
          for (var poseLandemark in element.landmarks.entries) {
            if (PosesServicesImpl.includedTypes.contains(poseLandemark.key)) {
              jsonToEncode.add({
                "type": poseLandemark.key.name,
                "x": poseLandemark.value.x,
                "y": poseLandemark.value.y,
                "z": poseLandemark.value.z  
              });
            }
          }
        }
      }
      return jsonToEncode;
    } catch (e) {
      return [];
    }
  }

  static List<PoseLandmarkType> includedTypes = [
    PoseLandmarkType.nose,
    PoseLandmarkType.leftEyeInner,
    PoseLandmarkType.leftEye,
    PoseLandmarkType.leftEyeOuter,
    PoseLandmarkType.rightEyeInner,
    PoseLandmarkType.rightEye,
    PoseLandmarkType.rightEyeOuter,
    PoseLandmarkType.leftEar,
    PoseLandmarkType.rightEar,
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.leftElbow,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.leftWrist,
    PoseLandmarkType.rightWrist,
    PoseLandmarkType.leftThumb,
    PoseLandmarkType.leftIndex,
    PoseLandmarkType.leftPinky,
    PoseLandmarkType.rightThumb,
    PoseLandmarkType.rightIndex,
    PoseLandmarkType.rightPinky
  ];
}
