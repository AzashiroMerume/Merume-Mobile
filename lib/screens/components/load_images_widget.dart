import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LoadImagesWidget extends StatefulWidget {
  final Function(String?) onImageSelected;

  const LoadImagesWidget({
    Key? key,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  _LoadImagesWidgetState createState() => _LoadImagesWidgetState();
}

class _LoadImagesWidgetState extends State<LoadImagesWidget> {
  final ImagePicker picker = ImagePicker();
  XFile? pickedImage;
  String? imagePath;

  Future<void> _pickImage() async {
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
            onTap: _pickImage,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: imagePath != null
                  ? Image.file(File(imagePath!), fit: BoxFit.cover)
                  : const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
