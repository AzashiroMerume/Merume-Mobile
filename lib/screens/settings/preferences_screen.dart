import 'package:flutter/material.dart';
import 'package:merume_mobile/api/user_api/preferences_api/user_preferences_api.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/constants/exceptions.dart';
import 'package:merume_mobile/constants/categories.dart';
import 'package:merume_mobile/screens/shared/confirmation_popup_widget.dart';
import 'package:merume_mobile/utils/error_custom_snackbar.dart';
import 'package:merume_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool isSavePressed = false;

  List<String> selected = [];

  String errorMessage = '';

  @override
  void initState() {
    categories.sort();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState state = Navigator.of(context);
    final userInfoProvider = Provider.of<UserProvider>(context, listen: false);
    final userInfo = userInfoProvider.userInfo;

    return PopScope(
      canPop: isSavePressed ? false : true,
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please select preferences',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        color: AppColors.mellowLemon,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(categories.length, (index) {
                            bool isSelected =
                                selected.contains(categories[index]);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selected.remove(categories[index]);
                                  } else {
                                    selected.add(categories[index]);
                                  }
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  color: isSelected
                                      ? AppColors.mellowLemon
                                      : Colors.grey.shade900,
                                ),
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: selected.isEmpty || isSavePressed
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return ConfirmationPopup(
                            onCancel: () {
                              state.pop(dialogContext); // Close the dialog
                            },
                            onSave: () async {
                              state.pop(dialogContext); // Close the dialog

                              setState(() {
                                isSavePressed = true;
                              });

                              try {
                                if (selected.isEmpty) {
                                  throw UnprocessableEntityException(
                                      'Invalid input data');
                                }

                                await savePreferences(selected);

                                //update preferences in Provider
                                userInfoProvider.setUser(userInfo!
                                    .updatePreferences(preferences: selected));

                                if (context.mounted) {
                                  state.pop(context);
                                }
                              } catch (e) {
                                setState(() {
                                  if (e is TokenErrorException) {
                                    errorMessage =
                                        'There is an error with authentication. Please try to re-login.';
                                  } else if (e
                                      is UnprocessableEntityException) {
                                    errorMessage =
                                        'Please choose at least one element';
                                  } else if (e is NetworkException) {
                                    errorMessage =
                                        'Network error has occurred. Please check your internet connection.';
                                  } else if (e is ServerException ||
                                      e is HttpException) {
                                    errorMessage =
                                        'There was an error on the server side, try again later.';
                                  } else {
                                    errorMessage =
                                        'An unexpected error occurred. Please try again later.';
                                  }
                                });
                              } finally {
                                isSavePressed = false;

                                if (context.mounted &&
                                    errorMessage.isNotEmpty) {
                                  showCustomSnackBar(context,
                                      message: errorMessage);
                                }
                              }
                            },
                          );
                        },
                      );
                    },
              backgroundColor: selected.isEmpty
                  ? AppColors.royalPurple.withOpacity(0.5)
                  : AppColors.royalPurple,
              child: Icon(
                Icons.check,
                color: selected.isEmpty
                    ? AppColors.lightGrey
                    : AppColors.mellowLemon,
              ),
            ),
          ),
          if (isSavePressed)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
