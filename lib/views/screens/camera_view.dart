import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:provider/provider.dart';
import 'package:signe_malo/models/controller/camera_controller.dart';
import 'package:signe_malo/utils/utils.dart';
import 'package:signe_malo/view_model/camera.view_model.dart';
import 'package:signe_malo/view_model/poses.view_model.dart';

class CameraView extends StatefulWidget {
  final Function(List<Pose> poses)? onSingleImageTreated;
  const CameraView({super.key, this.onSingleImageTreated});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController controller;
  late CameraViewModel cameraViewModel;
  late PosesViewModel posesViewModel;
  Duration startDuration = Duration.zero;
  @override
  void initState() {
    super.initState();
    cameraViewModel = context.read<CameraViewModel>();
    posesViewModel = context.read<PosesViewModel>();
    controller = CameraController(
        cameraViewModel.allCamera
            .where((c) => c.lensDirection == CameraLensDirection.back)
            .first,
        ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {});
    controller.addListener(cameraListener);
    posesViewModel.addListener(posesListener);
  }

  @override
  void dispose() {
    controller.removeListener(cameraListener);
    controller.dispose();
    posesViewModel.removeListener(posesListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<CameraViewModel, PosesViewModel>(
          builder: (context, cameraViewModel, posesViewModel, widgets) {
        return Column(
          children: [
            SafeArea(child: CameraPreview(controller)),
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (!cameraViewModel.isRecording) {
                        await controller.startImageStream(
                          /* onAvailable:  */(image) async {
                            final inputImage =
                                cameraViewModel.getInputImageFromCamera(
                                    cameraImage: image,
                                    cam: controller.description,
                                    currentOrientation:
                                        DeviceOrientation.portraitUp);
                            print("inputImage: $inputImage");
                            if (inputImage == null) {
                              return;
                            } else {
                              await posesViewModel.processImage(
                                  image: inputImage);
                            }
                          },
                        );
                      } else {
                        controller.stopImageStream();
                      }
                    },
                    child: Container(
                      height: kSize(context).height / 7,
                      decoration: BoxDecoration(
                          color: kBlackColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2,
                              color: cameraViewModel.isRecording
                                  ? Colors.red
                                  : kWhiteColor)),
                      child: Center(
                          child: Text(
                        !cameraViewModel.isRecording ? "Enregister" : "Arreter",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
                    ),
                  ),
                  /* Positioned(child: Container(
                    child: Text('${}'),
                  )) */
                ],
              ),
            ))
            //Expanded(child: child)
          ],
        );
      }),
    );
  }

  void cameraListener() {
    cameraViewModel.setRecordingStatus(controller.value.isStreamingImages);
    if (controller.value.isRecordingVideo) {
      setState(() {
        startDuration + const Duration(seconds: 1);
      });
    }
  }

  void posesListener() {
    print(posesViewModel.treatmentPoses.first.first.landmarks);
  }
}
