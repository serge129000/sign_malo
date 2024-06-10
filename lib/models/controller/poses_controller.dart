import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:signe_malo/models/services/poses/poses_services_impl.dart';

class PosesController {
  static Future<List<Pose>> extractPoseFromImage({required InputImage image}) =>
      PosesServicesImpl().extractPoseFromImage(image: image);
}
