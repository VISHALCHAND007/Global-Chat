import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as imgPicker;

class ImagePicker extends StatefulWidget {
  const ImagePicker({super.key});

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  File? _userImg;

  void openImagePicker(imgPicker.ImageSource source) async {
    Navigator.of(context).pop();
    final selectedImg = await imgPicker.ImagePicker().pickImage(source: source);
    if (selectedImg != null) {
      print("selected image:: $selectedImg");
      setState(() {
        _userImg = File(selectedImg.path);
      });
    }
  }

  void onClicked() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              TextButton.icon(
                label: Text("Take picture"),
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () => openImagePicker(imgPicker.ImageSource.camera),
              ),
              TextButton.icon(
                label: Text("Choose from gallery"),
                icon: Icon(Icons.photo_library_outlined),
                onPressed: () => openImagePicker(imgPicker.ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClicked,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(45),
            ),
            child: CircleAvatar(
              backgroundColor: Color(0x00b2aeae),
              radius: 45,
              child: _userImg == null
                  ? Padding(
                      padding: const EdgeInsetsGeometry.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(45),
                        child: Image.asset(
                          "assets/images/image_placeholder.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsetsGeometry.all(1),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(45),
                        child: Image.file(
                          _userImg!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: -2,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Padding(
                padding: const EdgeInsetsGeometry.all(5),
                child: Icon(Icons.add_a_photo_outlined, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
