import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:signe_malo/models/controller/poses_controller.dart';
import 'package:signe_malo/models/objects/exception.dart';
import 'package:signe_malo/utils/utils.dart';

class PosesViewModel with ChangeNotifier {
  List<List<Pose>> _treatmentPoses = [];
  List<List<Pose>> get treatmentPoses => _treatmentPoses;
  Status _status = Status.initial;
  Status get status => _status;
  String _err = "";
  String get err => _err;
  Future<void> processImage({required InputImage image}) async {
    _status = Status.loading;
    notifyListeners();
    try {
      List<Pose> poses =
          await PosesController.extractPoseFromImage(image: image);
      _treatmentPoses.add(poses);
      _status = Status.loaded;
      notifyListeners();
    } catch (e) {
      if (e is AiException) {
        _err = e.unexceptedValue!;
      } else {
        _err = e.toString();
      }
      _status = Status.error;
      notifyListeners();
    } finally {
      _status = Status.initial;
      notifyListeners();
    }
  }

  void reinitPoses() {
    _treatmentPoses = [];
    notifyListeners();
  }
}
