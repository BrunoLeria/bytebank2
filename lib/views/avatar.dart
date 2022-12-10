import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bytebank2/components/response_dialog.dart';
import 'package:bytebank2/database/dao/avatar.dart';
import 'package:bytebank2/models/avatar.dart';
import 'package:bytebank2/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({Key? key}) : super(key: key);

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imageFile;
  Size? size;
  final AvatarDao _avatarDao = AvatarDao();
  final FailureDialog? failureDialog = const FailureDialog();
  final SuccessDialog? successDialog = const SuccessDialog();

  @override
  void initState() {
    super.initState();
    _loadCamera();
  }

  _loadCamera() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    } catch (e) {
      failureDialog!.showFailureSnackBar(message: e.toString());
    }
  }

  void _startCamera() {
    if (cameras.isEmpty) {
      failureDialog!.showFailureSnackBar(message: "Camêra não foi encontrada");
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
        body: SizedBox(
          width: size!.width,
          height: size!.height,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    32.0,
                  ),
                  child: SizedBox(
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
      failureDialog!.showFailureSnackBar(message: e.toString());
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
    return SizedBox(
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
                      _accept(context)
                          .then((value) => {if (value) Navigator.pop(context)});
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

      if (mounted) {
        setState(() {
          imageFile = file;
        });
      }
    } on CameraException catch (e) {
      failureDialog!.showFailureSnackBar(message: e.toString());
    }
  }

  Future<bool> _accept(BuildContext context) async {
    try {
      Avatar avatar;
      String base64 = base64String(await imageFile!.readAsBytes());
      avatar = Avatar(0, base64, AuthService.to.user?.email);
      _avatarDao.save(avatar);
      successDialog!.showSuccessfulSnackBar("Avatar alterado com sucesso");
      return true;
    } catch (e) {
      String exception = e.toString();
      failureDialog!.showFailureSnackBar(
          message: "Erro ao gravar alteração do avatar: $exception");
      return false;
    }
  }

  void _selectImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        imageFile = image;
      });
    } catch (e) {
      failureDialog!.showFailureSnackBar(message: e.toString());
    }
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
