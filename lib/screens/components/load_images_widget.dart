import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merume_mobile/colors.dart';

class LoadImagesWidget extends StatefulWidget {
  final Function(String?) onImageUploaded;

  const LoadImagesWidget({Key? key, required this.onImageUploaded})
      : super(key: key);

  @override
  _LoadImagesWidgetState createState() => _LoadImagesWidgetState();
}

class _LoadImagesWidgetState extends State<LoadImagesWidget> {
  final ImagePicker picker = ImagePicker();
  XFile? pickedImage;
  String? imagePath;

  bool isImageSelected = false;

  Future<void> _pickImage() async {
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage!.path;
        isImageSelected = true;
      });
    }
  }

  Future<String?> _uploadImage(String? imagePath) async {
    if (imagePath != null) {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('images').child(imagePath);
      final UploadTask uploadTask = storageReference.putFile(File(imagePath));

      // Wait for the upload to complete
      await uploadTask.whenComplete(() {
        print('Image uploaded to Firebase Storage');
      });

      // Get the download URL for the uploaded image
      final String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    }

    return null; // Return null if no image was provided
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
                  color: Colors.black, // You can customize the border
                ),
              ),
              child: isImageSelected
                  ? Image.file(File(imagePath!), fit: BoxFit.cover)
                  : const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey, // You can customize the icon's color
                    ),
            ),
          ),
        ),
        const SizedBox(height: 32.0),
        ElevatedButton(
          onPressed: () async {
            final imageUrl = await _uploadImage(imagePath);
            widget.onImageUploaded(imageUrl);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(178, 38),
            backgroundColor: AppColors.royalPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: const Text(
            'Upload Image',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
