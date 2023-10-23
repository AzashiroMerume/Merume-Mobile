import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merume_mobile/colors.dart';

class PfpLoadImageWidget extends StatefulWidget {
  final Function(String?) onImageSelected;

  const PfpLoadImageWidget({
    Key? key,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  PfpLoadImageWidgetState createState() => PfpLoadImageWidgetState();
}

class PfpLoadImageWidgetState extends State<PfpLoadImageWidget> {
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
                  radius: 30.0,
                  child: ClipOval(
                    child: imagePath != null
                        ? Image.file(File(imagePath!), fit: BoxFit.cover)
                        : const Icon(
                            Icons.image,
                            size: 70,
                            color: Colors.white,
                          ),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
