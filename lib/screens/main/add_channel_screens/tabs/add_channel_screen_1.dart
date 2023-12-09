import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';

class AddChannelScreenFirst extends StatefulWidget {
  final VoidCallback onComplete;

  const AddChannelScreenFirst({super.key, required this.onComplete});

  @override
  State<AddChannelScreenFirst> createState() => _AddChannelScreenFirstState();
}

class _AddChannelScreenFirstState extends State<AddChannelScreenFirst> {
  int? selectedItem;

  void selectItem(int item) {
    setState(() {
      selectedItem = item;
    });
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
              const SizedBox(height: 32.0),
              const Text(
                "1. Select a channel type",
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: AppColors.mellowLemon,
                ),
              ),
              const SizedBox(height: 24.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectItem(0);
                      widget.onComplete(); // Inform parent widget of completion
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      padding: const EdgeInsets.all(5.0),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fixed day challenge",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              color: AppColors.royalPurple,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "Create a dedicated space for continuous improvement in your chosen field. Set your channel duration for an extended period, allowing members to commit to ongoing growth and progress over 1000 days or more. Share, learn, and evolve together in this focused and dedicated environment.",
                            style: TextStyle(
                              fontFamily: "WorkSans",
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.royalPurple,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      selectItem(0);
                      widget.onComplete(); // Inform parent widget of completion
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      padding: const EdgeInsets.all(5.0),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unfixed day challenge",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              color: AppColors.royalPurple,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "Create a dedicated space for continuous improvement in your chosen field. Set your channel duration for an extended period, allowing members to commit to ongoing growth and progress over 1000 days or more. Share, learn, and evolve together in this focused and dedicated environment.",
                            style: TextStyle(
                              fontFamily: "WorkSans",
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.royalPurple,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
