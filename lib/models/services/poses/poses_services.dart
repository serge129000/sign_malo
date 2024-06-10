import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class PosesServices {
  Future<List<Pose>> extractPoseFromImage({required InputImage image});
}
