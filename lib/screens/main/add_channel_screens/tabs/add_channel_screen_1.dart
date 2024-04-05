import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/constants/enums.dart';
import 'package:merume_mobile/screens/shared/basic/basic_elevated_button_widget.dart';
import 'package:merume_mobile/constants/text_styles.dart';

class AddChannelScreenFirst extends StatefulWidget {
  final VoidCallback onComplete;
  final Function(ChallengeTypes?) onItemSelected;
  final ChallengeTypes? initialSelectedItem;

  const AddChannelScreenFirst({
    super.key,
    required this.onComplete,
    required this.onItemSelected,
    required this.initialSelectedItem,
  });

  @override
  State<AddChannelScreenFirst> createState() => _AddChannelScreenFirstState();
}

class _AddChannelScreenFirstState extends State<AddChannelScreenFirst> {
  ChallengeTypes? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialSelectedItem;
  }

  void selectItem(ChallengeTypes item) {
    setState(() {
      selectedItem = item;
    });
    widget.onItemSelected(selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select a channel type",
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: AppColors.mellowLemon,
                ),
              ),
              const SizedBox(height: 32.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectItem(ChallengeTypes.fixed);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: selectedItem == ChallengeTypes.fixed
                            ? AppColors.royalPurple
                            : Colors.transparent,
                        border: Border.all(
                          color: selectedItem == ChallengeTypes.fixed
                              ? AppColors.royalPurple
                              : Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fixed day challenge",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              color: selectedItem == ChallengeTypes.fixed
                                  ? Colors.white
                                  : AppColors.royalPurple,
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Text(
                              "Create a dedicated space for continuous improvement in your chosen field. Set your channel duration for an extended period, allowing members to commit to ongoing growth and progress over 1000 days or more. Share, learn, and evolve together in this focused and dedicated environment.",
                              style: TextStyles.subtle),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.royalPurple,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      selectItem(ChallengeTypes.unfixed);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: selectedItem == ChallengeTypes.unfixed
                            ? AppColors.royalPurple
                            : Colors.transparent,
                        border: Border.all(
                          color: selectedItem == ChallengeTypes.unfixed
                              ? AppColors.royalPurple
                              : Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unfixed day challenge",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              color: selectedItem == ChallengeTypes.unfixed
                                  ? Colors.white
                                  : AppColors.royalPurple,
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          const Text(
                              "Create a dedicated space for continuous improvement in your chosen field. Set your channel duration for an extended period, allowing members to commit to ongoing growth and progress over 1000 days or more. Share, learn, and evolve together in this focused and dedicated environment.",
                              style: TextStyles.subtle),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BasicElevatedButtonWidget(
                        buttonText: 'Next',
                        onPressed:
                            selectedItem != null ? widget.onComplete : null,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
