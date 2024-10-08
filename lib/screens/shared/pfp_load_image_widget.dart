import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merume_mobile/constants/colors.dart';

class PfpLoadImage extends StatefulWidget {
  final Function(String?) onImageSelected;

  const PfpLoadImage({
    super.key,
    required this.onImageSelected,
  });

  @override
  PfpLoadImageState createState() => PfpLoadImageState();
}

class PfpLoadImageState extends State<PfpLoadImage> {
  final ImagePicker picker = ImagePicker();
  XFile? pickedImage;
  String? imagePath;

  Future<void> pickImage() async {
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage!.path;
      });
      widget.onImageSelected(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: pickImage,
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircleAvatar(
                backgroundColor: AppColors.royalPurple,
                backgroundImage:
                    imagePath != null ? FileImage(File(imagePath!)) : null,
                child: imagePath == null
                    ? const Icon(
                        Icons.image,
                        size: 70,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
