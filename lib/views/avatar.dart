import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPage extends StatefulWidget {
  AvatarPage({Key? key}) : super(key: key);

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imageFile;
  Size? size;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCamera();
  }

  _loadCamera() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    } catch (e) {}
  }

  void _startCamera() {
    if (cameras.isEmpty) {
      print("Camêra nào foi encontrada");
      return;
    }
    _previewCamera(cameras.first);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Avatar'),
          backgroundColor: Colors.green,
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          width: size!.width,
          height: size!.height,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    32.0,
                  ),
                  child: Container(
                    width: size!.width,
                    height: size!.height,
                    child: _cameraPreviewWidget(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _previewCamera(CameraDescription first) async {
    controller = CameraController(
      first,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    try {
      await controller!.initialize();
    } catch (e) {
      print(e);
    }
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  _cameraPreviewWidget() {
    final CameraController? cameracontroller = controller;

    if (cameracontroller == null || !cameracontroller.value.isInitialized) {
      return const Center(
        child: Text('Widget para câmera não foi inicializado'),
      );
    }
    return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: imageFile == null
            ? [
                CameraPreview(cameracontroller),
                _botaoCapturar(),
              ]
            : [
                Image.file(File(imageFile!.path)),
                _botaoCapturar(),
              ]);
  }

  _botaoCapturar() {
    return Container(
      width: size!.width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: (imageFile == null)
            ? [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: IconButton(
                    onPressed: () {
                      takePicture();
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Color.fromARGB(255, 180, 207, 149),
                      size: 32,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: IconButton(
                    onPressed: () {
                      _selectImage();
                    },
                    icon: const Icon(
                      Icons.photo,
                      color: Color.fromARGB(255, 180, 207, 149),
                      size: 32,
                    ),
                  ),
                ),
              ]
            : [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: IconButton(
                    onPressed: () {
                      _accept(context);
                    },
                    icon: const Icon(
                      Icons.done,
                      color: Color.fromARGB(255, 180, 207, 149),
                      size: 32,
                    ),
                  ),
                ),
              ],
      ),
    );
  }

  void takePicture() async {
    final CameraController? cameracontroller = controller;
    if (cameracontroller == null || !cameracontroller.value.isInitialized) {
      return;
    }
    try {
      XFile file = await cameracontroller.takePicture();
      print(file);
      print("foto tirada");

      if (mounted)
        setState(() {
          imageFile = file;
        });
    } on CameraException catch (e) {
      print(e);
    }
  }

  void _accept(BuildContext context) {
    Navigator.pop(context);
  }

  void _selectImage() async{
    final ImagePicker picker = ImagePicker();
    print("entrou no select image");
    try {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
    print("abriu a galeria");
      if (image != null) {
        setState(() {
          imageFile = image;
        });
      }
    } catch (e) {
      print (e);
    }
  }
}
