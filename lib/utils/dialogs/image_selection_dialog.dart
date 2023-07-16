import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/components/buttons/rounded_textbutton_icon.dart';
import 'package:my_groovy_recipes/constants/image_paths.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

import 'package:image_picker/image_picker.dart';

Future<Map<String, dynamic>?> showImageSelectionDialog(
    BuildContext context) async {
  String? selectedImageAsset;
  XFile? selectedImageFromDevice;

  Future selectImageFromDevice(BuildContext context) async {
    final fileFromDevice = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    // return if the user did not select an image
    if (fileFromDevice == null) return null;

    // user selected an image from his or hers device
    selectedImageFromDevice = fileFromDevice;

    // user has picked an image from his or hers device
    if (context.mounted) Navigator.pop(context);
  }

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const CustomColors().beige,
        contentPadding: EdgeInsets.all(0),
        insetPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        titlePadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
          side: BorderSide(width: 2.0, color: Colors.black),
        ),
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: defaultPadding,
                  bottom: 8,
                  left: defaultPadding,
                  right: defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Choose an Image"),
                  InkWell(
                      onTap: () {
                        // close dialog
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 2,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        content: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 16, bottom: 0, left: 16, right: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // select an image button
                Center(
                  child: RoundedTextIconButton(
                      icon: const Icon(
                        FontAwesomeIcons.mobileScreen,
                        color: Colors.black,
                      ),
                      // onPressed: selectImage,
                      onPressed: () async {
                        await selectImageFromDevice(context);
                      },
                      text: "Select from your device"),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Text("or choose one of our images!"),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: recipeImages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final imagePath = recipeImages.elementAt(index);

                          return InkWell(
                            onTap: () {
                              selectedImageAsset = imagePath;
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                imagePath,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      );
    },
  );

  return {
    'selectedImageAsset': selectedImageAsset,
    'selectedImageFromDevice': selectedImageFromDevice
  };
}
