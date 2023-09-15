import 'dart:io';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/widgets/buttons/outline_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Pickers {
  static Future<List<File>> _pickImage(String where, BuildContext ctx) async {
    if (where == 'camera') {
      ImagePicker picker = ImagePicker();
      XFile? pickedImage =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

      if (pickedImage != null) {
        return [File(pickedImage.path)];
      } else {
        return [];
      }
    } else {
      ImagePicker picker = ImagePicker();
      List<XFile> pickedImage = await picker.pickMultiImage(imageQuality: 80);
      List<File> returnFiles = [];
      if (pickedImage.isNotEmpty) {
        for (var i = 0; i < pickedImage.length; i++) {
          returnFiles.add(File(pickedImage[i].path));
        }
        return returnFiles;
      } else {
        return [];
      }
    }
  }

  static Future<List<File>> showCustomDialog(
      BuildContext context, double defaultSize) async {
    final size = MediaQuery.of(context).size;
    List<File> toReturn = [];
    await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: size.height * 0.25,
            margin: const EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: KColors.kPrimaryColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    Strings.fromWhereYouWantPhoto,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: KColors.kWhiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlineButtonOwn(
                        defaultSize: defaultSize,
                        onTap: () async {
                          toReturn =
                              await _pickImage('camera', context).then((value) {
                            Navigator.of(context).pop();
                            return value;
                          });
                        },
                        text: Strings.fromAparat,
                        icon: Icons.camera_alt_outlined,
                        width: size.width * 0.42,
                      ),
                      OutlineButtonOwn(
                        defaultSize: defaultSize,
                        onTap: () async {
                          toReturn = await _pickImage('gallery', context)
                              .then((value) {
                            Navigator.of(context).pop();
                            return value;
                          });
                        },
                        text: Strings.fromGallery,
                        icon: Icons.photo_size_select_actual_outlined,
                        width: size.width * 0.42,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim),
          child: child,
        );
      },
    );

    return toReturn;
  }
}
