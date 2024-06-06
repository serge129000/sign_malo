import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signe_malo/utils/utils.dart';
import 'package:signe_malo/view_model/camera.view_model.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController controller;
  late CameraViewModel cameraViewModel;
  Duration startDuration = Duration.zero;
  @override
  void initState() {
    super.initState();
    cameraViewModel = context.read<CameraViewModel>();
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
  }

  @override
  void dispose() {
    controller.removeListener(cameraListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CameraViewModel>(builder: (context, provider, widgets) {
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
                      if (!provider.isRecording) {
                        /* controller.pr().then((v) {
                          controller.startVideoRecording(
                            onAvailable: (image) {},
                          );
                        }); */
                        await controller.startImageStream((v) {
                          
                        });
                      } else {
                        controller.stopImageStream();
                        /* controller.stopVideoRecording().then((v) {
                          print('path ${v.path}');
                        }); */
                      }
                    },
                    child: Container(
                      height: kSize(context).height / 7,
                      decoration: BoxDecoration(
                          color: kBlackColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2,
                              color: provider.isRecording
                                  ? Colors.red
                                  : kWhiteColor)),
                      child: Center(
                          child: Text(
                        !provider.isRecording ? "Enregister" : "Arreter",
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
  
}
