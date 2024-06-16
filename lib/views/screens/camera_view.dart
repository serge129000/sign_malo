import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:provider/provider.dart';
import 'package:signe_malo/models/controller/poses_controller.dart';
import 'package:signe_malo/utils/utils.dart';
import 'package:signe_malo/view_model/ai.view_model.dart';
import 'package:signe_malo/view_model/camera.view_model.dart';
import 'package:signe_malo/view_model/poses.view_model.dart';
import 'package:signe_malo/views/widgets/no_poses.dart';

import 'result_screen.dart';

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
  late AiViewModel aiViewModel;
  Duration startDuration = Duration.zero;
  bool showNoPoses = false;
  @override
  void initState() {
    super.initState();
    cameraViewModel = context.read<CameraViewModel>();
    posesViewModel = context.read<PosesViewModel>();
    aiViewModel = context.read<AiViewModel>();
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
    aiViewModel.addListener(aiListener);
  }

  @override
  void dispose() {
    controller.removeListener(cameraListener);
    controller.dispose();
    posesViewModel.removeListener(posesListener);
    aiViewModel.removeListener(aiListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    "Quitter Signe Malo?",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    Text(
                      "Oui",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Non",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 12,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ));
      },
      child: Scaffold(
        body: Consumer2<CameraViewModel, PosesViewModel>(
            builder: (context, cameraViewModel, posesViewModel, widgets) {
          return Column(
            children: [
              SafeArea(
                  child: Stack(
                children: [
                  CameraPreview(controller),
                  if (showNoPoses)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AspectRatio(
                          aspectRatio: controller.value.isInitialized
                              ? controller.value.aspectRatio
                              : 20,
                          child: const Center(child: NoPoses())),
                    )
                ],
              )),
              Expanded(
                  child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (!cameraViewModel.isRecording) {
                          await controller.startImageStream(
                            (image) async {
                              final inputImage =
                                  cameraViewModel.getInputImageFromCamera(
                                      cameraImage: image,
                                      cam: controller.description,
                                      currentOrientation:
                                          DeviceOrientation.portraitUp);
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
                          if (posesViewModel.treatmentPoses.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                        "Aucune pose detecte ou erreur de traitement de la pause Ressayer",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        Text(
                                          "Ok",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.lightBlue,
                                                  fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ));
                          } else {
                            aiViewModel.getResponse(
                                json: PosesController.necessaryPosesToJson(
                                    poses: posesViewModel.treatmentPoses));
                          }
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
                          !cameraViewModel.isRecording
                              ? "Enregister"
                              : "Arreter",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                      ),
                    ),
                  ],
                ),
              ))
              //Expanded(child: child)
            ],
          );
        }),
      ),
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
    if (posesViewModel.treatmentPoses.isEmpty && cameraViewModel.isRecording) {
      setState(() {
        showNoPoses = true;
      });
    } else {
      setState(() {
        showNoPoses = false;
      });
    }
  }

  void aiListener() {
    final status = aiViewModel.gettingResponseStatus;
    if (status == Status.loading) {
      showDialog(
          context: context,
          builder: (context) => CupertinoActivityIndicator(color: kWhiteColor));
    }
    if (status == Status.error) {
      kPopPage(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            posesViewModel.err,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 12),
          )));
      posesViewModel.reinitPoses();
    }
    if (status == Status.loaded && aiViewModel.aiExceptionValue.isEmpty) {
      kPopPage(context);
      posesViewModel.reinitPoses();
      kPushToPage(context, page: const ResultScreen());
    }
    /* if (status == Status.loaded && aiViewModel.aiExceptionValue.isNotEmpty) {
      //String data = aiViewModel.aiExceptionValue;
      kPopPage(context);
      posesViewModel.reinitPoses();
      kPushToPage(context, page: const ResultScreen());
    } */
  }
}
