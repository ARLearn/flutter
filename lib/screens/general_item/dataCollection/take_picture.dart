import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youplay/models/general_item.dart';
import 'package:youplay/models/run.dart';
import 'package:youplay/screens/general_item/dataCollection/picture_preview_live.dart';
import 'package:youplay/screens/general_item/util/messages/generic_message.dart';
import 'package:youplay/screens/util/utils.dart';
import 'package:youplay/ui/components/appbar/themed-appbar.container.dart';
import 'package:youplay/ui/components/buttons/camera_button.dart';
import 'package:youplay/ui/components/messages/message-background.widget.container.dart';
import 'package:youplay/ui/components/messages_parts/richtext-top.container.dart';

import '../general_item.dart';

class TakePictureWidget extends StatefulWidget {
  // dynamic takePictureCallBack;
  // GeneralItemViewModel giViewModel;
  Function cancelCallBack;
  Function(String) pictureTaken;

  // Run? run;
  GeneralItem? generalItem;

  TakePictureWidget(
      {
        // required this.giViewModel,
        required this.cancelCallBack,
      // this.run,
        required this.generalItem,
        required this.pictureTaken});

  @override
  _TakePictureWidgetState createState() {
    return _TakePictureWidgetState();
  }
}

class _TakePictureWidgetState extends State<TakePictureWidget> {
  CameraController? controller;

  _TakePictureWidgetState();

  List<CameraDescription> cameras = [];
  CameraLensDirection _direction = CameraLensDirection.back;

  // bool pictureTaken = false;
  // String imagePath;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // Fetch the available cameras before initializing the app.
    _loadCameras().then((cameras) {
      setState(() {
        this.cameras = cameras;
        print("cameras loaded ${this.cameras.length}");
      });
    });

    _initializeCamera();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.giViewModel.item == null){
    //   return Container(child: Text('item loading...'));  //todo make message beautiful
    // }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ThemedAppbarContainer(title: widget.generalItem!.title, elevation: false),
      body: MessageBackgroundWidgetContainer(
          // item: widget.giViewModel.item!,
          // giViewModel: widget.giViewModel,
          // padding: false,
          // elevation: false,
          child: Stack(
            children: [
              Container(
                color: Color.fromRGBO(0, 0, 0, 0.7),
                child: Column(

                mainAxisSize: MainAxisSize.max,
                children: [
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.vertical,
                    //   child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RichTextTopContainer(),
                          CameraSquarePreview(controller: controller),

                        ],
                      ),
                    // ),
                ],
              ),

              ),
              Positioned(
                left:0,
                  right:0,
                  bottom: 30,
                  child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,

                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                              child: CameraButton(onTap: () => _takePicture())
                            ),
                          ],
                        )
                      ]))
            ],
          )),
    );
  }

  void _initializeCamera() async {
    CameraDescription? cameraDesc = await getCamera(_direction);
    if (cameraDesc == null) {
      return;
    }
    controller = CameraController(
      cameraDesc,
      ResolutionPreset.high,
    );
    await controller!.initialize().then((_) {
      setState(() {
        this.cameras = this.cameras;
      });
    });
  }

  Future<List<CameraDescription>> _loadCameras() async {
    try {
      if (cameras == null || cameras.isEmpty) return await availableCameras();
    } on CameraException catch (e) {}
    return [];
  }


  Future<void> _takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);

    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    XFile imageFile;
    try {
      imageFile = await controller!.takePicture();
    } on CameraException catch (e) {
      return null;
    }
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(imageFile.path);

    int width = properties.width?? 250;
    int height = properties.height??700;
    if (width < height) {
      var offset = (height - width) / 2;
      if (offset < 0) {
        offset = offset * -1;
      }
      File croppedFile = await FlutterNativeImage.cropImage(
          imageFile.path, 0, offset.round(), width, width);

      croppedFile.path;
      widget.pictureTaken(croppedFile.path);
    } else {

      var offset = (height - width) / 2;
      if (offset < 0) {
        offset = offset * -1;
      }
      File croppedFile = await FlutterNativeImage.cropImage(
          imageFile.path,  offset.round(), 0, height, height);

      croppedFile.path;
      widget.pictureTaken(croppedFile.path);
    }
  }
}
