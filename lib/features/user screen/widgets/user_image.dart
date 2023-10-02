import 'package:flutter/material.dart';
import 'package:music_player/controller/authentication_controller.dart';
import 'package:provider/provider.dart';
import 'image_selector.dart';

class UserImageWidget extends StatelessWidget {
  const UserImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context);
    return FutureBuilder(
        future: authenticationController.getUserImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircleAvatar(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ImageSelectorBottomSheet(
                      authenticationController: authenticationController),
                );
              },
              child: const CircleAvatar(
                radius: 30,
                child: Icon(Icons.add_photo_alternate),
              ),
            );
          }
          return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!),
            radius: 30,
          );
        });
  }
}
