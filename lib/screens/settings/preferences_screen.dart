import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/exceptions.dart';
import 'package:merume_mobile/user_info.dart';
import 'package:provider/provider.dart';
import 'components/categories.dart';

import '../../api/user_preferences_api/user_preferences_api.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool isPressed = false;

  List<String> selected = [];

  String errorMessage = '';

  @override
  void initState() {
    categories.sort();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState state = Navigator.of(context);
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
    final userInfo = userInfoProvider.userInfo;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
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
                      bool isSelected = selected.contains(categories[index]);
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
                            style: const TextStyle(
                              fontFamily: 'WorkSans',
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
        onPressed: selected.isEmpty || isPressed
            ? null
            : () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      title: const Text(
                        "Are you sure?",
                        style: TextStyle(
                            color: AppColors.mellowLemon,
                            fontFamily: "Poppins"),
                      ),
                      content: const Text(
                        "Do you want to save your preferences?",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'WorkSans',
                            fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          child: const Text(
                            "CANCEL",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'WorkSans',
                                fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.royalPurple, // Custom button color
                          ),
                          onPressed: isPressed
                              ? null
                              : () async {
                                  setState(() {
                                    isPressed = true;
                                  });

                                  state.pop();

                                  try {
                                    if (selected.isEmpty) {
                                      throw UnprocessableEntityException(
                                          'Invalid input data');
                                    }

                                    await savePreferences(selected);

                                    //update preferences in Provider
                                    userInfoProvider.setUserInfo(userInfo!
                                        .updatePreferences(
                                            preferences: selected));

                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    setState(() {
                                      if (e is TokenAuthException) {
                                        errorMessage =
                                            'There is an error with authentication. Please try to re-login.';
                                      } else if (e
                                          is UnprocessableEntityException) {
                                        errorMessage =
                                            'Please choose at least one element';
                                      } else if (e is NetworkException) {
                                        errorMessage =
                                            'Network error has occured. Please check your internet connection.';
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
                                    isPressed = false;

                                    //show the errors
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            errorMessage,
                                            style: const TextStyle(
                                              fontFamily: 'WorkSans',
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          duration: const Duration(seconds: 10),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: const Text(
                            "SAVE",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'WorkSans',
                                fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
        backgroundColor: AppColors.royalPurple,
        child: const Icon(Icons.check),
      ),
    );
  }
}
