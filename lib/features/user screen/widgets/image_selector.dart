import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../controller/authentication_controller.dart';
import '../../../utils/constants/constants.dart';

class ImageSelectorBottomSheet extends StatelessWidget {
  const ImageSelectorBottomSheet({
    super.key,
    required this.authenticationController,
  });

  final AuthenticationController authenticationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: Constants.bottomSheetDecoration,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                await Permission.camera.request();
                ImagePicker imagepicker = ImagePicker();
                XFile? pickedFile = await imagepicker.pickImage(
                    source: ImageSource.camera);
                if (pickedFile != null) {
                  authenticationController
                      .addImageToFirebaseStorage(
                          pickedFile.path);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.white,
                  ),
                  Text("Camera",
                      style: Constants.musicListTextStyle)
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                ImagePicker imagepicker = ImagePicker();
                XFile? pickedFile = await imagepicker.pickImage(
                    source: ImageSource.gallery);
                if (pickedFile != null) {
                  authenticationController
                      .addImageToFirebaseStorage(
                          pickedFile.path);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 50,
                  ),
                  Text("Gallery",
                      style: Constants.musicListTextStyle)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}