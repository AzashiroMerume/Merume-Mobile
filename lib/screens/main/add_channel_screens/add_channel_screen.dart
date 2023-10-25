import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merume_mobile/api/user_channels_api/new_channel_api.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/exceptions.dart';
import 'package:merume_mobile/screens/components/pfp_load_image_widget.dart';
import 'package:merume_mobile/screens/main/components/category_popup_widget.dart';
import 'package:merume_mobile/screens/settings/components/categories.dart';

class AddChallengeScreen extends StatefulWidget {
  const AddChallengeScreen({super.key});

  @override
  State<AddChallengeScreen> createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {
  final TextEditingController _challengeNameController =
      TextEditingController();
  final TextEditingController _challengeDescriptionController =
      TextEditingController();
  final TextEditingController _challengeCategoriesController =
      TextEditingController();
  final TextEditingController _challengeGoalController =
      TextEditingController();

  String challengeName = '';
  String challengeGoal = '';
  String challengeDescription = '';
  String challengeType = 'Public';
  List<String> challengeCategories = [];

  String? selectedImagePath;
  bool isImageSelected = false;

  String errorMessage = '';

  Map<String, String> errors = {};

  void handleImageUpload(String? imagePath) {
    if (imagePath != null) {
      selectedImagePath = imagePath;
    }
  }

  Future<String?> uploadImage(String? imagePath) async {
    if (imagePath == null) {
      return null; // Return null if no image was provided
    }

    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('images').child(imagePath);

      final UploadTask uploadTask = storageReference.putFile(File(imagePath));

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      if (snapshot.state == TaskState.success) {
        final String downloadURL = await storageReference.getDownloadURL();
        return downloadURL;
      } else {
        print("Upload failed. State: ${snapshot.state}");
        throw FirebaseUploadException('Image upload failed');
      }
    } catch (e) {
      throw FirebaseUploadException('Image upload failed');
    }
  }

  @override
  void dispose() {
    _challengeNameController.dispose();
    _challengeDescriptionController.dispose();
    _challengeCategoriesController.dispose();
    _challengeGoalController.dispose(); // Add this
    super.dispose();
  }

  // Function to validate fields
  void validateFields() {
    errors.clear(); // Clear previous errors

    if (challengeName.isEmpty) {
      errors['challengeName'] = 'Challenge name is required';
    }

    if (challengeDescription.isEmpty) {
      errors['challengeDescription'] = 'Challenge description is required';
    }

    if (challengeCategories.isEmpty) {
      errors['challengeCategories'] =
          'Challenge must have at least one category';
    }

    if (_challengeGoalController.text.isEmpty) {
      errors['challengeGoal'] = 'Challenge goal is required';
    } else {
      final int goal = int.tryParse(_challengeGoalController.text) ?? 0;
      if (goal < 1000 || goal > 2000) {
        errors['challengeGoal'] =
            'Challenge goal must be between 1000 and 2000 days';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState state = Navigator.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32.0),
              const Text(
                'Create Challenge',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: AppColors.mellowLemon,
                ),
              ),
              const SizedBox(height: 32.0),
              if (errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          'Error: $errorMessage',
                          style: const TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (errorMessage.isNotEmpty) const SizedBox(height: 16.0),
              PfpLoadImageWidget(
                onImageSelected: handleImageUpload,
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _challengeNameController,
                decoration: InputDecoration(
                  hintText: 'Challenge name',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: errors.containsKey('challengeName')
                      ? errors['challengeName']
                      : null,
                ),
                onChanged: (value) {
                  challengeName = value;
                },
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _challengeGoalController,
                decoration: InputDecoration(
                  hintText: 'Challenge goal (days) (1000 - 2000)',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: errors.containsKey('challengeGoal')
                      ? errors['challengeGoal']
                      : null,
                ),
                onChanged: (value) {
                  challengeGoal = value;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _challengeDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Challenge description',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: errors.containsKey('challengeDescription')
                      ? errors['challengeDescription']
                      : null,
                ),
                minLines: 1,
                maxLines: 5,
                onChanged: (value) {
                  challengeDescription = value;
                },
              ),
              const SizedBox(height: 32.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: challengeType,
                    style: const TextStyle(color: Colors.black),
                    items: <String>['Public', 'Private'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        challengeType = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _challengeCategoriesController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: challengeCategories.isNotEmpty
                      ? challengeCategories.join(', ')
                      : 'Choose a category',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: errors.containsKey('challengeCategories')
                      ? errors['challengeCategories']
                      : null,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () async {
                      List<String>? selected = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CategoryPopup(
                            categories: categories,
                            selectedCategories: challengeCategories,
                          );
                        },
                      );

                      if (selected != null) {
                        setState(() {
                          challengeCategories = selected;
                        });
                      }
                    },
                  ),
                ),
                onTap: () async {
                  List<String>? selected = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CategoryPopup(
                        categories: categories,
                        selectedCategories: challengeCategories,
                      );
                    },
                  );

                  if (selected != null) {
                    setState(() {
                      challengeCategories = selected;
                    });
                  }
                },
              ),
              const SizedBox(height: 50.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    validateFields();

                    setState(() {
                      errorMessage = '';
                    });

                    if (errors.isEmpty) {
                      try {
                        final uploadedImageUrl =
                            await uploadImage(selectedImagePath);

                        await newChannel(
                          challengeName,
                          challengeGoal,
                          challengeType,
                          challengeDescription,
                          challengeCategories,
                          uploadedImageUrl,
                        ); // Pass the challengeGoal

                        state.pop(context);
                      } catch (e) {
                        setState(() {
                          if (e is TokenAuthException) {
                            errorMessage =
                                'Token authentication error. Please try to relogin.';
                          } else if (e is UnprocessableEntityException) {
                            errorMessage =
                                'Invalid input data. Please follow the requirements.';
                          } else if (e is ServerException ||
                              e is HttpException) {
                            errorMessage =
                                'There was an error on the server side. Please try again later.';
                          } else if (e is FirebaseUploadException) {
                            print(e.message);
                            errorMessage =
                                'Uploading of images failed. You can proceed without it now and upload it later.';
                          } else if (e is NetworkException) {
                            errorMessage =
                                'A network error has occurred. Please check your internet connection.';
                          } else if (e is TimeoutException) {
                            errorMessage =
                                'Network connection is poor. Please try again later.';
                          }
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(178, 38),
                    backgroundColor: AppColors.royalPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
