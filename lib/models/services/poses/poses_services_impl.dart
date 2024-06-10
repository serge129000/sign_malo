import 'package:google_mlkit_commons/src/input_image.dart';
import 'package:google_mlkit_pose_detection/src/pose_detector.dart';
import 'package:signe_malo/models/services/poses/poses_services.dart';

class PosesServicesImpl implements PosesServices {
  @override
  Future<List<Pose>> extractPoseFromImage({required InputImage image}) async {
    PoseDetector poseDetectorI = PoseDetector(options: PoseDetectorOptions());
    return await poseDetectorI.processImage(image);
  }
}
