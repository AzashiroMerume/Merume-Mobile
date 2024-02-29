import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merume_mobile/api/user_api/user_channels_api/new_channel_api.dart';
import 'package:merume_mobile/utils/colors.dart';
import 'package:merume_mobile/utils/exceptions.dart';
import 'package:merume_mobile/utils/error_custom_snackbar.dart';
import 'package:merume_mobile/screens/shared/basic/basic_elevated_button_widget.dart';
import 'package:merume_mobile/screens/shared/pfp_load_image_widget.dart';
import 'package:merume_mobile/screens/main/components/category_popup_widget.dart';
import 'package:merume_mobile/screens/shared/categories.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';
import 'package:objectid/objectid.dart';

class AddChannelScreenSecond extends StatefulWidget {
  final ChannelType? selectedChannelType;
  final Function(int step) onComplete;

  const AddChannelScreenSecond(
      {super.key, required this.selectedChannelType, required this.onComplete});

  @override
  State<AddChannelScreenSecond> createState() => _AddChannelScreenSecondState();
}

class _AddChannelScreenSecondState extends State<AddChannelScreenSecond> {
  final TextEditingController _challengeNameController =
      TextEditingController();
  final TextEditingController _challengeDescriptionController =
      TextEditingController();
  final TextEditingController _challengeCategoriesController =
      TextEditingController();
  final TextEditingController _challengeGoalController =
      TextEditingController();

  String challengeName = '';
  int? challengeGoal;
  String challengeDescription = '';
  String challengeVisibility = 'Public';
  List<String> challengeCategories = [];

  String? selectedImagePath;
  bool isImageSelected = false;

  bool isPressed = false;

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
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw AuthenticationException('User not authenticated with Firebase');
      }

      final String randomName = ObjectId().hexString;

      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('channel_pfps')
          .child('$randomName.jpg');

      final UploadTask uploadTask = storageReference.putFile(File(imagePath));

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      if (snapshot.state == TaskState.success) {
        final String downloadURL = await storageReference.getDownloadURL();
        return downloadURL;
      } else {
        throw FirebaseUploadException('Image upload failed');
      }
    } catch (e) {
      if (e is FirebaseException) {
        // Specific Firebase Storage exceptions
        if (e.code == 'permission-denied') {
          throw FirebaseUploadException('Permission denied');
        } else if (e.code == 'unauthenticated') {
          throw AuthenticationException('User unauthenticated');
        } else {
          throw FirebaseUploadException('Unknown error: ${e.code}');
        }
      } else {
        rethrow;
      }
    }
  }

  @override
  void dispose() {
    _challengeNameController.dispose();
    _challengeDescriptionController.dispose();
    _challengeCategoriesController.dispose();
    _challengeGoalController.dispose();
    super.dispose();
  }

  void validateFields() {
    errors.clear();

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

    if (widget.selectedChannelType == ChannelType.fixed) {
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

    if (errors.isEmpty) {
      widget.onComplete(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState state = Navigator.of(context);

    return PopScope(
      canPop: isPressed ? false : true,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Create Challenge',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                    color: AppColors.mellowLemon,
                  ),
                ),
                const SizedBox(height: 32.0),
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
                if (widget.selectedChannelType == ChannelType.fixed)
                  Column(
                    children: [
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
                          challengeGoal = int.tryParse(value) ?? 0;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                      const SizedBox(height: 32.0),
                    ],
                  ),
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
                      value: challengeVisibility,
                      style: const TextStyle(color: Colors.black),
                      items: <String>['Public', 'Private'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          challengeVisibility = value!;
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
                  child: BasicElevatedButtonWidget(
                    buttonText: 'Confirm',
                    onPressed: isPressed
                        ? null
                        : () async {
                            validateFields();

                            if (errors.isNotEmpty) {
                              isPressed = false;
                            } else {
                              isPressed = true;
                            }

                            setState(() {
                              errorMessage = '';
                            });

                            if (errors.isEmpty) {
                              try {
                                final uploadedImageUrl =
                                    await uploadImage(selectedImagePath);

                                await newChannel(
                                  widget.selectedChannelType!,
                                  challengeName,
                                  challengeGoal,
                                  challengeVisibility,
                                  challengeDescription,
                                  challengeCategories,
                                  uploadedImageUrl,
                                );

                                if (context.mounted) {
                                  state.pop(context);
                                }
                              } catch (e) {
                                if (kDebugMode) {
                                  print("Add Channel Second error: $e");
                                }
                                setState(() {
                                  if (e is TokenErrorException) {
                                    errorMessage =
                                        'Token authentication error. Please try to relogin.';
                                  } else if (e is FirebaseAuthException) {
                                    errorMessage =
                                        'An unexpected error occurred. Please try again later.';
                                  } else if (e
                                      is UnprocessableEntityException) {
                                    errorMessage =
                                        'Invalid input data. Please follow the requirements.';
                                  } else if (e is ServerException ||
                                      e is HttpException) {
                                    errorMessage =
                                        'There was an error on the server side. Please try again later.';
                                  } else if (e is FirebaseUploadException) {
                                    errorMessage =
                                        'Uploading of images failed. You can proceed without it now and upload it later.';
                                  } else if (e is NetworkException) {
                                    errorMessage =
                                        'A network error has occurred. Please check your internet connection.';
                                  } else if (e is TimeoutException) {
                                    errorMessage =
                                        'Network connection is poor. Please try again later.';
                                  } else {
                                    errorMessage =
                                        'An unexpected error occurred. Please try again later.';
                                  }
                                });
                              } finally {
                                isPressed = false;

                                if (context.mounted &&
                                    errorMessage.isNotEmpty) {
                                  showCustomSnackBar(context,
                                      message: errorMessage);
                                  widget.onComplete(1);
                                }
                              }
                            }
                          },
                    isPressed: isPressed,
                    backgroundColor: AppColors.royalPurple,
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
